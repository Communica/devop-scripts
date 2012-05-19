#!/bin/sh
#	@author: technocake
#	@description: chmods only directories (recursively), skipping all files.
#
#	@usage:	chmod-directories-only.sh [dir]
if [ $# -eq 1 ]; then
	directory=.
	perms=$1
elif [ $# -eq 2 ]; then
	directory=$2
	perms=$1
else 
	echo "Usage: $0 <permissions> [dir]"
	exit 1
fi

echo $perms $directory
find $directory -type d -exec chmod $perms {} \;



