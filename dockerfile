FROM microsoft/iis

RUN mkdir C:\MyWebsite

RUN powershell -NoProfile -Command \
    Import-module IISAdministration; \
    New-IISSite -Name "MyWebsite" -PhysicalPath C:\MyWebsite -BindingInformation "*:8000:"

EXPOSE 8000

ADD WebsiteFiles/ /MyWebsite