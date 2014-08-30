#!/bin/bash
echo "*********************************************"
echo "* A CentOS 7.0 x64 deployment script to      "
echo "* initialize a base Middleman site with the  "
echo "* HTML5 Boilerplate, middleman-blog          "
echo "* extension and Zurb's Foundation 5          "
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

# check to make sure script is NOT being run as root
is_root && die "\033[40m\033[1;31mERROR: root check FAILED (you must NOT be root to use this script). Quitting...\033[0m\n" || echo "non-root user detected, proceeding..."

####################################################
# EDIT THESE VARIABLES WITH YOUR INFO
REAL_NAME='Keegan Mullaney'
EMAIL_ADDRESS='keegan@kmauthorized.com'
SSH_KEY_COMMENT='CentOS workstation'
MIDDLEMAN_DOMAIN='keeganmullaney.com'
GITHUB_USER='keegoid' #your GitHub username
####################################################

# library files
LIBS='linuxkm.lib gitkm.lib'
LIBS_DIR='includes' #where you put library files

# source function libraries
for lib in $LIBS; do
   [ -d $LIBS_DIR ] && { source $LIBS_DIR/$lib > /dev/null 2>&1 && echo "sourced: $LIBS_DIR/$lib" || echo "can't find: $LIBS_DIR/$lib"; } ||
                       { source $lib > /dev/null 2>&1 && echo "sourced: $lib" || echo "can't find: $lib"; }
done

# upstream project name
UPSTREAM_PROJECT='middleman-html5-foundation'

# local repository location
REPOS=$(locate_repos)

# init
SSH=false

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

# configure git
configure_git

# generate an RSA SSH keypair if none exists
if $SSH; then
   gen_ssh_keys $SSH_KEY_COMMENT
   echo
   echo "Have you copied id_rsa.pub (above) to the SSH keys section"
   echo "of your GitHub account?"
   echo
   read -p "Press enter when ready..."
fi

# change to repos directory
cd $REPOS
echo "changing directory to $_"

# middleman init html5 files
if [ -d "$REPOS/$UPSTREAM_PROJECT" ]; then
   echo "$UPSTREAM_PROJECT directory already exists, skipping middleman init..."
else
   # view templates ready to install
   echo
   read -p "Press enter to view available Middleman templates..."
   middleman init --help

   # generate the site from the html5 boilerplate template
   read -p "Press enter to init the html5 template files..."
   middleman init $UPSTREAM_PROJECT --template=html5
   read -p "Press enter to init the blog template files..."
   middleman init $UPSTREAM_PROJECT --template=blog
   read -p "Press enter to init the foundation-tmp files..."
   foundation new temp-foundation

   # change to project directory
   cd $UPSTREAM_PROJECT
   echo "changing directory to $_"

   # delete default css
   #rm -rf 
   
   # copy foundation files to Middleman project
   #cp -rf 

   # config.rb
   read -p "Press enter to configure middleman-syntax..."
#   activate :syntax
#   set :markdown_engine, :kramdown

   read -p "Press enter to activate the blog extension..."
#   activate :blog do |blog|
#       set options on blog
#   end

   read -p "Press enter to activate livereload..."
#   activate :livereload

   read -p "Press enter to add ignored directories..."
#   ignore 'setup/*'
#   ignore 'includes/*'

   # build it
   bundle exec middleman build

   # directory indexes must be activated after middleman-blog
   read -p "Press enter to activate Pretty URLs (directory indexes)..."
#   activate :directory_indexes

   # build it again
   bundle exec middleman build

   # print git status
   read -p "Press enter to view git status..."
   git status

   # commit changes with git
   read -p "Press enter to commit changes..."
   git commit -am "first commit by $GITHUB_USER"

   # push commits to your remote repository (GitHub)
   read -p "Press enter to push changes to your remote repository (GitHub)..."
   git push
fi

# change to project directory
cd $UPSTREAM_PROJECT
echo "changing directory to $_"

# create a new branch for changes (keeping master for upstream changes)
create_branch $MIDDLEMAN_DOMAIN

# assign the original repository to a remote called "upstream"
merge_upstream_repo $UPSTREAM_PROJECT $SSH

# git commit and push if necessary
commit_and_push $GITHUB_USER

echo
echo "**********************************************************************"
echo "* manual steps:                                                       "
echo "*                                                                     "
echo "* to run the local middleman server at http://localhost:4567/         "
echo "*    bundle exec middleman                                            "
echo "*                                                                     "
echo "* to setup automatic the BitBalloon build:                            "
echo "*    - do an initial manual drag and drop deploy of your new site     "
echo "*    - go to your site in the BitBalloon UI                           "
echo "*    - click \"Link site to a Github repo\" at the bottom right       "
echo "*      (currently a beta feature so you may need to request access)   "
echo "*    - choose which branch you want to deploy ($MIDDLEMAN_DOMAIN)     "
echo "*    - set the dir to \"Other ...\" and enter \"/build\"              "
echo "*    - for the build command, set: \"bundle exec middleman build\"    "
echo "*                                                                     "
echo "* Now whenever you push to Github, BitBalloon will run middleman      "
echo "* and deploy the /build folder to your site.                          "
echo "**********************************************************************"

echo
echo "**********************************************************************"
echo '* middleman-syntax helper code example:                               '
echo '* <% code("ruby") do %>                                               '
echo '* def my_cool_method(message)                                         '
echo '*   puts message                                                      '
echo '* end                                                                 '
echo '* <% end %>                                                           '
echo '*                                                                     '
echo '* HAML helper code example                                            '
echo '* :code                                                               '
echo '*   # lang: ruby                                                      '
echo '*                                                                     '
echo '*   def my_cool_method(message)                                       '
echo '*     puts message                                                    '
echo '*   end                                                               '
echo '*                                                                     '
echo '* fenced code block example:                                          '
echo '* ~~~ ruby                                                            '
echo '* def my_cool_method(message)                                         '
echo '*   puts message                                                      '
echo '* end                                                                 '
echo '* ~~~                                                                 '
echo "**********************************************************************"

script_name "done with "
