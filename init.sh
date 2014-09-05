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
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/includes/base.lib
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/includes/software.lib
curl -kfsSLO https://raw.githubusercontent.com/keegoid/middleman-html5-foundation/master/includes/git.lib && echo "done with downloads"

# set permissions
chmod +x "setup2.sh"
echo "set execute permissions on $_"
chown $(logname):$(logname) "setup2.sh"
echo "gave ownership of $_ to "$(logname)

read -p "Press enter to continue..."
source config.sh

# check to make sure script is being run as root
is_root && echo "root user detected, proceeding..." || die "\033[40m\033[1;31mERROR: root check FAILED (you must be root to use this script). Quitting...\033[0m\n"

########## YUM ##########

# library options
SW_LIST='EPEL RUBY'

# set versions (which also sets download URLs)
set_software_versions "$SW_LIST"

# EPEL
install_repo "epel-release" "$EPEL_KEY" "$EPEL_URL"

# install git, Node.js for running the local web server and npm for the CLI
install_app 'git'
install_app 'nodejs npm' 'epel'

########## GEM ##########

GEM_LIST="middleman middleman-blog middleman-syntax middleman-livereload foundation"

# install Ruby and RubyGems
install_ruby

# start using rvm
source_rvm

# update gem package manager
echo
read -p "Press enter to update the gem package manager..."
gem update --system

# install necessary gems
install_gem "$GEM_LIST"

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
