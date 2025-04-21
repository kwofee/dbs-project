from django.urls import path
from . import views



urlpatterns = [
    path("", views.index, name="index"),
    path("project/<str:project_name>/", views.student_project_dashboard, name="student_project_dashboard"),
    path("manage/<str:project_name>/", views.manage_project, name="manage_project"),
    path('faculty_dashboard/', views.faculty_dashboard, name='faculty_dashboard'),
    path("project/<str:project_name>/manage/", views.manage_project, name="manage_project"),
    path('student_project/<str:project_id>/', views.student_project_dashboard, name='student_project_dashboard'),
    path('project/<str:project_id>/', views.student_project_dashboard, name='student_project_dashboard'),
    path('submit-fund-request/', views.submit_fund_request, name='submit_fund_request'),
    path("approve-request/", views.approve_request, name="approve_request"),
    path('deny-request/', views.deny_request, name='deny_request'),



]


