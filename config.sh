#!/bin/bash
echo "*********************************************"
echo "* A CentOS 7.0 x64 config script to          "
echo "* set global variables for setup1.sh and     "
echo "* setup2.sh                                  "
echo "*                                            "
echo "* Author : Keegan Mullaney                   "
echo "* Company: KM Authorized LLC                 "
echo "* Website: http://kmauthorized.com           "
echo "*                                            "
echo "* MIT: http://kma.mit-license.org            "
echo "*                                            "
echo "* Instructions:                              "
echo "* - run as non-root user                     "
echo "*********************************************"

####################################################
# EDIT THESE VARIABLES WITH YOUR INFO
REAL_NAME='Keegan Mullaney'
EMAIL_ADDRESS='keegan@kmauthorized.com'
SSH_KEY_COMMENT='CentOS workstation'
MIDDLEMAN_DOMAIN='keeganmullaney.com'
GITHUB_USER='keegoid' #your GitHub username
LIBS_DIR='includes' #where you put extra stuff

# OPTIONALLY, UPDATE THESE VARIABLES
# set software version here if newer versions exist
EPEL_VERSION='7-1'   # http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/
RUBY_VERSION='2.1.2' # https://www.ruby-lang.org/en/downloads/

# gems to install
GEMS="middleman middleman-blog middleman-syntax middleman-livereload foundation"
####################################################

# init
DROPBOX=false
SSH=false

# library files
LIBS='linuxkm.lib gitkm.lib'

# source function libraries
for lib in $LIBS; do
   [ -d $LIBS_DIR ] && { source $LIBS_DIR/$lib > /dev/null 2>&1 && echo "sourced: $LIBS_DIR/$lib" || echo "can't find: $LIBS_DIR/$lib"; } ||
                       { source $lib > /dev/null 2>&1 && echo "sourced: $lib" || echo "can't find: $lib"; }
done

# use Dropbox?
echo
echo "Do you wish to use Dropbox for your repositories?"
select yn in "Yes" "No"; do
   case $yn in
      "Yes") DROPBOX=true;;
       "No") break;;
          *) echo "case not found..."
   esac
   break
done

# use SSH?
echo
echo "Do you wish to use SSH for git operations (no uses HTTPS)?"
select yn in "Yes" "No"; do
   case $yn in
      "Yes") SSH=true;;
       "No") break;;
          *) echo "case not found..."
   esac
   break
done

