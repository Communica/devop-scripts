#!/usr/bin/env python
#
#	CommuniWol	Waking hosts using wake on lan in intervals.  
#			Handy if you want to reboot a server park after 
#			a power failure, but not create a power-failure. 
#	
#	@author:	technocake
#	@dependency:	wakeonlan (debian package)
#
#############################################################################
import os, sys, time, re

def wol(mac):
	""" Handling the wakeup by calling a wol tool """
	os.system("/usr/bin/wakeonlan %s" % (mac, ) )

def usage():
	return """
                Usage:  communiWol.py [host-file]
                (all hosts are in the script)
	"""
DEFAULT_WAKEUP_INTERVAL  = 1 #s
DEFAULT_WAKEUP_CALLS	 = 2 # WOL packets to send per host.



def parseHostFile(hostfile):
	""" Getting a list of macs from file  """
	hosts = {}
	for line in hostfile:
		if not line.rstrip(): #empty line
			continue
		if re.search("^[ \t]*$", line) != None: #only whitespace
			continue
		if re.search("^[ \t]*#|//", line) != None:
			continue #skipping this, its a comment!

		parts = line.split()
		if not len(parts) >= 2 : 
			continue #??? (not valid format hostname <mac> [<mac2>])

		for mac in parts[1:]:
			if re.search("^([a-f0-9|:])*", mac) == None:
				continue #not valid mac

		host = parts[0]
		hosts[host] = parts[1:]
                #remember to parse file acordingly.
                #hostname mac(s) per line
	return hosts

if __name__ == "__main__":
	if len(sys.argv) == 1:
		print ( usage() )

	if len(sys.argv) == 2:
		hostfile = open( sys.argv[1] )
		hosts = parseHostFile( hostfile )
	else:
		hosts = {
			'snipp' : ['00:0b:cd:ee:5f:ff'],
			'snapp' : ['00:0f:20:6b:3a:95'],
		}
	try:
		for host in hosts:
			for mac in hosts[host]:
				time.sleep(DEFAULT_WAKEUP_INTERVAL)
				print ( "Waking up host %s on mac %s" % (host, mac) )
				for packet in range(DEFAULT_WAKEUP_CALLS):
					print ("tries: %s" % str(packet+1) )
					wol(mac)
	except KeyboardInterrupt:
		print ( "Intterupted! Not waking the folkz up" )


