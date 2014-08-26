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

# check to make sure script is being run as root
if [ "$(id -u)" != "0" ]; then
   echo "non-root user detected, continuing..."
else
   printf "\033[40m\033[1;31mERROR: non-root check FAILED (you MUST NOT be root to use this script)! Quitting...\033[0m\n" >&2
   exit 1
fi

####################################################
# EDIT THESE VARIABLES WITH YOUR INFO
REAL_NAME='Keegan Mullaney'
EMAIL_ADDRESS='keegan@kmauthorized.com'
SSH_KEY_COMMENT='CentOS workstation'
MIDDLEMAN_DOMAIN='keeganmullaney.com'
GITHUB_USER='keegoid' #your GitHub username
####################################################

# upstream project info
UPSTREAM_PROJECT='middleman-html5-foundation'
UPSTREAM_REPO="keegoid/$UPSTREAM_PROJECT.git"

# local repository location
REPOS="$HOME/repos"
if [ -d $HOME/Dropbox ]; then
   REPOS="$HOME/Dropbox/Repos"
fi
PROJECT_DIRECTORY="$REPOS/$UPSTREAM_PROJECT"

# make repos directory if it doesn't exist
mkdir -pv $REPOS

# files
SSH_KEY="$HOME/.ssh/id_rsa"
GIT_IGNORE="$HOME/.gitignore"

# init option variables
HTTPS=false
SSH=false

# HTTPS or SSH
echo
echo "Do you wish to use HTTPS or SSH for git operations?"
select hs in "HTTPS" "SSH"; do
   case $hs in
      "HTTPS") HTTPS=true;;
        "SSH") SSH=true;;
            *) echo "case not found..."
   esac
   break
done

# configure git
if git config --list | grep -q $GIT_IGNORE; then
   echo "git was already configured."
else
   echo
   read -p "Press enter to configure git..."
   # specify a user
   git config --global user.name "$REAL_NAME"
   git config --global user.email "$EMAIL_ADDRESS"
   # select a text editor
   git config --global core.editor vi
   # add some SVN-like aliases
   git config --global alias.st status
   git config --global alias.co checkout
   git config --global alias.br branch
   git config --global alias.up rebase
   git config --global alias.ci commit
   # set default push and pull behavior to the old method
   git config --global push.default matching
   git config --global pull.default matching
   # create a global .gitignore file
   echo -e "# global list of file types to ignore \
\n \
\n# gedit temp files \
\n*~" > $GIT_IGNORE
   git config --global core.excludesfile $GIT_IGNORE
   echo "git was configured"
fi

if $SSH; then
   echo
   read -p "Press enter to check if id_rsa exists"
   if [ -e $SSH_KEY ]; then
      echo "$SSH_KEY already exists"
   else
      # create a new ssh key with provided ssh key comment
      echo "create new key: $SSH_KEY"
      read -p "Press enter to generate a new SSH key"
      ssh-keygen -b 4096 -t rsa -C "$SSH_KEY_COMMENT"
      echo "SSH key generated"
      echo
      echo "***IMPORTANT***"
      echo "copy contents of id_rsa.pub (printed below) to the SSH keys section"
      echo "of your GitHub account or authorized_keys section of your remote server."
      echo "highlight the text with your mouse and press ctrl+shift+c to copy"
      echo
      cat $SSH_KEY.pub
      echo
      read -p "Press enter to continue..."
   fi
fi

# linux-deploy-scripts repository
if $SSH; then
   echo
   echo "Have you copied id_rsa.pub (above) to the SSH keys section"
   echo "of your GitHub account?"
fi
echo
read -p "Press enter when ready..."

# change to repos directory
cd $REPOS
echo "changing directory to $_"

# middleman init html5 files
if [ -d "$PROJECT_DIRECTORY" ]; then
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
echo
read -p "Press enter to create a git branch for your site at $MIDDLEMAN_DOMAIN..."
git checkout -b $MIDDLEMAN_DOMAIN

# some work and some commits happen
# some time passes
#git fetch upstream
#git rebase upstream/master or git rebase interactive upstream/master

read -p "Press enter to push changes and set branch upstream in config..."
git push -u origin $MIDDLEMAN_DOMAIN

read -p "Press enter to checkout the master branch again..."
git checkout master

echo
echo "above could also be done with:"
echo "git branch $MIDDLEMAN_DOMAIN"
echo "git push origin $MIDDLEMAN_DOMAIN"
echo "git branch -u origin/$MIDDLEMAN_DOMAIN $MIDDLEMAN_DOMAIN"

echo
echo "*************************************************************************"
echo "* - use the $MIDDLEMAN_DOMAIN branch to make your own site               "
echo "* - use the master branch to fetch and merge changes from the remote     "
echo "* upstream repo: $UPSTREAM_REPO                                          "
echo "*************************************************************************"

# assign the original repository to a remote called "upstream"
if git config --list | grep -q $UPSTREAM_REPO; then
   echo "upstream repo already configured: https://github.com/$UPSTREAM_REPO"
else
   echo
   read -p "Press enter to assign upstream repository..."
   if $HTTPS; then
      git remote add upstream https://github.com/$UPSTREAM_REPO && echo "remote upstream added for https://github.com/$UPSTREAM_REPO"
   else
      git remote add upstream git@github.com:$UPSTREAM_REPO && echo "remote upstream added for git@github.com:$UPSTREAM_REPO"
   fi
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

# or combine fetch and merge with:
#git pull upstream master

# git status, commit and push for master
read -p "Press enter to view git status..."
STATUS=git status

if cat $STATUS | grep -q 'nothing to commit, working directory clean'; then
   echo "skipping commit..."
else
   # commit changes with git
   read -p "Press enter to commit changes..."
   git commit -am "first commit by $GITHUB_USER"

   # push commits to your remote repository (GitHub)
   read -p "Press enter to push changes to your remote repository (GitHub)..."
   git push origin master
fi

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

ME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
echo "done with $ME"
