middleman-html5-foundation
==========================

A base for a [Middleman][mm] site starting with the [HTML5 Boilerplate][html5bp], adding in the [middleman-blog extension][mmb] and the [Sass/Compass version][zfsass] of [Zurb's Foundation 5][zf].

I like [BitBalloon][bb] for static websites because whenever you push to [Github][gh], [BitBalloon][bb] will run middleman and deploy the /build folder to your site automatically. It's a nice convenience for [Middleman][mm] sites. Instructions for the [BitBalloon setup](#bitballoon) are below.

- Based on the [middleman-foundation][mmf] and [middleman-zurb-foundation][mzf] projects.
- Created with the [middleman.sh][mmsh] script from my [linux-deploy-scripts][lds] project.

I prefer doing things with [shell scripts][ss] in Linux rather than creating a template that you just copy. Each step is clearly represented in the [middleman.sh][mmsh] script. I hope you like it!

TODO:

Create a script to convert HTML to [HAML][haml]. I still have a bit to learn about that.

## table of contents

- [features](#features)
- [reasoning](#reasoning)
- [usage](#usage)
   - [fork and clone](#fork-and-clone)
   - [BitBalloon setup](#bitballoon)
- [configuration](#configuration)
- [contributing](#contributing)
   - [getting started](#getting-started)
   - [steps](#steps)
- [workflow](#workflow)
   - [git push](#git-push)
   - [git pull](#git-pull)
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

Then go to `http://localhost:4567/__middleman/config/` in your browser.

## reasoning

I made this project to gain a better understanding of [Middleman][mm], [HTML5][html5], [HAML][haml] and [Sass][sass] using the [Sass/Compass version][zfsass] of [Foundation 5][zf].

Using [shell scripts][ss] with [Middleman][mm] and [Foundation][zf] fits well with my workflow since I use [CentOS][centos] for my programming work. It's a pretty stable [Linux distribution][ld]. I like it a lot and use it on my laptop and servers at [DigitalOcean][do].

## usage

#### fork and clone

1. Fork it http://github.com/keegoid/middleman-html5-foundation/fork
1. Clone your own fork using HTTPS or SSH (recommended)
   - HTTPS: `git clone https://github.com/yourusername/middleman-html5-foundation.git`
   -   SSH: `git clone git@github.com:yourusername/middleman-html5-foundation.git`

Or you can get it by running the [linux-deploy-scripts][lds] project for setup of a fresh [CentOS 7.0 x64][centos] workstation or server. If you choose the workstation option, you'll get a new build of this [Middleman project][mmhtml5f] in your [GitHub][gh] account. FYI, the server option installs [WordPress][wp] at [DigitalOcean][do].

#### BitBalloon

To set up the automatic [BitBalloon][bb] deploys, login as a non-root user.

From your Middleman project directory, install Middleman extenstions in the Gemfile: `sudo bundle install`

Optionally, run the local middleman server at [http://localhost:4567/](http://localhost:4567/) to confirm that your new site is functional: `bundle exec middleman`

Commit your changes with git: `git commit -am 'first commit'`

Push commits to your remote repository on GitHub: `git push origin master`

Go to the [BitBalloon][bb] site and:

   - do an initial manual drag and drop deploy of your new site
   - go to your site in the BitBalloon UI
   - click "Link site to a Github repo" at the bottom right (currently a beta feature so you may need to request access)
   - choose which branch you want to deploy (typically master)
   - set the dir to "Other ..." and enter "/build"
   - for the build command, set: "bundle exec middleman build"

Now whenever you push changes to [Github][gh], [BitBalloon][bb] will run middleman and deploy the /build folder to your site automatically. Easy!

## configuration



## contributing

Contributions are totally welcome.

#### getting started

A clear intro to [using git][learngit].  
A good [step-by-step guide][fork] about how to contribute to a GitHub project like this one.

#### steps

1. Fork it http://github.com/keegoid/middleman-html5-foundation/fork
1. Clone your own fork using HTTPS or SSH (recommended)
   - HTTPS: `git clone https://github.com/yourusername/middleman-html5-foundation.git`
   -   SSH: `git clone git@github.com:yourusername/middleman-html5-foundation.git`
1. Optionally create your own feature branch `git checkout -b my-new-feature`
1. Commit your changes `git commit -am 'made some changes'`
1. Push your master or branch commits to GitHub
   - `git push origin master`
   - `git push origin my-new-feature`
1. Create a new [Pull request][pull]

## workflow

If you didn't start by cloning an existing repository on GitHub, you'll need to add your remote origin URL:

   - HTTPS: `git remote add origin https://github.com/yourusername/middleman-html5-foundation.git`
   -   SSH: `git remote add origin git@github.com:yourusername/middleman-html5-foundation.git`

#### git push

From my Linux workstation:

`git commit -am 'updated README'`

and push my changes to GitHub:

`git push origin master` or `git push origin branch-name`

If you set the default push method for git to **matching** with:

`git config --global push.default matching`

Then you can simply use `git push` from your current branch whether master or some other branch.

#### git pull

The git pull command can also be shortened by specifying some details in the git config.

The long version:

`git pull origin master` or for a branch `git pull origin my-new-feature`

After creating a new branch, you can shorten pull (and push) commands by setting the upstream branch in git config:

`git branch --set-upstream-to=origin/<branch> <branch>`

Now you can simply use `git pull` when you want to pull in changes from your GitHub repository for a specific branch.

Note, use `git config --list` to view all configured options.

I hope you find this workflow as easy and efficient as I do.

## license

Author : Keegan Mullaney  
Company: KM Authorized LLC  
Website: http://kmauthorized.com

MIT: http://kma.mit-license.org


[lds]:      https://github.com/keegoid/linux-deploy-scripts
[mmsh]:     https://github.com/keegoid/linux-deploy-scripts/blob/master/scripts/middleman.sh
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
[md]:       http://daringfireball.net/projects/markdown/
[fcb]:      http://kramdown.gettalong.org/syntax.html#fenced-code-blocks
[mmpurl]:   http://middlemanapp.com/basics/pretty-urls/
[mme]:      http://directory.middlemanapp.com/#/extensions/all
[ruby]:     https://www.ruby-lang.org/
[html5]:    http://en.wikipedia.org/wiki/Html5
[zfsass]:   http://foundation.zurb.com/docs/sass.html
[centos]:   http://centos.org/
[ss]:       http://en.wikipedia.org/wiki/Shell_script
[do]:       https://www.digitalocean.com/?refcode=251afd960495 "clicking this affiliate link benefits me at no cost to you"
[bb]:       https://www.bitballoon.com/
[gh]:       https://github.com/
[wp]:       http://wordpress.org/
[ld]:       http://en.wikipedia.org/wiki/Linux_distribution
[sh]:       http://en.wikipedia.org/wiki/Syntax_highlighting
[learngit]: https://www.atlassian.com/git/tutorial/git-basics#!overview
[fork]:     https://help.github.com/articles/fork-a-repo
[pull]:     https://help.github.com/articles/using-pull-requests
