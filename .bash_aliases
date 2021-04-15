alias la='ls -a'
alias ll='ls -l'
alias l='ls -1'
alias grep='grep --color'
alias got='git status'
alias tiga='tig --all'
alias ok='clear ; date'
if [ -d '/mnt/c' ] ; then
    alias msedge='/mnt/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application/msedge.exe'
    alias meld='/mnt/c/Users/GediminasPaulauskas/AppData/Local/Programs/Meld/Meld.exe'
elif [ -d '/c' ] ; then
    alias msedge='/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application/msedge.exe'
    alias meld='/c/Users/GediminasPaulauskas/AppData/Local/Programs/Meld/Meld.exe'
fi
