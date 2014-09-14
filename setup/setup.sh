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
cd "$MIDDLEMAN_DOMAIN/source"
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
foundation new tmp-foundation

# change directory
cd tmp-foundation
echo "changing directory to $_"

# remove conflicting files
echo
read -p "Press enter to remove conflicting Foundation stuff..."
rm -Rf config.rb .git .gitignore .bowerrc README.md
cd -

# copy foundation files to middleman
echo
read -p "Press enter to copy the Foundation files to Middleman..."
cp -Rf tmp-foundation/. $MIDDLEMAN_DOMAIN && echo "done"

# change directory
cd $REPOS
echo "changing directory to $_"

# remove temp Foundation directory
rm -Rf tmp-foundation && echo "removed tmp-foundation"

# change directory
cd $MIDDLEMAN_DOMAIN
echo "changing directory to $_"

# move to source
echo
read -p "Press enter to move stuff to the source directory..."
mv -fv bower_components .sass-cache stylesheets scss js index.html "source"

# add Foundation config to compass
echo
read -p "Press enter to set config.rb..."
cat << EOF > config.rb
###
# Blog settings
###

# Time.zone = "UTC"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "blog"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  blog.permalink = ":year/:month/:day/:title.html"
  # Matcher for blog source files
  # blog.sources = "{year}-{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  blog.summary_separator = /<!-- excerpt -->/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

###
# Compass
###

# Change Compass configuration
compass_config do |config|
  # Require any additional compass plugins here.
  config.add_import_path "bower_components/foundation/scss"

  # Set this to the root of your project when deployed:
  config.http_path = "/"
  config.css_dir = "stylesheets"
  config.sass_dir = "scss"
  config.images_dir = "images"
  config.javascripts_dir = "js"

  # You can select your preferred output style here (can be overridden via the command line):
  # output_style = :expanded or :nested or :compact or :compressed

  # To enable relative paths to assets via compass helper functions. Uncomment:
  # relative_assets = true

  # To disable debugging comments that display the original location of your selectors. Uncomment:
  # line_comments = false


  # If you prefer the indented syntax, you might want to regenerate this
  # project again passing --syntax sass, or you can uncomment this:
  # preferred_syntax = :sass
  # and then run:
  # sass-convert -R --from scss --to sass sass scss && rm -rf sass && mv scss sass

  # config.output_style = :compact
end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
page "/blog.xml", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
page "/blog/*", layout: :post
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

# Middleman-syntax for Rouge
activate :syntax

# Pretty URLs
#  activate :directory_indexes

# Methods defined in the helpers block are available in templates
helpers do
#   def some_helper
#     "Helping"
#   end
  def related(page, limit = 3)
    all_pages = blog.tags.slice(*page.tags).values.flatten
    return [] if all_pages.blank?

    all_pages.delete_if { |p| p.url == page.url }[0..limit-1]
  end
end

# Add bower directory to sprockets asset path
after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join "#{root}", @bower_config["directory"]
end

set :css_dir, 'stylesheets'

set :js_dir, 'js'

set :images_dir, 'images'

set :markdown_engine, :kramdown

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
EOF
echo "config.rb done"
# config.rb
read -p "Press enter to configure middleman-syntax..."
#   activate :syntax
#   set :markdown_engine, :kramdown

# create .bowerrc to specify bower location
echo
read -p "Press enter to create the .bowerrc file..."
echo "{
\"directory\" : \"source/bower_components\"
}" > .bowerrc && echo ".bowerrc created"

# update Gemfile
echo
read -p "Press enter to update the Gemfile..."
if grep -q 'gem "middleman-livereload"' Gemfile; then
   echo "Gemfile is already configured"
else
   printf "\n# For live reloading after changes
gem \"middleman-livereload\"\n\n\
# For Rouge syntax highlighting\n\
gem \"middleman-syntax\"\n\n\
# For faster file watcher updates on Windows:\n\
gem \"wdm\", \"~> 0.1.0\", :platforms => [:mswin, :mingw]\n\n\
# For blog post summaries\n\
gem \"nokogiri\"" >> Gemfile && echo -e "\nGemfile updated"
fi

# change directory
cd source/js
echo "changing directory to $_"

echo "//= require modernizr/modernizr" > modernizr.js && echo "created modernizr.js"

# change directory
cd ../layouts
echo "changing directory to $_"

# modify layout.erb
read -p "Press enter to add stylesheet to layout.erb..."
sed -i -e 's/<link rel="stylesheet" href="css/normalize.css">/<%= stylesheet_link_tag "app" %>/' \
       -e 's/link rel="stylesheet" href="css/main.css">//' \
       layout.erb && echo "added Foundation's stylesheet link to layout.erb"
sed -i -e 's/<script src="js/vendor/modernizr-2.6.1.min.js"></script>/<%= javascript_include_tag "modernizr" %>/' \
       layout.erb && echo "added Foundation's modernizr link to layout.erb"
sed -i -e 's/<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>//' \
       -e "s/<script>window.jQuery || document.write('<script src=\"js/vendor/jquery-1.8.0.min.js\"><\/script>')</script>//" \
       -e 's/<script src="js/plugins.js"></script>//' \
       -e 's/<script src="js/main.js"></script>/<%= javascript_include_tag  "app" %>/' \
       layout.erb && echo "added Foundation's javascript link to layout.erb"

# change directory
cd $MIDDLEMAN_DOMAIN
echo "changing directory to $_"

# initialize git
echo
read -p "Press enter to create an empty Git repository..."
git init

# add ignored files
echo
read -p "Press enter to add ignored files and directories..."
echo "
# Ignore shell scripts and includes
/includes
.sh

# Ignore Foundation stuff
/source/bower_components
/source/.sass-cache
/source/stylesheets" >> .gitignore && echo ".gitignore done"

# build it
bundle exec middleman build

# directory indexes must be activated after middleman-blog
read -p "Press enter to activate Pretty URLs (directory indexes)..."
sed -i -e 's/#  activate :directory_indexes/activate :directory_indexes/' \
       config.rb && echo "activated directory_indexes in config.rb"

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
