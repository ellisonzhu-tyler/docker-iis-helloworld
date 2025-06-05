FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022

RUN mkdir C:\MyWebsite

RUN powershell -NoProfile -Command \
    Import-Module WebAdministration; \
    Remove-Website -Name 'Default Web Site'; \
    New-Website -Name "MyWebsite" -PhysicalPath C:\MyWebsite -Port 80

EXPOSE 80

ADD WebsiteFiles/ /MyWebsite