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
echo "*********************************************"

####################################################
# EDIT THESE VARIABLES WITH YOUR INFO
REAL_NAME='Keegan Mullaney'
EMAIL_ADDRESS='keegan@kmauthorized.com'
SSH_KEY_COMMENT='my workstation'
MIDDLEMAN_DOMAIN='keeganmullaney.com'
GITHUB_USER='keegoid' #your GitHub username
####################################################

# upstream project info
UPSTREAM_PROJECT='middleman-html5-foundation'
UPSTREAM_REPO="keegoid/$UPSTREAM_PROJECT.git"

# set software version here
RUBY_VERSION='2.1.2'       # to check version - https://www.ruby-lang.org/en/downloads/

# software download URL
RUBY_URL="https://get.rvm.io"

# local repository location
MM_REPOS="$HOME/repos"
if [ -d $HOME/Dropbox ]; then
   MM_REPOS=$HOME/Dropbox/Repos
fi

# make repos directory if it doesn't exist
mkdir -pv $MM_REPOS

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

# update gems
echo
read -p "Press enter to update gems..."
gem update

echo
read -p "Press enter to update the gem package manager..."
gem update --system

# install Node.js for running the local web server and npm for the CLI
if rpm -qa | grep -q nodejs; then
   echo "nodejs was already installed"
else
   echo
   read -p "Press enter to install nodejs and npm..."
   yum --enablerepo=epel -y install nodejs npm
fi

# install Middleman
if $(gem list middleman -i); then
   echo "middleman gem already installed"
else
   echo
   read -p "Press enter to install middleman..."
   gem install middleman
fi

# change to repos directory
cd $MM_REPOS
echo "changing directory to $_"

# generate a blog template for Middleman
if [ -d "$MM_REPOS/$MIDDLEMAN_DOMAIN" ]; then
   echo "$MIDDLEMAN_DOMAIN directory already exists, skipping middleman init..."
   read -p "Press enter to update your Middleman site instead..."
   bower update
else
   # view templates ready to install
   echo
   read -p "Press enter to view available Middleman templates..."
   middleman init --help

   # generate the site from the html5 and blog templates
   read -p "Press enter to initialize a Middleman site for $MIDDLEMAN_DOMAIN..."
   middleman init $MIDDLEMAN_DOMAIN --template=html5
   middleman init $MIDDLEMAN_DOMAIN --template=blog
fi

# change to newly cloned directory
cd $MIDDLEMAN_DOMAIN
echo "changing directory to $_"

# configure the Gemfile with necessary Middleman extensions
# middleman-syntax (Rouge)
if cat Gemfile | grep -q "middleman-syntax"; then
   echo "middleman-syntax extension already added"
else
   echo
   read -p "Press enter to configure the Gemfile..."
   echo '# Ruby based syntax highlighting utilizing Rouge' >> Gemfile
   echo 'gem "middleman-syntax"' >> Gemfile
   echo "middleman-syntax added to Gemfile"
fi

# middleman-blog
if cat Gemfile | grep -q "middleman-blog"; then
   echo "middleman-blog extension already added"
else
   echo
   read -p "Press enter to configure the Gemfile..."
   echo '# The Middleman blog extension' >> Gemfile
   echo 'gem "middleman-blog"' >> Gemfile
   echo "middleman-blog added to Gemfile"
fi

# assign the original repository to a remote called "upstream"
if git config --list | grep -q $UPSTREAM_REPO; then
   echo "upstream repo already configured: https://github.com/$UPSTREAM_REPO"
else
   echo
   read -p "Press enter to assign upstream repository..."
   git remote add upstream https://github.com/$UPSTREAM_REPO && echo "remote upstream added for https://github.com/$UPSTREAM_REPO"
fi

# pull in changes not present in local repository, without modifying local files
echo
read -p "Press enter to fetch changes from upstream repository..."
git fetch upstream
echo "upstream fetch done"

# merge any changes fetched into local working files
echo
read -p "Press enter to merge changes..."
git merge upstream/master

# update gems
echo
read -p "Press enter to update gems..."
gem update

echo
echo "**********************************************************************"
echo "* manual steps:                                                       "
echo "*                                                                     "
echo "* login as a non-root user, cd to $MIDDLEMAN_DOMAIN and run:          "
echo "*    sudo bundle install                                              "
echo "*                                                                     "
echo "* to run the local middleman server at http://localhost:4567/         "
echo "*    bundle exec middleman                                            "
echo "*                                                                     "
echo "* commit changes with git:                                            "
echo "*    git commit -am \'first commit by $GITHUB_USER\'                  "
echo "*                                                                     "
echo "* push commits to your remote repository stored on GitHub:            "
echo "*    git push origin master                                           "
echo "*                                                                     "
echo "* go to the BitBalloon site and:                                      "
echo "*    - do an initial manual drag and drop deploy of your new site     "
echo "*    - go to your site in the BitBalloon UI                           "
echo "*    - click \"Link site to a Github repo\" at the bottom right       "
echo "*      (currently a beta feature so you may need to request access)   "
echo "*    - choose which branch you want to deploy (typically master)      "
echo "*    - set the dir to \"Other ...\" and enter \"/build\"              "
echo "*    - for the build command, set: \"bundle exec middleman build\"    "
echo "*                                                                     "
echo "* Now whenever you push to Github, BitBalloon will run middleman      "
echo "* and deploy the /build folder to your site.                          "
echo "**********************************************************************"

echo "done with mm_init.sh"
