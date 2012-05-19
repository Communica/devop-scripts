#!/bin/bash
#author: jocke
die (){
        echo >&2 "$@"
        exit 1
}

function valid_ip(){
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

[ "$#" -eq 1 ] || die "1 argument required, $# provided"

if valid_ip $1; then
	# Stop denyhosts
	/etc/init.d/denyhosts stop
	
	# Delete lines
	files=( /etc/hosts.deny /var/lib/denyhosts/hosts /var/lib/denyhosts/hosts-restricted /var/lib/denyhosts/hosts-root /var/lib/denyhosts/hosts-valid /var/lib/denyhosts/users-hosts )
	for file in ${files[@]}; do
		sed -i '/'$1'/d' $file
	done
	
	# Start denyhosts
	/etc/init.d/denyhosts start

	# Restart SSH
	/etc/init.d/ssh restart
else 
	echo "Bad IP-address. Try again."
fi
