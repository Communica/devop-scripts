#!/bin/bash
#
#	@desc:	 quick script to tail -f / a www log
#	@author:	technocake
#	
#	history:
#	who		when		what
#	technocake	020212		Made the script.
#	technocake	020212		Added error / access log differentiation	
#


base_url="/var/log/apache2/"
prep_url=".log"



if [ "$#" -eq 0 ];then
	echo "pls state the name of the site: "
	echo
	echo
	echo "	Usage:	$0 <site-name> "
	echo
	echo "Example:	$0 www.komsys.org"

	else
	echo "on we go" 

	if [ "$2" = "error" ];then
		log="error-"
	else
		log="access-"
	fi
	site=$base_url$log$1$prep_url

	tail -f $site


fi
