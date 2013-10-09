#!/bin/bash
#
# Script to add license headers to relevant files.
# Invoke from top-level directory with
#
#   $ ./script/insert_licesne.sh
#

# Versions:
#  2013-10-08 @dalle   : First version

# Locate all MATLAB files.
files=`find . -name "*.m"`

# File to hold temporary files.
temp='insertlicensetemp'
head='insertlicensehead'
# File containing the .m file license header
blurb='script/license_m.txt'

# Add blurb to top of all files in list.
for file in $files
do
	# Say what file is being prepended.
	echo $file
	# Write the file from 'function' on to the temp file.
	cat $file | sed -n -e '/^function/,/^\s*$/p' > $head
	cat $file | sed -n '/^% Version/,$p' > $temp
	# Write the file anew, starting with the header.
	cat $head > $file
	# Write he license blurb.
	cat $blurb >> $file
	# Write the rest of the file from the tmp.
	cat $temp >> $file
	# Remove the temp files.
	rm $head
	rm $temp
done

