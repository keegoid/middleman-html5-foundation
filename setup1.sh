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
echo "* Instructions:                              "
echo "* - run as root user                         "
echo "*********************************************"

# make sure curl is installed
hash curl 2>/dev/null || { echo >&2 "curl will be installed."; yum -y install curl; }

# download necessary files
read -p "Press enter to download setup2.sh and library files to this directory..."
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/setup2.sh
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/includes/linuxkm.lib
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/includes/gitkm.lib && echo "done with downloads"

# set permissions
echo
chmod +x "config.sh"
echo "set execute permissions on $_"
chown $(logname):$(logname) "config.sh"
echo "gave ownership of $_ to "$(logname)

chmod +x "setup2.sh"
echo "set execute permissions on $_"
chown $(logname):$(logname) "setup2.sh"
echo "gave ownership of $_ to "$(logname)

read -p "Press enter to continue..."
source config.sh

# check to make sure script is being run as root
is_root && echo "root user detected, proceeding..." || die "\033[40m\033[1;31mERROR: root check FAILED (you must be root to use this script). Quitting...\033[0m\n"

# software download URL
EPEL_URL="http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-${EPEL_VERSION}.noarch.rpm"
RUBY_URL="https://get.rvm.io"

# GPG public keys
EPEL_KEY="http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-$EPEL_VERSION"

########## YUM ##########

# EPEL
install_repo "epel-release" $EPEL_KEY $EPEL_URL

# install git, Node.js for running the local web server and npm for the CLI
install_app 'git'
install_app 'nodejs npm' 'epel'

########## GEM ##########

# install Ruby and RubyGems
echo
read -p "Press enter to install ruby and rubygems..."
if ruby -v | grep -q "ruby $RUBY_VERSION"; then
   echo "ruby is already installed"
else
   curl -L $RUBY_URL | bash -s stable --ruby=$RUBY_VERSION
fi

# start using rvm
source_rvm

# update gem package manager
echo
read -p "Press enter to update the gem package manager..."
gem update --system

# install necessary gems
install_gem $GEMS

# update gems
echo
read -p "Press enter to update gems..."
gem update

# view installed middleman gems
read -p "Press enter to view installed middleman gems..."
gem list middleman

########## NPM ##########

npm install -g bower grunt-cli

echo
script_name "          done with "
echo "*********************************************"
