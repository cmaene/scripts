#!/usr/bin/bash

# This is a simple script that you can use for creating a Python script tepmplate.
# 1) cd to the working directory then run
# 2) add one parameter ($1) which should be a short description - see below example
# bash ~/scripts/pyTemplate.sh "my test script" >[ouptput_script_name].py

cat <<EOF
#$(which python 2>&1)

''' VERSION : $(python --version 2>&1)
AUTHOR      : $USER
DATE        : `date`
DIRECTORY   : `pwd`
SHORT DESC. : $1
'''

# list modules
import

# runs all the functions
def main():
    # do something or run function(s) here

# =============================
#This idiom means the below code only runs when executed from command line
if __name__ == '__main__':
    main()

EOF
