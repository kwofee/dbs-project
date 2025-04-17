from django.urls import path

from . import views

urlpatterns = [  # Correct variable name
    path("", views.index, name="index"),
    path("project/<str:project_name>/", views.student_project_dashboard, name="student_project_dashboard"),
]


