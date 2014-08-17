#!/bin/bash
echo "********************************************************************************"
echo "* A setup script for a base Middleman site starting with the HTML5              "
echo "* boilerplate and adding in Zurb's Foundation 5.                                "
echo "*                                                                               "
echo "* Author : Keegan Mullaney                                                      "
echo "* Company: KM Authorized LLC                                                    "
echo "* Website: http://kmauthorized.com                                              "
echo "*                                                                               "
echo "* MIT: http://kma.mit-license.org                                               "
echo "*                                                                               "
echo "* ---run instructions---                                                        "
echo "* set execute permissions on this script:                                       "
echo "* chmod u+x setup.sh                                                            "
echo "* dos2unix -k setup.sh                                                          "
echo "* ./setup.sh                                                                    "
echo "********************************************************************************"

####################################################
# EDIT THESE VARIABLES WITH YOUR INFO
MIDDLEMAN_DOMAIN='keeganmullaney.com'
GITHUB_USER='keegoid' #your GitHub username
####################################################

# project info
PROJECT='middleman-html5-foundation'
MIDDLEMAN_UPSTREAM="keegoid/$PROJECT.git"

# directories
REPOS="$HOME/repos"
if [ -d $HOME/Dropbox ]; then
   REPOS="$HOME/Dropbox/Repos"
fi
PROJECT_DIRECTORY="$REPOS/$PROJECT"

# set software versions to latest
RUBY_VERSION='2.1.2'

# set variable defaults
MIDDLEMAN_GO=false

# run script after removing DOS line breaks
# takes one argument: name of script to be run
# source the script to be run so it can access local variables
RunScript()
{
   # reset back to root poject directory to run scripts
   cd $PROJECT_DIRECTORY/scripts
   echo "changing directory to $_"
   # make sure dos2unix is installed
   hash dos2unix 2>/dev/null || { echo >&2 "dos2unix will be installed."; yum -y install dos2unix; }
   dos2unix -k $1 && echo "carriage returns removed"
   chmod u+x $1 && echo "execute permissions set"
   chown $(logname):$(logname) $1 && echo "owner set to $(logname)"
   read -p "Press enter to run: $1"
   . ./$1
}

# make necessary directories if they don't exist
mkdir -pv $REPOS

# collect user inputs to determine which sections of this script to execute
echo
echo "Do you wish to install Middleman?"
select yn in "Yes" "No"; do
   case $yn in
      "Yes") MIDDLEMAN_GO=true;;
       "No") break;;
          *) echo "case not found";;
   esac
   break
done

echo
echo "********************************"
echo "SECTION 1: THE MIDDLEMAN        "
echo "********************************"

if $MIDDLEMAN_GO; then
   # install Ruby, RubyGems, Middleman, Redcarpet and Rouge
   RunScript middleman.sh
else
   echo "skipping the Middleman install..."
fi

if $MIDDLEMAN_GO; then
   echo
   echo "********************************************************************************"
   echo "* cd to: $MIDDLEMAN_DOMAIN/$MIDDLEMAN_PROJECT                                   "
   echo "* login as a non-root user to install the bundle:                               "
   echo "*    sudo bundle install                                                        "
   echo "*                                                                               "
   echo "* build middleman and push to BitBalloon:                                       "
   echo "*    bundle exec middleman deploy                                               "
   echo "* or just                                                                       "
   echo "*    middleman deploy                                                           "
   echo "*                                                                               "
   echo "* run the local middleman server at http://localhost:4567/                      "
   echo "*    bundle exec middleman                                                      "
   echo "*                                                                               "
   echo "* commit changes to git:                                                        "
   echo "*    git commit -am \'first commit by $USER_NAME\'                              "
   echo "*                                                                               "
   echo "* push commits to remote repository stored on GitHub:                           "
   echo "*    git push origin master                                                     "
   echo "*                                                                               "
   echo "* go to BitBalloon site and:                                                    "
   echo "*    - click \"Link site to a Github repo\" at the bottom right                 "
   echo "*    - choose which branch you want to deploy (typically master)                "
   echo "*    - set the dir to \"Other ...\" and enter \"/build\"                        "
   echo "*    - for the build command, set: \"bundle exec middleman build\"              "
   echo "*                                                                               "
   echo "* Now whenever you push to Github, Bitballoon will run middleman                "
   echo "* and deploy the /build folder to your site.                                    "
   echo "********************************************************************************"
fi

echo "Thanks for using the middleman-html5-foundation script."

