#!/bin/bash

# script checked by http://www.shellcheck.net

# to use this script add this line in your CRON
# 0 2 * * * /etc/hephaiscode/cron-update-email.sh your@email.com
# or use this form by command
# wget https://raw.githubusercontent.com/HephaisCode/HXAutoUpdateServerSH/master/cron-update-form.sh --output-document=/etc/hephaiscode/cron-update-form.sh --no-cache && chmod +x /etc/hephaiscode/cron-update-form.sh && /etc/hephaiscode/cron-update-form.sh
# I notify the version of script
tmp_version="0.9.8";
echo $"******** version $tmp_version ********"
# check root
if [ "$(whoami)" != 'root' ]
then
	echo $""
	echo $" ! ERROR : You have no permission to run $0 as non-root user, use sudo"
	echo $""
	echo $"**** Aborted "
	echo $""
	exit 1
else
	# Ok I am root
	echo $""
	echo $"**** Hello! I'll notify update by email :-)"
	# had you give me param to work?
	tmp_root_mail=$1
	tmp_server_name=$2
	# get ip & hostname
	tmp_ip=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
	tmp_hostname=$(hostname)
	# create constants
	tmp_newline='
	'
	tmp_today=$(date +"%Y-%d-%m")
	tmp_time=$(date +"%T")
	# init email
	tmp_mail="Hello, root$tmp_newline$tmp_newline You run $0 script on $tmp_ip at $tmp_today $tmp_time$tmp_newline"
	tmp_mail="$tmp_mail$tmp_newline host ip : $tmp_ip $tmp_newline hostname : $tmp_hostname $tmp_newline"
	tmp_mail="$tmp_mail$tmp_newline You ran # *0 $tmp_newline"
	tmp_mail=$"$tmp_mail$tmp_newline --------------------"
	# disk space informations
	tmp_preview_current_space=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
	# check update
	apt-get update
	# get new version from hephaiscode script :-p

	#install auto update script
	echo $" install auto update script"

	wget https://raw.githubusercontent.com/HephaisCode/HXAutoUpdateServerSH/master/cron-update-email.sh --output-document=/etc/hephaiscode/cron-update-email.sh --no-cache
	wget https://raw.githubusercontent.com/HephaisCode/HXAutoUpdateServerSH/master/cron-update-form.sh --output-document=/etc/hephaiscode/cron-update-form.sh --no-cache
	chmod +x /etc/hephaiscode/cron-update-email.sh
	chmod +x /etc/hephaiscode/cron-update-form.sh

	#install disk space check
	echo $" install disk space check script"

	wget https://raw.githubusercontent.com/HephaisCode/HXDiskSpaceLeftOnServerSH/master/cron-disk-space-alert-email.sh --output-document=/etc/hephaiscode/cron-disk-space-alert-email.sh --no-cache
	wget https://raw.githubusercontent.com/HephaisCode/HXDiskSpaceLeftOnServerSH/master/cron-disk-space-email.sh --output-document=/etc/hephaiscode/cron-disk-space-email.sh --no-cache
	wget https://raw.githubusercontent.com/HephaisCode/HXDiskSpaceLeftOnServerSH/master/cron-disk-space-form.sh --output-document=/etc/hephaiscode/cron-disk-space-form.sh --no-cache
	chmod +x /etc/hephaiscode/cron-disk-space-alert-email.sh
	chmod +x /etc/hephaiscode/cron-disk-space-email.sh
	chmod +x /etc/hephaiscode/cron-disk-space-form.sh

	#install website management script
	echo $" install website management script"
	wget https://raw.githubusercontent.com/HephaisCode/HXWebServerAutoSaveInstallSH/master/website-add-user.sh --output-document=/etc/hephaiscode/website-add-user.sh --no-cache
	wget https://raw.githubusercontent.com/HephaisCode/HXWebServerAutoSaveInstallSH/master/website-delete-user.sh --output-document=/etc/hephaiscode/website-delete-user.sh --no-cache
	chmod +x /etc/hephaiscode/website-add-user.sh
	chmod +x /etc/hephaiscode/website-delete-user.sh

	# do clean
    apt-get clean
    # do update
	tmp_update_status=$(apt-get -y dist-upgrade)
	tmp_mail=$"$tmp_mail$tmp_newline$tmp_update_status$tmp_newline"
	# append email info about space disk
	tmp_infos=$( df -h)
	tmp_current_space=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
	tmp_mail=$"$tmp_mail$tmp_newline --------------------"
	tmp_mail=$"$tmp_mail$tmp_newline $tmp_preview_current_space become $tmp_current_space"
	tmp_mail=$"$tmp_mail$tmp_newline --------------------"
	tmp_mail=$"$tmp_mail$tmp_newline $tmp_infos"
	# verif if we have email to send result
	tmp_rootmail=$1
	if [ ! -z "$tmp_rootmail" ]
	then
		# send email
		mail -s "[$tmp_server_name] Server updated" "$tmp_rootmail" <<EOF
$tmp_mail
EOF
		echo $""
		echo $"**** Succesful! "
		echo $""
	else
		echo " ! ERROR : The root's mail $tmp_root_mail is empty! :-/ Abort the script!"
		echo $""
		echo $"**** Aborted "
		echo $""
	fi
fi