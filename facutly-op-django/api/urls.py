from rest_framework.routers import DefaultRouter
from .views import ProfileViewSet, login_view, ProfileListCreateView, ProfileDetailView
from django.urls import path, include

router = DefaultRouter()
router.register(r'profiles', ProfileViewSet)

urlpatterns = [
    path('login/', login_view),  # <-- add this line
    path('profiles/', ProfileListCreateView.as_view(), name='profile-list-create'),
    path('profiles/<int:pk>/', ProfileDetailView.as_view(), name='profile-detail'),  # <- updated
    path('api/', include(router.urls)),
]

urlpatterns += router.urls
