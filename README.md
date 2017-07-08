# docker-iis-helloworld
A simple hello world for a docker container running an IIS website

This readme assumes that you have already have docker installed. 
find more information regarding installing docker at:
https://docs.docker.com/docker-for-windows/


To create this image and run the container:

1. open a powershell window and navigae to the directory where the dockerfile exists
2. run the following command in the powershell window 
```
docker build -t iis-hello-world .

docker run -d -p 8000:8000 --name running-hello-world iis-hello-world
```

To view the iis website running in your container, open a browser and navigate to:
localhost:8000
