# Task4 of devops sandbox #

- [x] 1. Install docker
- [x] 2. Run any docker Hello World container
- [x] 3. Create dockerfile with any web service
- [x] 4. Push docker image
- [x] 5. Create docker compose file


### STEP 1 ###

We are going to use terraform to automate instance creation and docker installation

### STEP 2 ###

First we will hello world image using `docker pull hello-world`
Once done we can use `docker run hello-world`

### STEP 3 ###

We create Dockerfile to tell structure of our container.
Dockerfile consist of multiple builtin keywords to specify what to do.
For example:
  FROM means which container image to use
  RUN to run commands
  CMD is to run command after starting finally.
  EXPOSE is to expose given port
  ENV is to create environmental variables

### STEP 4 ###

sudo docker login
sudo docker tag <image-id> <tag-name-we-want>
sudo docker push <name>
https://hub.docker.com/repository/docker/sampledockerid001007008/simpleubuntudockerimage


### STEP 5 ###

docker composer is a way to manage multiple, related containers.
docker composer is divied into services:
  service:
    nameofservice:
      entries
    nameofservice2:
      entries