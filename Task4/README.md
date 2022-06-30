# Task4 of devops sandbox #

- [x] 1. Install docker
- [x] 2. Run any docker Hello World container
- [x] 3. Create dockerfile with any web service
- [x] 4. Push docker image
- [x] 5. Create docker compose file


### STEP 1 ###

We are going to use terraform to automate instance creation and docker installation;
Basically terraform file is same as previous (task3) but without centos and it's network sec group

`terraform apply -var-file="secret.tfvars" -auto-approve`

### STEP 2 ###

After getting shell of our remote host, we initially search for hello-world image:
`docker search hello-world`
or we can search through browser

In either way to pull image we issue this command:
`docker pull hello-world`

Once we got the image we run it with:
`docker run -it hello-world`

Now if we issue `docker images` we will get all images inside our host.
Whereas `docker ps` will show all running containers in our host.
`docker ps -a` will show all containers, running or exited

### STEP 3 ###

We create Dockerfile to tell structure of our container.
Dockerfile consist of multiple builtin keywords to specify what to do.
For example:
  FROM means which container image to use
  RUN to run commands
  CMD is to run command after starting finally.
  EXPOSE is to expose given port
  ENV is to create environmental variables

If we use ubuntu:
`FROM ubuntu:latest`

if we want nginx as our web service:
`RUN apt install nginx -y`

if we want to give right to run on given ports of our machine:
`EXPOSE 80`
if port 80 is already in use it will throw an error.

if we want to have environmental variable:
`ENV varname=varvalue`
`ENV DEVOPS=bakhtiyor`


### STEP 4 ###

To push our image to hub docker we should create account first.
After creating an account we will create repository for image.
Logic is similar what we have on github.

Once done, in our host machine we should login to our user account:
`sudo docker login`
it will ask us username and password.

Then we should add tag for our docker image
Docker uses naming convention like:
  official: <image-name>
  unofficial: <username>/<imagename>
We are creating unofficial image so our command should be:
sudo docker tag firstdockerimage sampledockerid001007008/firstdockerimage

Then we simply push by our tag name:
sudo docker push sampledockerid001007008/firstdockerimage


https://hub.docker.com/repository/docker/sampledockerid001007008/firstdockerimage


### STEP 5 ###

docker composer is a way to manage multiple, related containers.
compose.yaml file we can define multi-container application

  service:
    nameofservice:
      entries
    nameofservice2:
      entries

We can define our previous image here in services:
```
task:
  image: sampledockerid001007008/firstdockerimage
  deploy:
    replicas: 5
```

We can use any other images like above.
To search image we do docker search, and find suitable image.

Also depends_on parametr will give order for creating of instances, like:
```
backend:
  image: javaee/springdemo
  depends_on:
    - db
db:
  image: mysql
```