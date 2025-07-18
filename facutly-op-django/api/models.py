from django.db import models

class Profile(models.Model):
    GENDER_CHOICES = [('Male', 'Male'), ('Female', 'Female')]

    employee_id = models.CharField(max_length=50, unique=True)
    name = models.CharField(max_length=100)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES)
    designation = models.CharField(max_length=50)
    department = models.CharField(max_length=50)
    email = models.EmailField()
    mobile = models.CharField(max_length=15)
    address = models.TextField()
    image = models.ImageField(upload_to='staff_images/', null=True, blank=True)
    is_deleted = models.BooleanField(default=False)

    def __str__(self):
        return self.name
