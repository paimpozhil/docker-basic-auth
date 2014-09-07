#/bin/bash
## Generating a random password & displaying it to stdout
pass=$(pwgen -s 35 1) 
if [ ! -f /etc/nginx/.htpasswd ];
then
	htpasswd -bc /etc/nginx/.htpasswd docker-user $pass 
	echo $pass
fi
nginx

