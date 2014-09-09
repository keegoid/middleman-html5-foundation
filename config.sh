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
echo "*********************************************"

####################################################
# EDIT THESE VARIABLES WITH YOUR INFO
USER_NAME='kmullaney' #Linux user you will/already use
REAL_NAME='Keegan Mullaney'
EMAIL_ADDRESS='keegan@kmauthorized.com'
SSH_KEY_COMMENT='CentOS workstation'
MIDDLEMAN_DOMAIN='keeganmullaney.com'
GITHUB_USER='keegoid' #your GitHub username
LIB_DIR='includes' #where you put extra stuff
####################################################

# library options
LIBS='base.lib software.lib git.lib'

# source function libraries
for lib in $LIBS; do
   [ -d "$LIB_DIR" ] && { source "$LIB_DIR/$lib" > /dev/null 2>&1 && echo "sourced: $LIB_DIR/$lib" || echo "can't find: $LIB_DIR/$lib"; } ||
                         { source "libtmp/$lib" > /dev/null 2>&1 && echo "sourced: libtmp/$lib" || echo "can't find: libtmp/$lib"; }
done

# init
DROPBOX=false
SSH=false

# use Dropbox?
echo
echo "Do you wish to use Dropbox for your repositories?"
select yn in "Yes" "No"; do
   case $yn in
      "Yes") DROPBOX=true;;
       "No") break;;
          *) echo "case not found, try again..."
             continue;;
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
          *) echo "case not found, try again..."
             continue;;
   esac
   break
done

# local repository location
echo
REPOS=$(locate_repos $USER_NAME $DROPBOX)
echo "repository location: $REPOS"

