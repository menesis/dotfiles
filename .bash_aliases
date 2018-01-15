alias la='ls -a'
alias ll='ls -l'
alias l='ls -1'
alias grep='grep --color'
alias got='git status'
alias ok=clear

if [ "$OSTYPE" == "msys" ] ; then
    alias python='winpty python'
fi
