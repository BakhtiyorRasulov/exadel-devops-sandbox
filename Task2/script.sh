#!/bin/bash
if (( $EUID != 0 ))
	then echo "You must be root to run this file"
	exit
	else amazon-linux-extras install nginx1
		if [[ $(systemctl is-active --quiet nginx) ]]; then service nginx start; fi
		echo Configuring index html
		cd /usr/share/nginx/html
		mv index.html preindex.html
		echo "<pre>" > index.html
		echo "Hello World" >> index.html
		echo "<br>" >> index.html
		df -h / >> index.html
		echo "<br>" >> index.html
		free -th >> index.html
		echo "</pre>" >> index.html
		echo Done!
fi
