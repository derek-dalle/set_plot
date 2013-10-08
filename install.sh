#!/bin/bash

#
# This file automatically runs the installer for set_plot for UNIX-like
# operating systems.  It will open a copy of MATLAB within the terminal
# provided that a command
#
# $ matlab -nodesktop
#
# will work on your computer.
#

# Load MATLAB with no desktop and tell it to run the installer and exit.
matlab -nodesktop -nojvm -nosplash -r "ierr=sp_Install, exit;"

