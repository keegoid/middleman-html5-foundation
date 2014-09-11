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
echo "* ---run instructions---                     "
echo "* set execute permissions on this script:    "
echo "* chmod +x setup.sh                          "
echo "* dos2unix -k setup.sh                       "
echo "* run after init.sh as non-root user         "
echo "* ./setup.sh                                 "
echo "*********************************************"

source config.sh

# check to make sure script is NOT being run as root
is_root && die "\033[40m\033[1;31mERROR: root check FAILED (you must NOT be root to use this script). Quitting...\033[0m\n" || echo "non-root user detected, proceeding..."

# configure git
configure_git "$REAL_NAME" "$EMAIL_ADDRESS"

# generate an RSA SSH keypair if none exists
gen_ssh_keys "$HOME/.ssh" "$SSH_KEY_COMMENT" $SSH

# change directory
cd $REPOS
echo "changing directory to $_"

# generate the site from the html5 boilerplate template
echo
read -p "Press enter to init the html5 template files..."
middleman init $MIDDLEMAN_DOMAIN --template=html5

# generate the site from the blog template
echo
read -p "Press enter to init the blog template files..."
middleman init $MIDDLEMAN_DOMAIN --template=blog

# change directory
cd $MIDDLEMAN_DOMAIN
echo "changing directory to $_"

# rename conflicting files
mv -Tfv config.rb config2.rb
mv -Tfv .gitignore .gitignore2

# change to project directory
cd "source"
echo "changing directory to $_"

# rename conflicting files
mv -Tfv layout.erb blog_layout.erb

# move stuff around that we want to keep
mv -fv blog_layout.erb layouts
cp -Rfv img/. images

# delete unnecessary stuff
rm -Rfv css stylesheets js javascripts img

# change directory
cd $REPOS
echo "changing directory to $_"

# generate the default foundation site
echo
read -p "Press enter to init the foundation files..."
foundation new $MIDDLEMAN_DOMAIN

# change directory
cd $MIDDLEMAN_DOMAIN
echo "changing directory to $_"

# remove duplicate directories
read -p "Press enter to merge and remove duplicate directories..."
mv -fv bower_components "source"
mv -fv stylesheets "source"
mv -fv scss "source"
mv -fv js "source"

# set default directories in config.rb
echo
read -p "Press enter to set directory defaults in config.rb..."
sed -i -e "s|set :js_dir, 'javascripts'|set :js_dir, 'js'|" \
    config.rb && echo -e "configured default directories"

# create .bowerrc to specify bower location
read -p "Press enter to create the .bowerrc file..."
echo "{ \
\"directory\" : \"source/bower_components\" \
}" > .bowerrc

# initialize bower for this project
bower init

# 

# delete default css
#rm -Rfv 

# copy foundation files to Middleman project
#cp -Rfv

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

read -p "Press enter to add ignored files and directories..."
#   ignore 'includes/*'
#   ignore '*.sh'

# build it
bundle exec middleman build

# directory indexes must be activated after middleman-blog
read -p "Press enter to activate Pretty URLs (directory indexes)..."
#   activate :directory_indexes

# build it again
bundle exec middleman build

# set the remote origin URL (no upstream repo since this project will diverge from it)
set_remote_repo $GITHUB_USER $MIDDLEMAN_DOMAIN false $SSH

# git commit and push if necessary
commit_and_push

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
echo "*    - choose which branch you want to deploy (usually master)        "
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

echo
script_name "          done with "
echo "*********************************************"
