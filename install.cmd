rem
rem This file automatically runs the installer for set_plot for Windows
rem operating systems.  It will open a copy of MATLAB within the terminal
rem provided that a command
rem
rem > matlab -nodesktop
rem
rem will work on your computer.
rem

rem Load MATLAB with no desktop and tell it to run the installer and exit.
matlab -nodesktop -nojvm -nosplash -r "ierr=sp_Install, exit;"

