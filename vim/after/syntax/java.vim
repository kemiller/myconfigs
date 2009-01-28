
setlocal makeprg=ant\ -find\ build.xml
setlocal errorformat=%A\ %#[execjavac]\ %f:%l:\ %m,%-Z\ %#[execjavac]\ %p^,%-C%.%#

setlocal include=^\s*import
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal textwidth=80 formatoptions+=cw tabstop=4 shiftwidth=4

nmap <buffer> [[ ?\(protected\\|public\\|private\).*(.*).*{<CR>
nmap <buffer> ]] /\(protected\\|public\\|private\).*(.*).*{<CR>
nmap <buffer> [] [[?}<CR>
nmap <buffer> ][ ]]$%
nmap <buffer> [c ?\s*class.*{<CR>

" Make a getter from a field
nmap _MG $bb"tyww"fywiget<ESC>l~wi()<ESC>:s/private/public/<CR>/;<CR>xa {<CR>return <C-R>f;<CR>}<ESC>
" Make a setter from a field
nmap _MS $bb"tcwvoid<ESC>w"fywiset<ESC>l~wi(<C-R>t <C-R>f)<ESC>:s/private/public/<CR>/;<CR>xa {<CR>this.<C-R>f = <C-R>f;<CR>}<ESC>
" Make a property from a field
nmap _MP yyPms_MGj_MSme='s'e

" I don't suffer from C++ hangover anymore...
let java_allow_cpp_keywords=1

