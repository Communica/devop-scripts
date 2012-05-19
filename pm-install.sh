#!/bin/bash

#
#	@author: technocake
#	@description Installs CPAN perl modules using perl itself via the perl -MCPAN -e 'CPAN::Shell->install("MODUL");' command. "
#
#	@changellog
#	when		who		what
#	14.02.12	technocake	Made the wrapper around the command provided by jocke
#

usage() {
	echo -e "\tUsage: $0 <module> "
	echo
	echo " Installs CPAN perl modules using perl itself via the perl -MCPAN -e 'CPAN::Shell->install("MODUL");' command. "

}

if [ $# -eq 0 ]; then
	usage
	exit 0	
fi

	#ACTUALLY INSTALLING THE MODULE

	perl -MCPAN -e "CPAN::Shell->install('$1');"

