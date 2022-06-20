# Task2 of devops sandbox #

### TL;DR ###
##### [Goto steps -> ](#Step-1 "Section include steps") ##### 
- [x] Create 2 EC2 Instance t2.micro with different os (Amazon linux / Ubuntu ...)
	- [x] Try to stop them, restart, delete, recreate.
- [x] Check ssh connection from my pc to created EC2.
	- [x] Public IP address is used.
	- [x] Ping and ssh are allowed between instances
	- [x] Added ssh-public key to each other's ~/.ssh/authorized_key
- [x] Install webserver nginx
	- [x] web page including hello world and additional info

        >	While doing this part of task, made a script to automate for further.

    - [x] web content is accessible to whole internet
    - [x] used curl to print web page content

        > Tested on both public and private IP address
        curl http://<ip>

- [x] Created instances in different VPC (from eu frankfurt)
	- [x] Checked connectivity between other EC2
	- [x] install webserver and create web page with bash script
	- [x] ran ssh connection through terminal of my pc

### Step 1 ###

Amazon web services includes different types of services.
We can find our EC2 from Services dashboard>Compute>EC2.

> EC2 is virtual servers in the cloud. 

EC2 instances are created inside EC2 dashboard. Launch instances button will ask information instance should be created.
From there we choose operating systems, like Amazon Linux, Ubuntu, Windows...

As for instance type we choose t2.micro
For key pair (login) we create/select key pair. Used for ssh to host from our PC, no need for sharing public key.
For network setting we use it as it is. But we can enable: Allow HTTP traffic from the internet
Storage and Advanced details we leave  as it is.

Once instance is created we will be notified about new instance.

### Step 1.1 ###

Inside instances dashboard we can see Instance state button. Which includes:
	1. Stop instance
	2. Start instance
	3. Reboot instance
	4. Hibernate instance
	5. Terminate instance

> Terminate instance will delete whole install with storage data

We can play as much as we want with instance states.

### Step 2. ###

We simply ssh to server using:
```bash 
ssh -i "keypair.pem" hostaddress
```

We can see it by pressing connect button on dashboard, and switching to ssh client tab. For me it is:
```bash
ssh -i "keypair1devops2.pem" ec2-user@ec2-54-208-54-28.compute-1.amazonaws.com
```

Then let's ping between instances.
`ping <publicIP>`
`ping <privateIP>`
```bash
ping 3.90.50.132
ping 172.31.87.39
```

In both cases we get time out or no response, due to AWS security group disabling ICMP packet by default.
But ssh logins are allwed between instances.
I copied public keys in both machines and added to ~/.ssh/authorized_keys

### Step 3 ###

Installing web service to host.
I sshed to amazon linux. And started to install nginx web service. Since amazon linux uses Red Hat Linux, package installation line is `sudo yum install nginx`. But Amazon linux uses __amazon-linux-extras__ to install nginx: `sudo amazon-linux-extras install nginx1`

After installing nginx we should enable "autorun" for service with `sudo systemctl enable nginx`, thus whenever we restart our machine, nginx will automatically starts.

Usually nginx stores its 'htdocs' in _/usr/share/nginx/html_
When we access to http:// nginx automatically serves an **index.html**. So we should edit index.html inside html directory.

Instead of editing first we will backup it with `mv index.html preindex.html`

> It is better to backup privilaged files.

Now we can use our favorite text editors like vi, vim, nano to create and edit *index.html*. What we want to include is Hello world, free disk space, free memory.
Free disk space: `df -h` _an -h flag will print space in human readable format_
Free memory: `free -th` _-t flag will include total size column; -h human readable_

To print it as it is inside html we can use pre html tag.

To check our content we can access it with simple browser. As well as we can check it using command line (maybe from other ec2 host)
I tested both private and public address of ec2 host serving nginx
`curl 54.208.54.28`
`curl 172.31.94.161`

```
<pre>Hello World
<br>Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        474M     0  474M   0% /dev
tmpfs           483M     0  483M   0% /dev/shm
tmpfs           483M  468K  483M   1% /run
tmpfs           483M     0  483M   0% /sys/fs/cgroup
/dev/xvda1      8.0G  1.6G  6.5G  20% /
tmpfs            97M     0   97M   0% /run/user/1000
tmpfs            97M     0   97M   0% /run/user/0
<br>              total        used        free      shared  buff/cache   available
Mem:           965M         92M        338M        472K        534M        742M
Swap:            0B          0B          0B
</pre>
```

### Step 4 ###
To create instance in different VPC we should change to different VPC inside our dashboard. We can choose VPC from right corner of AWS web page. Default mine was _North Virginia_ I changed it to _Frankfurt_

Instance creation in different VPC is same.
To check wheter ssh working we can ssh to machine with: `ssh ec2-user@ec2-52-28-49-255.eu-central-1.compute.amazonaws.com`. Since we didn't shared public keys we get access denied.

Next step is to install web server and configure as previous host. To do this I created a bash script and added to github. So in order to access we git clone. But first we should install git as well.
```
sudo yum install git
git clone https://github.com/BakhtiyorRasulov/exadel-devops-sandbox/
```
then we change to our directory `cd exadel-devops-sandbox/Task2`. After that we execute or script in root(`sudo su`): `./script.sh`
After installation we get running nginx. We can check by browser and _curl_ it from command line, from other ec2 included.

All that we can do by using our pc terminal. Not AWS web terminal. All we need to do is use pem key we downloaded when we have given while creating our instance. It is like:
`ssh -i "keypair1devops2.pem" ec2-user@ec2-54-208-54-28.compute-1.amazonaws.com`
Then we are in our host server.