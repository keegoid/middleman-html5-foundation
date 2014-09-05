#!/bin/bash
echo "*********************************************"
echo "* A CentOS 7.0 x64 deployment script to      "
echo "* install dependencies for Middleman and     "
echo "* Zurb's Foundation 5                        "
echo "*                                            "
echo "* Author : Keegan Mullaney                   "
echo "* Company: KM Authorized LLC                 "
echo "* Website: http://kmauthorized.com           "
echo "*                                            "
echo "* MIT: http://kma.mit-license.org            "
echo "*                                            "
echo "* ---run instructions---                     "
echo "* set execute permissions on this script:    "
echo "* chmod +x init.sh                           "
echo "* dos2unix -k init.sh                        "
echo "* run before setup.sh as root user: su root  "
echo "* ./init.sh                                  "
echo "*********************************************"

# save current directory
WORKING_DIR="$PWD"

# make temp library directory
mkdir -pv "libtmp"

# make sure curl is installed
hash curl 2>/dev/null || { echo >&2 "curl will be installed."; yum -y install curl; }

# download necessary files
read -p "Press enter to download setup.sh here and three library files to libtmp..."
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/setup.sh
cd "libtmp"
echo "changing directory to $_"
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/includes/base.lib
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/includes/software.lib
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/includes/git.lib && echo "done with downloads"
cd -
echo "changing directory back to $WORKING_DIR"

# set permissions
chmod +x "setup.sh"
echo "set execute permissions on $_"
chown $USER_NAME:$USER_NAME "setup.sh"
echo "gave ownership of $_ to "$USER_NAME

read -p "Press enter to continue..."
source config.sh

# check to make sure script is being run as root
is_root && echo "root user detected, proceeding..." || die "\033[40m\033[1;31mERROR: root check FAILED (you must be root to use this script). Quitting...\033[0m\n"

# create project directory and copy files there
read -p "Press enter to create project directory and copy files there..."
mkdir -pv "$REPOS/$UPSTREAM_PROJECT/$LIB_DIR"
cd "$REPOS/$UPSTREAM_PROJECT"
echo "changing directory to $_"
cp -fv "$WORKING_DIR/config.sh" .
cp -fv "$WORKING_DIR/init.sh" .
cp -fv "$WORKING_DIR/setup.sh" .
cp -Rfv "$WORKING_DIR/libtmp" $LIB_DIR

########## YUM ##########

# set versions (which also sets download URLs)
set_software_versions 'EPEL RUBY'

# EPEL
install_repo "epel-release" "$EPEL_KEY" "$EPEL_URL"

# install git, Node.js for running the local web server and npm for the CLI
install_app 'git'
install_app 'nodejs npm' 'epel'

########## GEM ##########

# install Ruby and RubyGems
install_ruby

# start using rvm
source_rvm

# update gem package manager
echo
read -p "Press enter to update the gem package manager..."
gem update --system

# install necessary gems
install_gem 'middleman middleman-blog middleman-syntax middleman-livereload foundation'

# update gems
echo
read -p "Press enter to update gems..."
gem update

# view installed middleman gems
read -p "Press enter to view installed middleman gems..."
gem list middleman

########## NPM ##########

npm install -g bower grunt-cli

# remove temporary files
rm -rf "$WORKING_DIR/libtmp"

echo
script_name "          done with "
echo "*********************************************"
