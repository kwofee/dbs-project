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
                    return render(request, "faculty_dashboard.html", {"faculty": faculty_details})
                else:
                    messages.error(request, "Login Unsuccessful")
                    return redirect("index")

        except DatabaseError:
            messages.error(request, "Login Unsuccessful")
            return redirect("index")

    return render(request, "index.html")

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
def manage_project(request, project_name):
    try:
        with connection.cursor() as cursor:
            # Join `funded_by` with `student_project` to get the department, then get department budget
            cursor.execute("""
                SELECT d.dept_name, d.budget
                FROM department d
                JOIN student_project sp ON d.dept_name = sp.dept_name
                JOIN funded_by fb ON fb.studproj_name = sp.studproj_name
                WHERE sp.studproj_name = %s
            """, [project_name])
            
            project_info = cursor.fetchone()

        return render(request, "manage.html", {
            "project_name": project_name,
            "project_info": project_info
        })

    except DatabaseError:
        messages.error(request, "Unable to fetch department info.")
        return redirect("index")
from django.shortcuts import render
from django.db import connection

from django.shortcuts import render
from django.db import connection

def student_project_dashboard(request, project_name):
    # Updated project query to get faculty name
    project_query = """
    SELECT sp.studproj_name, f.name AS advisor_name
    FROM student_project sp
    JOIN faculty f ON sp.advisor = f.ID
    WHERE sp.studproj_name = %s
    """

    # Students in the same department as the project
    students_query = """
    SELECT st.registration_number, st.name, st.email
    FROM student st
    JOIN student_project sp ON sp.dept_name = st.dept_name
    WHERE sp.studproj_name = %s
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

        cursor.execute(students_query, [project_name])
        students = cursor.fetchall()

        cursor.execute(subsystem_query, [project_name])
        subsystem_info = cursor.fetchall()

    context = {
        'project': project,
        'students': students,
        'subsystem_info': subsystem_info,
    }

    return render(request, 'student_project_dashboard.html', context)


