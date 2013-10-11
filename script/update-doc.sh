#!/bin/bash
#
# This script updates the documentation to the www-personal website (for now)!
# It checks the documentation 
#

# AFS path
afs="/afs/umich.edu/user/d/a/dalle/Public/html/codes/set_plot"

# Synchronize the folders.
rsync -avuzd doc/_build/html/* "$afs/doc"

# Find the test functions
tfiles=`find doc/test/ -name "test*.m"`

# List them...
for f in $tfiles
do
    # List the file.
    echo $f
    # Copy it (because the above will have deleted it).
    cp $f "$afs/$f"
done
