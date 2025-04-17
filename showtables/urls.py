from django.urls import path
from . import views

urlpatterns = [
    path("", views.index, name="index"),
    path("project/<str:project_name>/", views.student_project_dashboard, name="student_project_dashboard"),

    # 👉 Add this line:
    path("manage/<str:project_name>/", views.manage_project, name="manage_project"),

    path("project/<str:project_name>/manage/", views.manage_project, name="manage_project"),
]


