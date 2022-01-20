#!/bin/zsh

# Author: Andrew W. Johnson
# Date: 2022.01.19
# Version 2.00
# Organization: Stony Brook University/DoIT

# This JAMF script will take either a Policy ID number, or a Policy trigger (Custom Event Name) 
# in order to run a policy. It can handle up to 8 policy IDs or triggers passed to it in 
# the arguments/parameters, which start from the 4th.

#/bin/echo "Number of arguments: $#"
#/bin/echo "Arguments passed: $@"
	# Setup a number check variable.
re='^[0-9]+$'

	# Loop through the arguments starting at the 4th.
for ((i = 4; i <= ${#}; i++ )); do
		# If the argument is not a number then assume it's a trigger.
	if ! [[ ${@[i]} =~ ${re} ]]; then
		/bin/echo "jamf policy -trigger \"${@[i]}\""
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: jamf policy -trigger \"${@[i]}\"" >> /var/log/jamf.log
		/usr/local/bin/jamf policy -trigger "${@[i]}"
	else
		/bin/echo "jamf policy -id ${@[i]}"
		/bin/echo "$( /bin/date | /usr/bin/awk '{print $1, $2, $3, $4}' ) $( /usr/sbin/scutil --get LocalHostName ) $( /usr/bin/basename ${0} )[$$]: jamf policy -id ${@[i]}" >> /var/log/jamf.log
		/usr/local/bin/jamf policy -id ${@[i]}
	fi
done

exit 0

