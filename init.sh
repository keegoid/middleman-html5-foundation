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
echo -n "changing directory back to " && cd -

read -p "Press enter to source config.sh..."
source config.sh

# check to make sure script is being run as root
is_root && echo "root user detected, proceeding..." || die "\033[40m\033[1;31mERROR: root check FAILED (you must be root to use this script). Quitting...\033[0m\n"

# create project directory and copy files there
echo
read -p "Press enter to create project directory and copy files there..."
mkdir -pv "$REPOS/$MIDDLEMAN_DOMAIN/$LIB_DIR"
cd "$REPOS/$MIDDLEMAN_DOMAIN"
echo "changing directory to $_"
cp -fv "$WORKING_DIR/config.sh" .
cp -fv "$WORKING_DIR/init.sh" .
cp -fv "$WORKING_DIR/setup.sh" .
cp -Rfv "$WORKING_DIR/libtmp/." $LIB_DIR

# set permissions
echo
read -p "Press enter to set permissions and ownership..."
echo
chmod -c +x *.sh
chmod -c +x $LIB_DIR/*
echo
chown -cR $USER_NAME:$USER_NAME .

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
echo
read -p "Press enter to view installed middleman gems..."
gem list middleman

########## NPM ##########

echo
read -p "Press enter to install bower and grunt-cli..."
install_npm 'bower grunt-cli'

echo
read -p "Press enter to view installed npm packages..."
npm ls -g

# remove temporary files
cd "$WORKING_DIR"
echo "changing directory to $_"
rm -fv config.sh
rm -fv init.sh
rm -fv setup.sh
rm -rfv libtmp

echo
script_name "          done with "
echo "*********************************************"
echo "next: cd $REPOS/$MIDDLEMAN_DOMAIN"
echo "then: run setup.sh as non-root user"
