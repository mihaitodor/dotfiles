set nocompatible
set mouse=a
set backspace=indent,eol,start

syntax on

cnoreabbrev <expr> X (getcmdtype() is# ':' && getcmdline() is# 'X') ? 'x' : 'X'
