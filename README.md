# HXUpdateServerSH

To send email with update status daily

##This for Debian

Use with system Debian 8.x

##Connect to server

Connect with terminal.app

```shell
ssh root@<vps-ip> -p 22
```
- if you have a message like "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!" use the following command to remove the file `rm /Users/Kortex/.ssh/known_hosts`
- if you have a message like "Are you sure you want to continue connecting (yes/no)? yes" tape `yes`


Tape your password
```shell
password : <your-password>
```


## Install Mail command
Check if PostFix is installed 

```
dpkg-query -l
```
If Postfix is not in the list : install it and configure for Internet WebSite
```
apt-get install postfix
```

To install `mail` command, use `apt-get`.

```
apt-get install mailutils
```

## Auto-create shell script

Get the form, and answer to the questions :-)

(copy and paste this command to download and run the script)

```
mkdir -p /etc/hephaiscode/ && wget https://raw.githubusercontent.com/HephaisCode/HXAutoUpdateServerSH/master/cron-update-form.sh --output-document=/etc/hephaiscode/cron-update-form.sh --no-cache && chmod +x /etc/hephaiscode/cron-update-form.sh && /etc/hephaiscode/cron-update-form.sh
```