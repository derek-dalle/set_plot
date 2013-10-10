#!/bin/bash
#
# This script updates the documentation to the www-personal website (for now)!
# It checks the documentation 
#

# Synchronize the folders.
rsync -avuzd doc/_build/html/* /afs/umich.edu/user/d/a/dalle/Public/html/codes/set_plot/doc

