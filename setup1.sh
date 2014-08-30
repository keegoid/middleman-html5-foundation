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

# check to make sure script is being run as root
is_root && echo "root user detected, proceeding..." || die "\033[40m\033[1;31mERROR: root check FAILED (you must be root to use this script). Quitting...\033[0m\n"

# library files
LIBS='linuxkm.lib gitkm.lib'
LIBS_DIR='includes' #where you put library files

# source function libraries
for lib in $LIBS; do
   [ -d $LIBS_DIR ] && { source $LIBS_DIR/$lib > /dev/null 2>&1 && echo "sourced: $LIBS_DIR/$lib" || echo "can't find: $LIBS_DIR/$lib"; } ||
                       { source $lib > /dev/null 2>&1 && echo "sourced: $lib" || echo "can't find: $lib"; }
done

# gems to install
GEMS="middleman middleman-blog middleman-syntax middleman-livereload foundation"

# set software version here
EPEL_VERSION='7-0.2'
RUBY_VERSION='2.1.2'       # to check version - https://www.ruby-lang.org/en/downloads/

# software download URL
EPEL_URL="http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-${EPEL_VERSION}.noarch.rpm"
RUBY_URL="https://get.rvm.io"

# GPG public keys
EPEL_KEY="http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-$EPEL_VERSION"

########## YUM ##########

# EPEL
install_repo "epel-release" $EPEL_KEY $EPEL_URL

# install Node.js for running the local web server and npm for the CLI
if rpm -qa | grep -q nodejs; then
   echo "nodejs was already installed"
else
   echo
   read -p "Press enter to install nodejs and npm..."
   yum --enablerepo=epel -y install nodejs npm
fi

# install git
install_app "git"

########## GEM ##########

# install Ruby and RubyGems
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

script_name "done with "