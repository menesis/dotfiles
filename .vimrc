" https://github.com/mintty/mintty/wiki/Tips
" show a block cursor in normal mode and a line cursor in insert mode:
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"

source $HOME/.vim/vimrc
