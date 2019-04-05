# EGW Tools

Made using `ruby 2.6.0`. May work with your version of ruby.

Created to be a personal multi-purpose library for accessing the Ellen G. White API. The backend is modular and standalone so that various types of frontends can be created using the same backend. Thus far, the project has a command line tool called `egwtool`, a GUI app called `egwgui`, and also a simple discord bot called `egwbot`.

Run `egwtool` without any arguments to see the list of commands.

## Requirements:

**backend**
* `gem install oauth2`
* `gem install json`
* `gem install sanitize`
* `gem install nokogiri`

**egwtool only**
* `gem install tty-prompt`

**bot only**
* `gem install discordrb`

**GUI**
* `gem install fxruby`

[![asciicast](https://asciinema.org/a/QsTuuwSiCyHwettMhzmnBeRQJ.svg)](https://asciinema.org/a/QsTuuwSiCyHwettMhzmnBeRQJ)

![Experimental GUI](/demo/egwgui.png)

![egwbot demo](/demo/egwbot.gif)


### Notice: `auth.rb` and `egwbot.rb` both need information. See the comments in those files for help setting them up.
