# Task4 of devops sandbox #

- [x] 1. Deploy 3 vmachines in the cloud, install ansible for one of them
- [x] 2. Ping pong between machines
- [x] 3. Write playbook, install docker on other 2


### STEP 1 ###

We are going to use terraform to automate instance creation and docker installation;
We are goint to create additional resources like:
1. Centos central for Ansible control machine
2. Centos workstation 1
3. Centos workstation 2

`terraform apply -var-file="secret.tfvars" -auto-approve`

### STEP 2 ###

Ansibel comes with different control styles:
    * Ad-hoc
    * Playbook

Basically ad-hoc is one liner, command line option.


### STEP 3 ###

Playbook on the other hand