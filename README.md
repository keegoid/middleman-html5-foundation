middleman-html5-foundation
==========================

A template for a [Middleman][mm] site with the [HTML5 Boilerplate][html5bp], the [middleman-blog extension][mmb] and the [Sass/Compass version][zfsass] of [Zurb's Foundation 5][zf].

I like [BitBalloon][bb] for static websites because whenever you push to [GitHub][gh], [BitBalloon][bb] will run middleman and deploy the /build folder to your site automatically. It's a nice convenience for [Middleman][mm] sites. Instructions for the [BitBalloon setup](#bitballoon-setup) are below.

- Based on the [middleman-foundation][mmf] and [middleman-zurb-foundation][mzf] projects.
- Created with the [mm-init.sh][mmi] script.

I prefer doing things with [shell scripts][ss] rather than starting from a template without knowing how it was created. If you're interested to see how this repository was created, you can see each step in the [mm-init.sh][mmi] script. You can also use that script to create your own version from scratch. I hope you like it!

TODO:

Create a script to convert HTML to [HAML][haml]. I still have a bit to learn about that.

## table of contents

- [features](#features)
- [reasoning](#reasoning)
- [usage](#usage)
   - [fork and clone](#fork-and-clone)
   - [BitBalloon setup](#bitballoon-setup)
- [configuration](#configuration)
- [contributing](#contributing)
   - [getting started](#getting-started)
   - [steps](#steps)
- [workflow](#workflow)
   - [Markdown](#markdown)
   - [git remote](#git-remote)
   - [git push and pull](#git-push-and-pull)
- [license](#license)

## features

- [Middleman][mm] built from the [HTML5 boilerplate][html5bp]. Written in [Ruby][ruby].
- [Blogging][mmb] with support for articles, categories and tags.
- [Nokogiri][nkg] for HTML-aware article summaries.
- [LiveReload][mmlr] to automatically refresh your page after changes.
- [Pretty URLs][mmpurl] without .html at the end.
- [kramdown][kd] handles [Markdown][md] with built-in support for [fenced code blocks][fcb], footnotes, tables and smart quotes. Written in [Ruby][ruby].
- [Rouge][rg] for [syntax highlighting][sh]. Also written in [Ruby][ruby] and enabled by the [middleman-syntax][mms] extension.

Since [Middleman][mm] is written in [Ruby][ruby], it makes sense to try to stick with [Ruby][ruby] for [Middleman extensions][mme] whenever possible. That's why I like [kramdown][kd] with [Rouge][rg] for [Markdown][md] and [syntax highlighting][sh].

To see all the available options and features, run [Middleman][mm] with the preview web server:

```bash
cd my_project
bundle exec middleman
```

Then go to [http://localhost:4567/__middleman/config/](http://localhost:4567/__middleman/config/) in your browser.

## reasoning

I made this project to gain a better understanding of [Middleman][mm], [HTML5][html5], [HAML][haml] and [Sass][sass] using the [Sass/Compass version][zfsass] of [Foundation 5][zf].

Using [shell scripts][ss] with [Middleman][mm] and [Foundation][zf] fits well with my workflow since I use [CentOS][centos] for my programming work. It's a pretty stable [Linux distribution][ld]. I like it a lot and use it on my laptop and servers at [DigitalOcean][do].

If this script helps you to better understand [CentOS][centos], [shell scripting][ss] or Linux in general, or if they help you to setup your own [Middleman][mm] site, please do let me know: [@keegoid][twitter]

## usage

#### fork and clone

1. fork http://github.com/keegoid/middleman-html5-foundation/fork
1. clone your own fork using HTTPS or SSH (recommended)
   - HTTPS: `git clone https://github.com/yourusername/middleman-html5-foundation.git`
   -   SSH: `git clone git@github.com:yourusername/middleman-html5-foundation.git`

Or you can get it by downloading and running the [mm-init.sh][mmi] script:

```bash
cd my_project
chmod u+x mm-init.sh
./mm-init.sh
```

#### BitBalloon setup

To set up the automatic [BitBalloon][bb] deploys, log in as a non-root user.  

```bash
# cd to your [Middleman][mm] project directory and install run:
sudo bundle install

# optionally, run the local middleman server at http://localhost:4567/
# to confirm that your new site is functional:
bundle exec middleman

# commit your changes with git:
git commit -am 'first commit'

# push commits to your remote repository (GitHub):
git push origin master
```

go to the [BitBalloon][bb] site and:

   1. do an initial manual drag and drop deploy of your new site
   1. go to your site in the BitBalloon UI
   1. click *"Link site to a GitHub repo"* at the bottom right  
      (currently a beta feature so you may need to request access)
   1. choose which branch you want to deploy (typically master)
   1. set the directory to `Other ...` enter `/build`
   1. for the build command, set: `bundle exec middleman build`

Now whenever you push changes to [Github][gh], [BitBalloon][bb] will run middleman and deploy the /build folder to your site automatically. Easy!

## configuration



## contributing

Contributions are totally welcome.

#### getting started

A clear intro to [using git][learngit].  
A good [step-by-step guide][fork] about how to contribute to a GitHub project like this one.

#### steps

1. fork http://github.com/keegoid/middleman-html5-foundation/fork
1. clone your own fork using HTTPS or SSH (recommended)
   - HTTPS: `git clone https://github.com/yourusername/middleman-html5-foundation.git`
   -   SSH: `git clone git@github.com:yourusername/middleman-html5-foundation.git`
1. optionally create your own feature branch `git checkout -b my-new-feature`
1. commit your changes `git commit -am 'made some cool changes'`
1. push your master or branch commits to GitHub
   - `git push origin master`
   - `git push origin my-new-feature`
1. create a new [Pull request][pull]

## workflow

#### Markdown

After much tribulation with [Markdown][md] editors and various workflows, I've found what I think is a great way to create/maintain my [Markdown][md] docs.

For blog posts or any long-form writing [Draft][draftin] is wonderful, especially the `F11` mode. It mostly works with [GitHub Flavored Markdown][gfm] except for strikethrough and alignment of table columns.
I then *Export* my document to the appropriate [git][git] repository in [Dropbox][db] (which then syncs with my various devices).
Finally, I commit the new document with [git][git] and push it to the remote repository (which then gets automatically built and deployed on [BitBalloon][bb]).

For other [Markdown][md] docs like *README.md* or *LICENSE.md* I find [gEdit][ge] to be easy and efficient. I can make some quick edits, commit changes in [git][git] and push them to [GitHub][gh] with just a few commands. It's also easy to repeat commits and pushes with the keyboard up arrow from the [Linux console][lc].  
to commit again: `up up enter`, to push again: `up up enter`

#### git remote

If you didn't start by cloning an existing repository on GitHub, you'll need to add your remote origin URL:

```bash
# HTTPS:
git remote add origin https://github.com/yourusername/middleman-html5-foundation.git

# SSH:
git remote add origin git@github.com:yourusername/middleman-html5-foundation.git
```

You can also set the upstream repository to fetch changes from this project:

```bash
# HTTPS:
git remote add upstream https://github.com/keegoid/middleman-html5-foundation.git

# SSH:
git remote add upstream git@github.com:keegoid/middleman-html5-foundation.git
```

Then `git fetch upstream master` and `git merge upstream/master`  
or accomplish both with `git pull upstream master`

#### git push and pull

```bash
# git config
# author
git config --global user.name 'Keegan Mullaney'
git config --global user.email 'keegan@kmauthorized.com'
# select a text editor, I prefer vi, you can also use vim or something else
git config --global core.editor vi
# add some SVN-like aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.up rebase
git config --global alias.ci commit
# set the default push and pull methods for git to "matching"
git config --global push.default matching
git config --global pull.default matching

# commit changes with git
git commit -am 'update README'

# create a new branch and check it out
git checkout -b 'branch-name'

# link the origin/<branch> with your local <branch>
git branch --set-upstream-to=origin/branch-name branch-name
```

Now you can simply use `git push` or `git pull` from your current branch, inluding master. It's nice to be able to reduce the length of these commands so you don't have to think about what you're pushing or pulling each time. Just make sure you've got the right branch checked out!

**long versions**

push or pull changes to/from origin (GitHub):  
`git push origin master` or `git push origin branch-name`  
`git pull origin master` or `git pull origin branch-name`

Note, use `git config --list` to view all configured options.

I hope you find this workflow as efficient and effective as I do.

## license

Author : Keegan Mullaney  
Company: KM Authorized LLC  
Website: http://kmauthorized.com

MIT: http://kma.mit-license.org


[mmi]:      https://github.com/keegoid/middleman-html5-foundation/blob/master/mm_init.sh
[mmhtml5f]: https://github.com/keegoid/middleman-html5-foundation
[mm]:       https://github.com/middleman/middleman
[mmb]:      https://github.com/middleman/middleman-blog
[mmlr]:     https://github.com/middleman/middleman-livereload
[mms]:      https://github.com/middleman/middleman-syntax
[zf]:       https://github.com/zurb/foundation
[mmf]:      https://github.com/blachniet/middleman-foundation
[mzf]:      https://github.com/axyz/middleman-zurb-foundation
[html5bp]:  https://github.com/h5bp/html5-boilerplate
[haml]:     https://github.com/haml/haml
[sass]:     https://github.com/sass/sass
[nkg]:      https://github.com/sparklemotion/nokogiri
[kd]:       https://github.com/gettalong/kramdown
[rg]:       https://github.com/jneen/rouge
[gfm]:      https://help.github.com/articles/github-flavored-markdown
[md]:       http://daringfireball.net/projects/markdown/
[draftin]:  https://draftin.com/
[ge]:       https://wiki.gnome.org/Apps/Gedit
[fcb]:      http://kramdown.gettalong.org/syntax.html#fenced-code-blocks
[mmpurl]:   http://middlemanapp.com/basics/pretty-urls/
[mme]:      http://directory.middlemanapp.com/#/extensions/all
[ruby]:     https://www.ruby-lang.org/
[html5]:    http://en.wikipedia.org/wiki/Html5
[zfsass]:   http://foundation.zurb.com/docs/sass.html
[centos]:   http://centos.org/
[lc]:       http://en.wikipedia.org/wiki/Linux_console
[ss]:       http://en.wikipedia.org/wiki/Shell_script
[do]:       https://www.digitalocean.com/?refcode=251afd960495 "clicking this affiliate link benefits me at no cost to you"
[db]:       https://db.tt/T7Pstjg "clicking this affiliate link benefits me at no cost to you"
[twitter]:  https://twitter.com/intent/tweet?screen_name=keegoid&text=Your%20%40middlemanapp%20init%20script%20with%20%40h5bp%20and%40ZURBfoundation%20is%20really%20great%20https%3A%2F%2Fgithub.com%2Fkeegoid%2Fmiddleman-html5-foundation
[bb]:       https://www.bitballoon.com/
[git]:      http://git-scm.com/
[gh]:       https://github.com/
[wp]:       http://wordpress.org/
[ld]:       http://en.wikipedia.org/wiki/Linux_distribution
[sh]:       http://en.wikipedia.org/wiki/Syntax_highlighting
[learngit]: https://www.atlassian.com/git/tutorial/git-basics#!overview
[fork]:     https://help.github.com/articles/fork-a-repo
[pull]:     https://help.github.com/articles/using-pull-requests
