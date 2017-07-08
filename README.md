# docker-iis-helloworld
A simple hello world for a docker container running an IIS website

This readme assumes that you have already have docker installed. 
find more information regarding installing docker at:

https://docs.docker.com/docker-for-windows/


To create this image and run the container:

1. open a powershell window and navigate to the directory where the dockerfile exists
2. run the following command in the powershell window 
```
docker build -t iis-hello-world .

docker run -d -p 8000:8000 --name running-hello-world iis-hello-world
```

Look at all your running containers with 
```
docker ps
```

To view the details of the running container
```
docker inspect running-hello-world
```

We need the IP address of the running container to access it in a browser. Find it in the details, or use this command to inspect only the IP address detail:
```
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" running-hello-world
```

To view the iis website running in your container, open a browser and navigate to the IP address and port 8000 of the container.

http://{IP_Address_Of_Container}:8000