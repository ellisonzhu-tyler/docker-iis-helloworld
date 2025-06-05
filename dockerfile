FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022

RUN mkdir C:\MyWebsite

RUN powershell -NoProfile -Command \
    Import-Module WebAdministration; \
    Remove-Website -Name 'Default Web Site'; \
    New-Website -Name "MyWebsite" -PhysicalPath C:\MyWebsite -Port 80

HEALTHCHECK --interval=15s --timeout=15s --start-period=60s --retries=3 CMD curl --fail http://localhost:80 || exit 1

EXPOSE 80

ADD WebsiteFiles/ /MyWebsite