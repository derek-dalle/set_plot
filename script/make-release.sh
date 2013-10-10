#!/bin/bash

# This script prepares a release candidate for the set_plot code.  It creates a
# ZIP archive because that is a format that is easily opened on a wide variety
# of operating systems.  It will create an archive that is in the folder  
#
#  release/
# 
# and has a name that corresponds to the first argument of this function.
#
# The release contains all of the files in the folders
#
#  set_plot/
#  util/
#
# in addition to the files
#
#  LICENSE
#  AUTHORS
#  sp_Install.m
#  install.sh
#  install.cmd
#
# which contains the information about the copyright and license under which the
# code is distributed.
#
# This script must be run from the set_plot folder that contains the .git
# folder because the script contains relative file references.
#

# Variable to hold the local files
files="LICENSE AUTHORS sp_Install.m install.cmd install.sh"

# This will create the archive with a name based on the first input.
zip release/${1%.zip}.zip $files -r set_plot/ -r util/

