from django.shortcuts import render
from rest_framework import viewsets, status
from .models import Profile
from .serializers import ProfileSerializer
from django.contrib.auth import authenticate
from rest_framework.decorators import api_view, action
from rest_framework.response import Response
from django.contrib.auth.models import User
from rest_framework import generics
from django.http import JsonResponse

@api_view(['DELETE'])
def permanently_delete_profile(request, pk):
    try:
        profile = Profile.objects.get(pk=pk)
        profile.delete()  # Fully delete from DB
        return Response(status=status.HTTP_204_NO_CONTENT)
    except Profile.DoesNotExist:
        return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def check_mobile_unique(request):
    mobile = request.GET.get('mobile')
    exists = Profile.objects.filter(mobile=mobile).exists()
    return JsonResponse({'is_unique': not exists})

def check_employee_id(request):
    emp_id = request.GET.get('employee_id', '')
    exists = Profile.objects.filter(employee_id=emp_id).exists()
    return JsonResponse({'exists': exists})

class ProfileViewSet(viewsets.ModelViewSet):
    queryset = Profile.objects.filter(is_deleted=False)
    serializer_class = ProfileSerializer

    def destroy(self, request, *args, **kwargs):
        profile = self.get_object()
        profile.is_deleted = True
        profile.save()
        return Response({'status': 'deleted'}, status=status.HTTP_204_NO_CONTENT)

    @action(detail=True, methods=['post'])
    def restore(self, request, pk=None):
        try:
            profile = Profile.objects.get(pk=pk, is_deleted=True)
            profile.is_deleted = False
            profile.save()
            return Response({'status': 'restored'})
        except Profile.DoesNotExist:
            return Response({'error': 'Not found or already restored'}, status=status.HTTP_404_NOT_FOUND)

    @action(detail=False, methods=['get'])
    def deleted(self, request):
        deleted_profiles = Profile.objects.filter(is_deleted=True)
        serializer = self.get_serializer(deleted_profiles, many=True)
        return Response(serializer.data)


@api_view(['POST'])
def login_view(request):
    username = request.data.get('username')
    password = request.data.get('password')

    user = authenticate(username=username, password=password)

    if user is not None:
        return Response({
            "message": "Login successful",
            "user_id": user.id,
            "username": user.username,
            "email": user.email,
            "designation": getattr(user, 'profile', {}).get('designation', 'principal')  # optional
        })
    else:
        return Response({"message": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

class ProfileListCreateView(generics.ListCreateAPIView):
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer

class ProfileDetailView(generics.RetrieveUpdateDestroyAPIView):  # <- updated view
    queryset = Profile.objects.all()
    serializer_class = ProfileSerializer
