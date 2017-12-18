# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ "$TERM" == "xterm" ]; then
    export TERM=xterm-256color
elif [ "$TERM" == "screen" ]; then
    export TERM=screen-256color
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    #PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}:${PWD/$HOME/~}\007"'
    PROMPT_COMMAND='echo -ne "\033]0;${PWD/$HOME/\~}\007"'
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export EDITOR=vim
export LESS=-iRFX
export GREP_COLORS='mt=01;32:sl=:cx=:fn=96:ln=32:bn=32:se=36'
export PYTHONSTARTUP=$HOME/.python
export PYTEST_ADDOPTS='--color=yes'

export DEBFULLNAME='Gediminas Paulauskas'
export DEBEMAIL='menesis@pov.lt'

export PBUILDFOLDER=/var/cache/pbuilder
export REQUESTSYNC_USE_LPAPI=yes

function cdl { cd $1; ls; }
function this { export PACKAGE=$(basename $PWD) ; echo $PACKAGE ; }
function repeat { while $@ ; do true ; done }

if [ "$OSTYPE" == "msys" ]; then
    alias python='winpty python'
    alias pipwrap='winpty pip'
    alias pipwrap='winpty pipwrap'

    PATH=`cygpath -u -p "$PATH"`
    [[ $PATH =~ '/c/Python27' ]] || PATH="/c/Python27/Scripts:/c/Python27:$PATH"
    if [ -d "$VIRTUAL_ENV" ] ; then
        VIRTUAL_ENV=`cygpath -u "$VIRTUAL_ENV"`
        PATH="$VIRTUAL_ENV/Scripts:$PATH"
    fi
else
    PATH="$HOME/.local/bin:$PATH"
fi
export PATH

# display only the current directory name in the terminal title
function t { export PROMPT_COMMAND='echo -ne "\033]2;$(basename $PWD)\007"' ; promptline ; }
# set terminal title
function tt { unset PROMPT_COMMAND; echo -ne "\033]2;$1\007" ; promptline ; }

complete -F _django_completion -o default django-admin.py manage.py django-admin django

if [ -f ~/src/github/z/z.sh ] ; then
    source ~/src/github/z/z.sh
fi

function promptline {
    # https://github.com/edkolev/promptline.vim
    if [ -f ~/.shell_prompt.sh ] ; then
        if [[ "$TERM" =~ "256color" ]]; then
            source ~/.shell_prompt.sh
        fi
    fi
}
promptline

