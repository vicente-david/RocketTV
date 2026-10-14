from django.apps import apps
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import User

admin.site.register(User, UserAdmin)

for model in apps.get_app_config("api").get_models():
    if model is not User:
        admin.site.register(model)
