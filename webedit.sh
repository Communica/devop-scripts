#!/bin/bash
#
#	@desc:	 quick script to just get to edit your configz in apache
#	@author:	technocake
#	
#	history:
#	who		when		what
#	technocake	310112		Made the script.	
#	technocake	130212		when ran with a site that does not yet exist, it lists all sites and give you the option to copy the config of one of them in to the new site config file. 
#	technocake	170212		Now it makes the webdir and chmods it too on new sites. Hardcoded y /Y /yes /YES to trigger reload * Made some restructuring using functions
#	technocake	070312		Fixed a bug that made all edits think it was creating a new site. Fixed permissions to 640 on files and +x on all directories (750)
#


#NB keep trailing slash...
base_url=/etc/apache2/sites-available/		#Config dir
web_base_url=/var/www/				#Web Document root dirs
reboot_cmd="apache2ctl graceful"
web_dir_perms=0640
#Folders will get a +x by the command find <dir> -type d -exec chmod ug+x {} \;

rebootApachePrompt() {
       echo "Wanna reload the config into the webserver?(i.o.w run apache2ctl graceful) [y]: "
        read reboot
        if [ "$reboot" = "" ] || [ "$reboot" = 'y' ] || [ "$reboot" = 'Y' ] || [ "$reboot" = 'yes' ] || [ "$reboot" = 'YES' ];then
                $reboot_cmd
        fi
}

makeWebDir() {
	#params: $1 = Site	
	webDir="$web_base_url$1"
	echo "Making web dir @ $webDir"
	mkdir "$webDir"
	chgrp -R www-data $webDir
	chmod -R $web_dir_perms $webDir
	#Fixing folders to have +x. 
	find $webdir -type d -exec chmod ug+x {} \;
	
}

if [ "$#" -eq 0 ];then
	echo "pls state the name of the site: "
	echo
	echo
	echo "	Usage:	$0 <site-name> "
	echo
	echo "Example:	$0 www.komsys.org"

	else
	
	echo "on we go" 
	site=$base_url$1
	site_rel=$1 #relative site name. Ie. only site name, not path.
	          #this obviously printed the name of the file i parsed at cmd line
	new_site=false
	
	if [ ! -f "$site" ]; then
		new_site=true	
		echo "You are now creating a new config file for the site $1"
		i=1

		#Serving the copy menu (Old configs to copy from)

		for f in `ls "$base_url" -1`; do
			if [ $((i % 2)) -eq 1 ]; then
				echo -n "$i: $f"
			else
				echo -e "\t\t$i: $f"
			fi

			#putting list in arrah
			sites[$i]=$f
			i=$((i + 1)) 
		done

		echo "Copy config from? [0 -> blank]: "
		read copyFrom

		expr $copyFrom + 1 2> /dev/null
		if [ $? = 0 ]; then
			copySite=$base_url${sites[$copyFrom]}
			echo Copying from "$copySite"
			cp "$copySite" "$site"
		fi
		
	fi
	
	vim "$site"
	
	if  $new_site ; then  #Got burned on this one. to test a boolean variable, dont surround it by [ $bool ]!!!!!
		echo "New site!"
		makeWebDir "$site_rel"
		a2ensite "$site_rel"
	fi

	rebootApachePrompt
fi
