#!/bin/bash
#
#	@desc:	wcd cds into the webfiles /var/www/<site-name>
#	@author:	technocake
#	
#	history:
#	who		when		what
#	technocake	310112		Made the script.	
#


base_url=/var/www/
if [ "$#" -eq 0 ];then
	echo "pls state the name of the site: "
	echo
	echo
	echo "	Usage:	$0 <site-name> "
	echo
	echo "Example:	$0 www.komsys.org "
	echo " Will cd to /var/www/www.komsys.org/"

	else
	echo "on we go" 
	site=$base_url$1
	          #this obviously printed the name of the file i parsed at cmd line
	cd $site


fi
