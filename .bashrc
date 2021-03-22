# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace
HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"; # Make some commands not show up in history

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
export PYTEST_ADDOPTS='--color=yes'

export DEBFULLNAME='Gediminas Paulauskas'
export DEBEMAIL='menesis@pov.lt'

function cdl { cd $1; ls; }
function this { echo "$(basename $PWD)" ; }
function repeat { while $@ ; do true ; done }

if [ "$OSTYPE" == "msys" ]; then
    if [ -f /usr/bin/winpty ]; then
        alias python='winpty python'
        alias ipython='winpty ipython'
        alias pip='winpty pip'
        alias pipwrap='winpty pipwrap'
    fi

    PATH=`cygpath -u -p "$PATH"`
    APPDATA_U=`cygpath -u "$APPDATA"`
    if [ -d "$VIRTUAL_ENV" ] ; then
        VIRTUAL_ENV=`cygpath -u "$VIRTUAL_ENV"`
        PATH="$VIRTUAL_ENV/Scripts:$PATH"
    fi
    export PYTHONSTARTUP="$USERPROFILE\.python.py"
else
    PATH="$HOME/.local/bin:$PATH"
    #export PYTHONSTARTUP=$HOME/.python.py
fi
export PATH

# display only the current directory name in the terminal title
function t { export PROMPT_COMMAND='echo -ne "\033]2;$(basename $PWD)\007"' ; promptline ; }
# set terminal title
function tt { unset PROMPT_COMMAND; echo -ne "\033]2;$1\007" ; promptline ; }

complete -F _django_completion -o default django-admin.py manage.py django-admin django

if [ -z "$TEMP" ] ; then
    export TEMP=/tmp
fi

if [ -d "$HOME/Source" ] ; then
    SRC="$HOME/Source"
else
    SRC="$HOME/src"
fi

if [ -f "$SRC/github/z/z.sh" ] ; then
    source "$SRC/github/z/z.sh"
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

if [ -f /c/Miniconda3/etc/profile.d/conda.sh ] ; then
    source /c/Miniconda3/etc/profile.d/conda.sh
    conda activate
fi

# How to Setup X11 forwarding in WSL2 
# https://stackoverflow.com/questions/61110603/how-to-set-up-working-x11-forwarding-on-wsl2
if [ -f /usr/bin/host ] ; then
    # Get the IP Address of the Windows 10 Host and use it in Environment.
    HOST_IP=$(host `hostname` | grep -oP '(\s)\d+(\.\d+){3}' | tail -1 | awk '{ print $NF }' | tr -d '\r')
    export LIBGL_ALWAYS_INDIRECT=1
    export DISPLAY=$HOST_IP:0.0
    export NO_AT_BRIDGE=1
    export PULSE_SERVER=tcp:$HOST_IP
fi
