# Task2 of devops sandbox #

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