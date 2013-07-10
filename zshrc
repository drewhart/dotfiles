autoload -U colors && colors
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh


# Theme to load - Look in ~/.oh-my-zsh/themes/ or set to "random"
ZSH_THEME="duellj"

# Otherwise fucks with tmux window naming
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=()

# Enables autojump ocation to be overridden on a local basis - need for fhcrc servers
autojump=/usr/share/autojump/autojump.zsh

# Main path list. Can be added to with ~/.zshrc.local
export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/usr/lib/mit/bin:/sbin


# Local early bird overrides, modifications
[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

# Load oh my zsh
source $ZSH/oh-my-zsh.sh


# I've decided maybe autocorrection IS maybe more trouble than worth...
unsetopt correct_all

# Ocaml dev settings
export OCAMLRUNPARAM=b

# Load rvm if present
[[ -s "/home/$USER/.rvm/scripts/rvm" ]] && source "/home/$USER/.rvm/scripts/rvm" 
# Add RVM to PATH for scripting
export PATH=$PATH:$HOME/.rvm/bin

# Sets diff to colordiff if present
which colordiff > /dev/null && alias diff="colordiff"

# These are from http://www.f30.me/2012/10/oh-my-zsh-key-bindings-on-ubuntu-12-10/
# Solves no up-line-or-search functionality from oh-my-zsh. Try removing periodically. Appears to be a cleaner
# patch which may be going to omzsh - XXX
bindkey "${terminfo[kcuu1]}" up-line-or-search
bindkey "${terminfo[kcud1]}" down-line-or-search

# This is disables the Ctrl-S Xoff feature of the shell
stty -ixon




# ALIASES!!!!!!!!!!
# =================

# Listing aliases
alias ll='ls -hl'
alias la='ls -hla'
alias wdid='ls -chlt | head'
alias l='ls -hl'
alias files='nautilus'

# quick zsh mods
alias rrc='source ~/.zshrc'
alias erc='vim ~/.zshrc'

# Other
alias ack='ack-grep'
alias xc='xclip -selection clip'
alias sc='scons --debug explain'
alias scn='scons -n --debug explain'


# Archeopterix helper
aptx() {
  java -jar ~/bin/forester.jar -c ~/.aptxrc $1
}

# Reload shell
r () {
  # Reload X tunells if in tmux
  if [[ -n $TMUX ]]
  then
    NEW_SSH_AUTH_SOCK=`tmux showenv|grep "^SSH_AUTH_SOCK"|cut -d = -f 2` 
    if [[ -n $NEW_SSH_AUTH_SOCK ]] && [[ -S $NEW_SSH_AUTH_SOCK ]]
    then
      echo "New auth sock: $NEW_SSH_AUTH_SOCK"
      SSH_AUTH_SOCK=$NEW_SSH_AUTH_SOCK 
    fi
    NEW_DISPLAY=`tmux showenv|grep "^DISPLAY"|cut -d = -f 2` 
    if [[ -n $NEW_DISPLAY ]]
    then
      echo "New display: $NEW_DISPLAY"
      DISPLAY=$NEW_DISPLAY 
    fi
  fi
  # Reload shell rc
  rrc  
}

# Readlink piped to xclip...
rl () {
  if [[ -n $1 ]]
  then
    p=$1
  else
    p='.'
  fi
  readlink -f $p
}
rlxc () {
  rl $1 | xc
}

# CSVKIT stuffs
csvless () {
  csvlook $1 | less -S
}
tsvless () {
  csvlook -t $1 | less -S
}
csvhead () {
  head $@ | csvlook
}
csvtail () {
  htail $@ | csvlook
}

# Similarly, for json
alias jsonlook='python -mjson.tool'
jsonless () {
  jsonlook $@ | less
}
jsonhead () {
  jsonlook $@ | head
}

htail () {
  if [[ ! -n $2 ]]
  then
    n=10
  else
    n=$2
  fi
  head -n 1 $1
  tail -n $n $1
}

avless () {
  av -L 10000 -w 10000 -cx $@ | less -S
}

alias avlook='av -L 10000 -w 10000 -cx'

waid () {
  ps ux --sort s | less -S
}

# Markdown converters
md2html () {
  for i in $@
  do
    pandoc $i -s --css "http://matsen.fhcrc.org/webpage.css" -o $(basename $i .md).html
  done
}
md2slidy () {
  for i in $@
  do
    pandoc $i -s --css "http://matsen.fhcrc.org/webpage.css" --to=slidy -o $(basename $i .md).html
  done
}
pdfjoin () {
  pdftk $@ cat output joined.pdf
  print "Joined pdf saved to joined.pdf!"
}



bindkey '\e.' insert-last-word

# For when my clutsy ass forgets to add things to a git commit
forgitadd () {
  git reset --soft HEAD~1
  git add .
  git commit -c ORIG_HEAD
}


# Supposed to clip out the stderr; doesn't quite work yet...
alias stderrxc='2>&1 > /dev/null | xc'


# For evil deeds...
hdoze () {
  if [[ -n $1 ]]
  then
    # Only parameter (optional) is height
    height=$1
  else
    # Default window height is...
    height=`xdpyinfo | grep dimensions | sed "s/.*[0-9]*x\([0-9]*\) pixels.*/\1/"`
    ((height=$height - 60))
  fi
  rdesktop -u csmall -d FHCRC phs-terminal.fhcrc.org -K -T "For evil deeds..." -g 1450x$height &
}


# auto jump !
[[ -s $autojump ]] && . $autojump && autoload -U compinit && compinit

# If anything needs to be modified for 
[[ -s $HOME/.zshrc.local.after ]] && source $HOME/.zshrc.local.after



PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
