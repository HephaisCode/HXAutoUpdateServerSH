#!/bin/bash

# script checked by http://www.shellcheck.net

# I clean the terminal
clear

# I notify the version of script
tmp_version="0.9.9";
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
	echo $"**** Hello! I'll assist you to install new update shell for debian by cron :-)"
	# had you give me param to work?
	tmp_root_mail=$1
	tmp_server_name=$2
	# constants
	tmp_newline='
'
	tmp_hour=3;
	# --- get root email ---
	# use ereg to valid a read value
	tmp_valid_int=1
	tmp_valid_ereg='^[a-zA-Z0-9\.\_\%\+\-]+@[a-zA-Z0-9\.\_\%\+\-]+\.[a-zA-Z0-9]{2,}$'
	if ! [[ $tmp_root_mail =~ $tmp_valid_ereg ]]
	then
		echo $""
		echo $"**** Please enter Root's email for notification"
		while [ $tmp_valid_int == 1 ]
		do
			read -p "Enter root's email " tmp_value
			if [ -z "$tmp_value" ]
			then
				tmp_root_mail=''
				tmp_valid_int=0
			fi
			if [[ $tmp_value =~ $tmp_valid_ereg ]]
			then
				tmp_root_mail=$tmp_value
				echo $" > Root's email $tmp_value is valid"
				tmp_valid_int=0
			else
				echo $" ! ERROR : Root's contact email doesn't respect the regular expression $tmp_valid_ereg"
			fi
		done
	fi
	# --- got root email ---

	# --- get server name ---
	# use ereg to valid a read value
	tmp_valid_int=1
	tmp_valid_ereg='^[a-zA-Z0-9\.\_\%\+\-]{1,32}$'
	if ! [[ $tmp_server_name =~ $tmp_valid_ereg ]]
	then
		echo $""
		echo $"**** Please enter Server's name for notification"
		while [ $tmp_valid_int == 1 ]
		do
			read -p "Enter Server's name : " tmp_value
			if [ -z "$tmp_value" ]
			then
				tmp_server_name=''
				tmp_valid_int=0
			fi
			if [[ $tmp_value =~ $tmp_valid_ereg ]]
			then
				tmp_server_name=$tmp_value
				echo $" > Server's name $tmp_server_name is valid"
				tmp_valid_int=0
			else
				echo $" ! ERROR : Server's name doesn't respect the regular expression $tmp_valid_ereg"
			fi
		done
	fi
	# --- got server name ---

	if [ ! -z "$tmp_root_mail" ]
	then
		# create the folder
		mkdir -p /etc/hephaiscode
		# create cron
		# wget the script
		wget https://raw.githubusercontent.com/HephaisCode/HXAutoUpdateServerSH/master/cron-update-email.sh --output-document=/etc/hephaiscode/cron-update-email.sh --no-cache
		# authorize the script
		chmod +x /etc/hephaiscode/cron-update-email.sh
		# write out current crontab
		crontab -l > cron-update-email
		# echo new cron into cron file
		tmp_line=$"$tmp_newline0 $tmp_hour \* \* \* \/etc\/hephaiscode\/cron-update-email.sh $tmp_root_mail"
		sed -i "s:${tmp_line}::" cron-update-email
		echo $"0 $tmp_hour * * * /etc/hephaiscode/cron-update-email.sh $tmp_root_mail $tmp_server_name" >> cron-update-email
		# install new cron file
		crontab cron-update-email
		rm cron-update-email
		echo $" > cron for cron-update-email.sh was added"
		# finsih :-p 
		echo $" > You can check the cron tab by command 'crontab -l'"
		echo $" > You can edit the cron tab by command 'crontab -e'"
		/etc/hephaiscode/cron-update-email.sh "$tmp_root_mail" "$tmp_server_name"
		echo $" > We ran the script for a test : check your email"
		echo $""
		echo $"**** Succesful! "
		echo $""
		exit 0
	else
		echo " ! ERROR : The root's email $tmp_root_mail is empty! :-/ Abort the script!"
		echo $""
		echo $"**** Aborted "
		echo $""
		exit 1
	fi
fi
