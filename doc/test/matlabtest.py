"""Module to call MATLAB and get the output."""

# Module that replaces "system" in Python
from subprocess import check_output

# Function to call MATLAB and get the stdout as a string.
def matlab(cmd):
	"""
	Function to call MATLAB and return the output as a string.
	"""
	# Versions:
	#  2013-10-09 @dalle   : First version
	
	# "Call" MATLAB
	a = check_output(["matlab", "-nodesktop", "-nosplash",
		("-r \"try,%s;end,exit\"" % cmd)])
	# Strip out the extra (and weird) characters.
	return a[343:-7]
