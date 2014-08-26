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
if [ "$(id -u)" != "0" ]; then
   printf "\033[40m\033[1;31mERROR: root check FAILED (you MUST be root to use this script)! Quitting...\033[0m\n" >&2
   exit 1
fi

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
echo
read -p "Press enter to test the EPEL install..."
if rpm -qa | grep -q epel
then
   echo "EPEL was already configured"
else
   read -p "Press enter to import the EPEL gpg key..."
   # import rpm key
   ImportPublicKey $EPEL_KEY
   # list imported gpg keys
   rpm -qa gpg*
   # run the install
   echo
   read -p "Press enter to continue with EPEL install..."
   rpm -ivh $EPEL_URL
   # test new repo
   echo
   read -p "Press enter to test the new repo..."
   yum check-update
fi

# install Node.js for running the local web server and npm for the CLI
if rpm -qa | grep -q nodejs; then
   echo "nodejs was already installed"
else
   echo
   read -p "Press enter to install nodejs and npm..."
   yum --enablerepo=epel -y install nodejs npm
fi

# install git
if rpm -q git; then
   echo "git was already installed"
else
   echo
   read -p "Press enter to install git..."
   yum -y install git
fi

########## GEM ##########

# install Ruby and RubyGems
read -p "Press enter to install ruby and rubygems..."
if ruby -v | grep -q "ruby $RUBY_VERSION"; then
   echo "ruby is already installed"
else
   curl -L $RUBY_URL | bash -s stable --ruby=$RUBY_VERSION
fi

# start using rvm
echo
read -p "Press enter to start using rvm..."
if cat $HOME/.bashrc | grep -q "/usr/local/rvm/scripts/rvm"; then
   echo "already added rvm to .bashrc"
else
   echo "source /usr/local/rvm/scripts/rvm" >> $HOME/.bashrc
   source /usr/local/rvm/scripts/rvm && echo "rvm sourced and added to .bashrc"
fi

# update gem package manager
echo
read -p "Press enter to update the gem package manager..."
gem update --system

# install necessary gems
if $(gem list middleman -i); then
   echo "gem middleman is already installed"
else
   echo
   read -p "Press enter to install middleman..."
   gem install middleman
fi

if $(gem list middleman-blog -i); then
   echo "gem middleman-blog is already installed"
else
   echo
   read -p "Press enter to install middleman-blog..."
   gem install middleman-blog
fi

if $(gem list middleman-syntax -i); then
   echo "gem middleman-syntax is already installed"
else
   echo
   read -p "Press enter to install middleman-syntax..."
   gem install middleman-syntax
fi

if $(gem list middleman-livereload -i); then
   echo "gem middleman-livereload is already installed"
else
   echo
   read -p "Press enter to install middleman-livereload..."
   gem install middleman-livereload
fi

if $(gem list foundation -i); then
   echo "gem foundation is already installed"
else
   echo
   read -p "Press enter to install foundation..."
   gem install foundation
fi

# update gems
echo
read -p "Press enter to update gems..."
gem update

# view installed middleman gems
read -p "Press enter to view installed middleman gems..."
gem list middleman

########## NPM ##########

npm install -g bower grunt-cli

ME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
echo "done with $ME"
