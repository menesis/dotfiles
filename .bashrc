# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

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
    if [ -f /usr/bin/winpty ] &&
        grep -sq -v '^MSYS=enable_pcon' /etc/git-bash.config
    then
        for program in python ipython pip ; do
            alias $program="winpty $program"
        done
    fi

    PATH=`cygpath -u -p "$PATH"`
    if [ -d "$VIRTUAL_ENV" ] ; then
        VIRTUAL_ENV=`cygpath -u "$VIRTUAL_ENV"`
        PATH="$VIRTUAL_ENV/Scripts:$PATH"
    fi
    export PYTHONSTARTUP="$USERPROFILE\.python.py"
else
    export PYTHONSTARTUP=$HOME/.python.py
fi
export PATH

if [ -z "$TEMP" ] ; then
    export TEMP=/tmp
fi

#if [ -d "$HOME/Source" ] ; then
#    SRC="$HOME/Source"
#else
    SRC="$HOME/src"
#fi

# https://github.com/rupa/z
if [ -f "$SRC/github/z/z.sh" ] ; then
    source "$SRC/github/z/z.sh"
fi

function promptline {
    # https://github.com/edkolev/promptline.vim
    if [ -f ~/.shell_prompt.sh ] ; then
        if [[ "$TERM" =~ "256color" ]]; then
            source ~/.shell_prompt.sh
            export VIRTUAL_ENV_DISABLE_PROMPT=1
        fi
    fi
}
promptline

if [ $(which thefuck 2>/dev/null) ] ; then
    eval "$(thefuck --alias)"
fi

if [ -f /c/Miniconda3/etc/profile.d/conda.sh ] ; then
    source /c/Miniconda3/etc/profile.d/conda.sh
    # See https://github.com/conda/conda/issues/7445#issuecomment-774579800
    export PYTHONIOENCODING=utf8
    conda activate
fi

# Fix WSL2 interop issue https://superuser.com/a/1602624
function fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

if [ -f /usr/share/wslu/wslusc-helper.sh ] ; then
    if [[ -n $WSL_INTEROP ]]; then
      # enable external x display for WSL 2
      wsl2_d_tmp="$(grep nameserver /etc/resolv.conf | awk '{print $2}')"
      export DISPLAY=${wsl2_d_tmp}:0
      export LIBGL_ALWAYS_INDIRECT=1

      unset wsl2_d_tmp
    else
      export DISPLAY=:0
    fi

    win_sys_scaling=$(wslsys -S -s)
    export GDK_SCALE=$win_sys_scaling
    export QT_SCALE_FACTOR=$win_sys_scaling
    export GDK_DPI_SCALE=1
    unset win_sys_scaling

    export NO_AT_BRIDGE=1
    fix_wsl2_interop
fi

export PIPENV_SHELL_FANCY=1
export PIPENV_KEEP_OUTDATED=1
