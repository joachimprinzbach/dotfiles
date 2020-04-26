#!/usr/bin/env bash
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
fi;

# Set install flag to false
brewinstall=false

bot "Install Homebrew and all required apps."

ask_for_confirmation "\nReady to install apps? (get a coffee, this takes a while)";

# Flag install to go if user approves
if answer_is_yes; then
  ok
  brewinstall=true
else
  cancelled "Homebrew and applications not installed."
fi;

if $brewinstall; then
  # Prevent sleep.
  caffeinate &

  action "Installing Homebrew"
  # Check if brew installed, install if not.
  if ! hash brew 2>/dev/null; then
    # note: if your /usr/local is locked down (like at Google), you can do this to place everything in ~/.homebrew
    # mkdir "$HOME/.homebrew" && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
    # then add this to your path: export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    print_result $? 'Install Homebrew.'
  else
    success "Homebrew already installed."
  fi;

  running "brew update + brew upgrade"
  # Make sure we’re using the latest Homebrew.
  brew update

  # Upgrade any already-installed formulae.
  brew upgrade

  # CORE

  running "Installing apps"
  # Install GNU core utilities (those that come with macOS are outdated).
  # Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
  brew install coreutils

  # Install some other useful utilities like `sponge`.
  brew install moreutils
  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
  brew install findutils
  # Install GNU `sed`, overwriting the built-in `sed`.
  brew install gnu-sed --with-default-names

  # Install Bash 4.
  # Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
  # running `chsh`.
  brew install bash
  brew install bash-completion2

  # Switch to using brew-installed bash as default shell
  if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
    echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/bash;
  fi;

  # zsh
  brew install zsh
  brew install zsh-completion

  # Install `wget` with IRI support.
  brew install wget --with-iri

  # Install GnuPG to enable PGP-signing commits.
  brew install gnupg

  # Install more recent versions of some native macOS tools.
  brew install perl
  brew install vim --with-override-system-vi
  brew install grep
  brew install nano
  brew install openssh
  brew install screen

  # Key tools.
  brew install git
  brew install z

  # OTHER USEFUL UTILS
  brew install advancecomp
  brew install brew-cask-completion
  brew install gifsicle
  brew install git-extras
  brew install git-lfs
  brew install grc
  brew install httpie
  brew install hub
  brew install jp2a
  brew install jpegoptim
  brew install jq
  brew install libgit2
  brew install mas
  brew install p7zip
  brew install pidof
  brew install pigz
  brew install readline
  brew install rename
  brew install trash-cli
  brew install tree
  brew install ttygif
  brew install unrar
  brew install wifi-password
  brew install youtube-dl
  brew install zopfli


  # Docker
  brew install docker
  brew install docker-compose
  brew install docker-machine-driver-xhyve
  brew install xhyve

  # Dev
  brew install n
  brew install yarn
  brew install go
  brew install node
  brew install pyenv
  brew install pyenv-virtualenv
  brew install rbenv
  brew install ruby-build
  brew install rbenv-gemset

  # Dev CLI's
  brew tap argoproj/tap
  brew tap kong/kong
  brew tap pivotal/tap
  brew tap solo-io/tap
  brew tap tektoncd/tools
  brew install solo-io/tap/glooctl
  brew install helm
  brew install istioctl
  brew install jenkins
  brew install kong/kong/kong
  brew install kubernetes-cli
  brew install kubeseal
  brew install maven
  brew install minio/stable/mc
  brew install openshift-cli
  brew install pivotal/tap/springboot
  brew install tektoncd/tools/tektoncd-cli
  brew install travis

  # NET UTILS
  brew tap ZloeSabo/homebrew-nettools

  brew install httplab
  brew install wuzz

  running "Installing cask apps"

  # APPLICATIONS
  brew tap caskroom/versions

  # General
  brew cask install adoptopenjdk
  brew cask install adoptopenjdk8
  brew cask install discord
  brew cask install diskwave
  brew cask install dropbox
  brew cask install google-chrome
  brew cask install iterm2
  brew cask install licecap
  brew cask install macdown
  brew cask install oversight
  brew cask install postman
  brew cask install skype
  brew cask install skype-for-business
  brew cask install slack
  brew cask install sonos
  brew cask install spotify
  brew cask install teamviewer
  brew cask install vlc
  brew cask install zoomus

  # Development
  brew cask install intellij-idea
  brew cask install ngrok
  # brew cask install sublime-text
  brew cask install visual-studio-code


  # Install Mac App Store Applications.
  # requires: brew install mas
  # mas install 1225570693 # Ulysses

  running "brew cleanup"
  # Remove outdated versions from the cellar.
  brew cleanup

  # turn off prevebrent sleep.
  killall caffeinate
fi;
