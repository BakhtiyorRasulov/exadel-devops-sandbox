# Task4 of devops sandbox #

- [x] 1. Deploy 3 vmachines in the cloud, install ansible for one of them
- [x] 2. Ping pong between machines
- [x] 3. Write playbook, install docker on other 2


### STEP 1 ###

We are going to use terraform to automate instance creation and docker installation;
We are goint to create additional resources like:
1. Ubuntu central for Ansible control machine
2. Ubuntu workstation 1
3. Ubuntu workstation 2

`terraform apply -var-file="secret.tfvars" -auto-approve`

### STEP 2 ###

Ansibel comes with different control styles:
* Ad-hoc
* Playbook

Basically ad-hoc is one liner, command line option.

First to connect other hosts e.g. other machines we define them in /etc/ansible/hosts 
hosts:
```bash
[linux]
172.31.90.77
172.31.90.107

[linux:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ubuntu/keypair1devops2.pem
```

As you can see we can use aws pem file to connect. We should copy pem file to our machine with:
`scp -i "keypair1devops2.pem" keypair1devops2.pem ubuntu@ec2-54-227-123-219.compute-1.amazonaws.com:/home/ubuntu/`

once it is done, we can issue `ansible linux -m ping`
We should recieve SUCCESS response from each IP.

Additionally, since we didn't add other machines to `~/.ssh/known_hosts` we will get this kind of warning:
```bash
The authenticity of host 'IP (IP)' can't be established.
ED25519 key fingerprint is SHA256:somefingerprint.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])
```

Either we should add them to known_hosts or add/uncomment this line:
```bash
[defaults]
host_key_checking = False
```

### STEP 3 ###

Playbook on the other hand uses yaml based infrastructure configuration approach.
playbook is divided into 2 parts such as:
* hosts
* tasks
Hosts section will define which host to connect:
```yaml
- hosts: linux
  become: true
  vars:
    ***
```
become: true will say that all commands will be run through root.
We can also defien variables inside hosts section:
```yaml
vars:
    container_count: 4
    default_container_name: docker
    default_container_image: ubuntu
    default_container_command: sleep 1d
```
To access these variable jinja2 templating is used.
* container_count is how many containers to create
* default_container_name: is container name
* default_container_image any container image (maybe hello-world, ubuntu)
* default_container_command command to do inside container

Tasks section will define what kind of tasks should be done.
Inside tasks section are built-in modules of ansible which can connect with different applications.

For example if we want to `apt update` before installing aptitude package in ubuntu machine:
```yaml
apt:
    name: aptitude
    state: latest
    update_cache: true 
```

using apt module we can also import gpg key of docker as well as add docker repo
```yaml
- name: Add Docker GPG apt Key
    apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg
    state: present

- name: Add Docker Repository
    apt_repository:
    repo: deb https://download.docker.com/linux/ubuntu focal stable
    state: present
```

to manage docker, pull or run, community.docker.docker_image, community.docker.docker_container:
```yaml
- name: Pull default Docker image
    community.docker.docker_image:
    name: "{{ default_container_image }}"
    source: pull

- name: Create default containers
    community.docker.docker_container:
    name: "{{ default_container_name }}{{ item }}"
    image: "{{ default_container_image }}"
    command: "{{ default_container_command }}"
    state: present
    with_sequence: count={{ container_count }}
```

This `with_sequence: count=4` is ansible way of for loop. 
Since `container_count` is set to 4. It will run 4 times.