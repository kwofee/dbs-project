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
                        cursor.execute(
                            "SELECT registration_number, name, dept_name, email FROM student WHERE registration_number = %s",
                            [reg_no]
                        )
                        student_details = cursor.fetchone()
                    return render(request, "student_details.html", {"student": student_details})
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
