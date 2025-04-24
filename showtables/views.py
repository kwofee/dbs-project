from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.db import connection, DatabaseError
from django.contrib import messages  # <-- Import messages framework

def check_student_login(registration_number, email):
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM student WHERE registration_number = %s AND email = %s", [registration_number, email])
        return cursor.fetchone() is not None

def check_faculty_login(faculty_id, email):
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM faculty WHERE id = %s AND email = %s", [faculty_id, email])
        return cursor.fetchone() is not None

def index(request):
    if request.method == "POST":
        try:
            user_type = request.POST.get("user_type")

            if user_type == "student":
                reg_no = request.POST.get("reg_no")
                email = request.POST.get("student_email")

                if check_student_login(reg_no, email):
                    with connection.cursor() as cursor:
                        # Fetch student details
                        cursor.execute(
                            "SELECT registration_number, name, dept_name, email FROM student WHERE registration_number = %s",
                            [reg_no]
                        )
                        student_details = cursor.fetchone()

                        # Store student details in session
                        request.session['reg_no'] = student_details[0]
                        request.session['student_name'] = student_details[1]
                        request.session['student_department'] = student_details[2]
                        request.session['student_email'] = student_details[3]

                        # Fetch student project details
                        cursor.execute(
                            "SELECT studproj_name FROM works_on WHERE registration_number = %s",
                            [reg_no]
                        )
                        student_project = cursor.fetchone()

                    return render(request, "student_details.html", {
                        "student": student_details,
                        "student_project": student_project[0] if student_project else None
                    })
                else:
                    messages.error(request, "Login Unsuccessful")
                    return redirect("index")

            elif user_type == "faculty":
                faculty_id = request.POST.get("faculty_id")
                email = request.POST.get("faculty_email")

                if check_faculty_login(faculty_id, email):
                    with connection.cursor() as cursor:
                        cursor.execute(
                            "SELECT id, name, dept_name, email FROM faculty WHERE id = %s",
                            [faculty_id]
                        )
                        faculty_details = cursor.fetchone()
                        request.session['faculty_id'] = faculty_details[0]
                        request.session['faculty_name'] = faculty_details[1]
                        request.session['faculty_department'] = faculty_details[2]
                        request.session['faculty_email'] = faculty_details[3]
                        
                    return redirect('faculty_dashboard')
                else:
                    messages.error(request, "Login Unsuccessful")
                    return redirect("index")

        except DatabaseError:
            messages.error(request, "Login Unsuccessful")
            return redirect("index")

    return render(request, "index.html")

def faculty_dashboard(request):
    current_faculty_department = request.session.get('faculty_department')

    # Fetch faculty details from session
    faculty_id = request.session.get('faculty_id')
    faculty_name = request.session.get('faculty_name')
    faculty_department = request.session.get('faculty_department')
    faculty_email = request.session.get('faculty_email')

    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM fund_request WHERE status = %s AND department = %s", ['pending', current_faculty_department])
        fund_requests = cursor.fetchall()

    return render(request, 'faculty_dashboard.html', {
        'faculty': {
            'id': faculty_id,
            'name': faculty_name,
            'department': faculty_department,
            'email': faculty_email
        },
        'fund_requests': fund_requests
    })
from django.db import connection
from django.shortcuts import redirect

def approve_request(request):
    if request.method == "POST":
        request_id = request.POST.get("request_id")

        with connection.cursor() as cursor:
            cursor.execute("UPDATE fund_request SET status = %s WHERE req_id = %s", ['approved', request_id])

        request.session['approval_message'] = f"Request ID {request_id} approved successfully!"

    return redirect('faculty_dashboard')
from django.db import connection

def deny_request(request):
    if request.method == 'POST':
        req_id = request.POST.get('request_id')

        with connection.cursor() as cursor:
            cursor.execute("UPDATE fund_request SET status = 'denied' WHERE req_id = %s", [req_id])

        # Redirect back to faculty_dashboard with success message
        return redirect('faculty_dashboard')  # or use a session/message if needed










def student_project_dashboard(request, project_name):
    try:
        with connection.cursor() as cursor:
            # Fetch project details along with advisor name
            cursor.execute(
                """
                SELECT sp.studproj_name, f.name 
                FROM student_project sp
                JOIN faculty f ON sp.advisor = f.id
                WHERE sp.studproj_name = %s
                """,
                [project_name]
            )
            project_details = cursor.fetchone()

            # Fetch students working on the project
            cursor.execute(
                """
                SELECT s.registration_number, s.name, s.email 
                FROM student s 
                JOIN works_on w ON s.registration_number = w.registration_number 
                WHERE w.studproj_name = %s
                """,
                [project_name]
            )
            students = cursor.fetchall()

        return render(request, "student_project_dashboard.html", {
            "project": project_details,  # project.0 = name, project.1 = advisor name
            "students": students
        })
    except DatabaseError:
        messages.error(request, "Unable to load project details.")
        return redirect("index")
