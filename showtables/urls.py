from django.urls import path
from . import views



urlpatterns = [
    path("", views.index, name="index"),
    path("project/<str:project_name>/", views.student_project_dashboard, name="student_project_dashboard"),

    # 👉 Add this line:
    path("manage/<str:project_name>/", views.manage_project, name="manage_project"),
    path('faculty_dashboard/', views.faculty_dashboard, name='faculty_dashboard'),
    path("project/<str:project_name>/manage/", views.manage_project, name="manage_project"),
    path('student_project/<str:project_id>/', views.student_project_dashboard, name='student_project_dashboard'),
    path('project/<str:project_id>/', views.student_project_dashboard, name='student_project_dashboard'),
    path('submit-fund-request/', views.submit_fund_request, name='submit_fund_request'),
    #path('approve-fund-request/<int:request_id>/', views.approve_fund_request, name='approve_fund_request'),
    #path('view-fund-requests/', views.view_fund_requests, name='view_fund_requests'),
    #path("faculty/<int:faculty_id>/requests/", view_fund_requests, name="view_fund_requests"),
    #path("approve-request/<int:req_id>/<int:faculty_id>/", approve_fund_request, name="approve_fund_request"),
    #path("reject-request/<int:req_id>/<int:faculty_id>/", reject_fund_request, name="reject_fund_request"),



]


