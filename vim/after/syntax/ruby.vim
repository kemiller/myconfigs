
setlocal foldmethod=marker

" Create a comment block around an already-commented line
nmap <buffer> _CB O-<ESC>79a-<ESC>ja <ESC>hkllDyyjpk

" Comment out the current line or the current selection
nmap <buffer> __ :s/\%1c/#/<CR>''
vmap <buffer> __ :s/\%1c/#/<CR>''

" Uncomment the current line or the current selection
nmap <buffer> _+ :s/^#*//<CR>''
vmap <buffer> _+ :s/^#*//<CR>''
set sw=4 ts=4 noexpandtab
set path+=$PROJECT_DIR/**,~/svn/main/$BRANCH/$APP/**