from django.views.decorators.csrf import csrf_exempt  # If CSRF token issues happen

def manage_project(request, project_name):
    try:
        with connection.cursor() as cursor:
            # Get department and budget info
            cursor.execute("""
                SELECT d.dept_name, d.budget
                FROM department d
                JOIN student_project sp ON d.dept_name = sp.dept_name
                JOIN funded_by fb ON fb.studproj_name = sp.studproj_name
                WHERE sp.studproj_name = %s
            """, [project_name])
            project_info = cursor.fetchone()

            # Get subsystems and their current heads
            cursor.execute("""
                SELECT s.subsystem_name, s.leader_regno, st.name
                FROM subsystem s
                JOIN student st ON s.leader_regno = st.registration_number
                WHERE s.studproj_name = %s
            """, [project_name])
            subsystems = cursor.fetchall()

            # Get all eligible students (from same department)
            cursor.execute("""
                SELECT s.registration_number, s.name
                FROM student s
                JOIN works_on w ON s.registration_number = w.registration_number
                WHERE w.studproj_name = %s
            """, [project_name])
            eligible_students = cursor.fetchall()

        if request.method == "POST":
            if "amount" in request.POST:
                # Handle fund request (existing code)
                # ...existing code...
                pass

        return render(request, "manage.html", {
            "project_name": project_name,
            "project_info": project_info,
            "subsystems": subsystems,
            "eligible_students": eligible_students
        })

    except DatabaseError as e:
        messages.error(request, "Unable to fetch project information.")
        return redirect("index")

def change_subsystem_head(request):
    if request.method == "POST":
        subsystem_name = request.POST.get("subsystem_name")
        new_leader_regno = request.POST.get("new_leader")
        project_name = request.POST.get("project_name")

        try:
            with connection.cursor() as cursor:
                # Call the stored procedure
                cursor.execute(
                    "CALL change_subsystem_leader(%s, %s, %s)",
                    [subsystem_name, new_leader_regno, project_name]
                )
                messages.success(request, f"Successfully updated subsystem head")
        except DatabaseError as e:
            messages.error(request, f"Failed to update subsystem head: {str(e)}")

        return redirect('manage_project', project_name=project_name)

def student_project_dashboard(request, project_name):
    # Updated project query to get faculty name and department name
    project_query = """
    SELECT sp.studproj_name, f.name AS advisor_name, sp.dept_name
    FROM student_project sp
    JOIN faculty f ON sp.advisor = f.ID
    WHERE sp.studproj_name = %s
    """

    # Students in the same department as the project
    students_query = """
    SELECT st.registration_number, st.name, st.email
    FROM student st
    JOIN works_on w ON st.registration_number = w.registration_number
    WHERE w.studproj_name = %s
    """

    # Subsystems and their leaders (updated s.project_name issue)
    subsystem_query = """
    SELECT s.subsystem_name, st.name AS leader_name
    FROM subsystem s
    JOIN student st ON s.leader_regno = st.registration_number
    JOIN student_project sp ON s.studproj_name = sp.studproj_name
    WHERE sp.studproj_name = %s
    """

    with connection.cursor() as cursor:
        cursor.execute(project_query, [project_name])
        project = cursor.fetchone()

        if project:
            # Save department name to session
            request.session['current_department'] = project[2]  # index 2 is dept_name

        cursor.execute(students_query, [project_name])
        students = cursor.fetchall()

        cursor.execute(subsystem_query, [project_name])
        subsystem_info = cursor.fetchall()

    context = {
        'project': project[:2],  # Only send name and advisor_name to template
        'students': students,
        'subsystem_info': subsystem_info,
    }

    return render(request, 'student_project_dashboard.html', context)



from django.utils import timezone

from django.contrib import messages
from django.shortcuts import redirect
from django.db import connection

from django.contrib import messages
from django.shortcuts import redirect

def submit_fund_request(request):
    current_department = request.session.get('current_department')

    if request.method == 'POST':
        reg_no = request.session.get('reg_no')
        project_name = request.POST.get('project_name')
        amount = int(request.POST.get('amount'))

        with connection.cursor() as cursor:
            # Get department budget
            cursor.execute("""
                SELECT d.budget
                FROM department d
                JOIN funded_by fb ON fb.dept_name = d.dept_name
                WHERE fb.studproj_name = %s
            """, [project_name])
            result = cursor.fetchone()

            if result and amount <= result[0]:
                cursor.execute("""
                    INSERT INTO fund_request (student_id, project_name, amount, department)
                    VALUES (%s, %s, %s, %s)
                    """, [reg_no, project_name, amount, current_department])
                messages.success(request, "✅ Fund request submitted successfully.")
            else:
                messages.error(request, "❌ Amount exceeds budget")

        #  Redirect to manage_project and pass project_name to it
        return redirect('manage_project', project_name=project_name)

def logout(request):
    request.session.flush()
    messages.info(request, "You have been logged out successfully")
    return redirect('index')


