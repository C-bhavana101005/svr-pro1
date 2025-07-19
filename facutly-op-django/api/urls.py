from rest_framework.routers import DefaultRouter
from .views import ProfileViewSet, login_view, ProfileListCreateView, ProfileDetailView
from django.urls import path, include
from api import views

router = DefaultRouter()
router.register(r'profiles', ProfileViewSet)

urlpatterns = [
    path('login/', login_view),  # <-- add this line
    path('profiles/', ProfileListCreateView.as_view(), name='profile-list-create'),
    path('profiles/<int:pk>/', ProfileDetailView.as_view(), name='profile-detail'),  # <- update
    path('check_mobile/', views.check_mobile_unique),
    path('check_employee_id/', views.check_employee_id),
]

urlpatterns += router.urls
