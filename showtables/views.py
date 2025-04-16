# from django.shortcuts import render

# # Create your views here.
# from django.http import HttpResponse
# from django.db import connection
# from . import forms


# def my_custom_sql():
#     with connection.cursor() as cursor:
#         cursor.execute("select * from test")
#         row = cursor.fetchone()

#     return row



# def index(request):
#     return HttpResponse(my_custom_sql())


from django.shortcuts import render
from django.http import HttpResponse
from django.db import connection

def check_credentials(username, password):
    """ Check if the username and password exist in the database """
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM student WHERE name = %s AND registration = %s", [username, password])
        row = cursor.fetchone()
        print(row)
    return row is not None  # Returns True if credentials are valid

def index(request):
    if request.method == "POST":
        username = request.POST.get("username")
        password = request.POST.get("password")

        if check_credentials(username, password):
            return HttpResponse("Login Successful")
        else:
            return HttpResponse("Invalid Credentials")

    return render(request, "index.html")  # Render an HTML template
