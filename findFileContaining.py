#!/usr/bin/env python
# @author: technocake
# @desc :  finds all lines in files in a dir that contains what you're searching for.
#
#	version: 0.1
#
#	06.05.2011 technocake	made version 0.1  - no recursive
#	09.05.2011 technocake	Added recursive support to it
#	28.05.2011 technocake	Added the line output + match group to the output :) 
#				I.e, you see the content of the line too.
#	29.05.2011 technocake	Added some "narrow" binary support. I.e for searching pdfs. 
#				Not quite adequite
#
#######################################################################################
import sys, re, os

def usage():
	return """
		Usage: %s '<search for>' '<in dir> [-R]'	
		finds all files containing <search for> in the given dir
		The -R flag makes the search go recursively
	""" % (sys.argv[0])

class Config:
	""" The config class """

conf = Config()

def parse():
	""" pares() : Parses cli params.  Checks for recursive mode and configures the module"""
	if not len(sys.argv) >= 3:
		print ( usage() )
		sys.exit()
	#setting configs
	(conf.searchString, conf.rootDir) = sys.argv[1:3]
	
	args = sys.argv[2:]
	#The reason why I love python :)
	conf.recursive =  "-R" in args		


def find_file_containing(string, directory, pad=""):
	directory = os.listdir(directory)
	results = {}
	folders = []
	binaryFileTypes = ["pdf", "doc","docx"]
	output = ""

	for f in directory:
		if os.path.isdir(f):
			folders.append(f)
		if not os.path.isfile(f): continue
		line_number = 0
		#if not re.search("\.pdf$|\.PDF$", f) == None:i
		#Reads binary if binary filetype
		if f.split(".")[-1].lower() in binaryFileTypes:
			readType = "rb"
		#Reads normaly (text) if not binary file.
		else:
			readType = "rU"

		fileData = open(f, readType).readlines()

		for line in fileData:
			line_number += 1
			#Searching line for line with regexp 
			matches = re.search( string, line)
			if not matches == None:
				output +=  "%sFound match in file %s at line: %d\n" % (pad, f, line_number )
				output += "%s Group: %s \t Data: \n\t%s%s\n" % (pad, matches.group(), pad, line )
	if conf.recursive:
		for d in folders:
			output += "\n\n%s searching %s\n " %(pad, d,)
			output += "%s\t%s\n" %(pad, find_file_containing(string, "%s/%s"%(conf.rootDir, d), "%s\t"%(pad,)))
	return output


#If this is not imported as a module, it should do this:
#By this, I mean run as a script.  
if __name__  == "__main__":
	parse()
	print ( "Searching for files containing: %s in dir: %s" 
		% (conf.searchString, conf.rootDir) )
	print ( "Recursive mode : ",  conf.recursive )	
	
	#doing the search	
	try:
		print( find_file_containing(conf.searchString, conf.rootDir) )
	except KeyboardInterrupt: #a.k.a Ctrl + C
		print ( "\n Stopping search -  interrupted by user ;) " )
