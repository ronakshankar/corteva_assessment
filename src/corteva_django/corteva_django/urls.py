"""corteva_django URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from corteva_django import views
from rest_framework.urlpatterns import format_suffix_patterns

"""
All the URLs for the REST API Definied here

/api/weather/ - To view all the data in WEATHER. Calls weather_list from Views
/api/yield/ - To view all the data in YIELD. Calls yield_list from Views
/api/weather/year/station_id/ - To filter the WEATHER data based on year and station_id. Calls weather_stats from Views
"""
urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/weather/', views.weather_list),
    path('api/yield/', views.yield_list),
    path('api/weather/<int:year>/<str:station_id>', views.weather_stats)
]

"""
format_suffix_patterns() is used to return the JSON object when API.json is called
"""
urlpatterns = format_suffix_patterns(urlpatterns)