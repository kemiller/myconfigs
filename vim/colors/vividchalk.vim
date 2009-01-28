" Vim color scheme
" Name:         vividchalk.vim
" Maintainer:   Tim Pope <vim@tpope.info>
" Last Change:  19 Feb 2007

if has("gui_running")
    set background=dark
endif
hi clear
if exists("syntax_on")
   syntax reset
endif

let colors_name = "vividchalk"

" First two functions adapted from inkpot.vim

" map a urxvt cube number to an xterm-256 cube number
fun! s:M(a)
    return strpart("0135", a:a, 1) + 0
endfun

" map a urxvt colour to an xterm-256 colour
fun! s:X(a)
    if &t_Co == 88
        return a:a
    else
        if a:a == 8
            return 237
        elseif a:a < 16
            return a:a
        elseif a:a > 79
            return 232 + (3 * (a:a - 80))
        else
            let l:b = a:a - 16
            let l:x = l:b % 4
            let l:y = (l:b / 4) % 4
            let l:z = (l:b / 16)
            return 16 + s:M(l:x) + (6 * s:M(l:y)) + (36 * s:M(l:z))
        endif
    endif
endfun

function! s:choose(good,mediocre)
    if &t_Co != 88 && &t_Co != 256
        return a:mediocre
    else
        return s:X(a:good)
    endif
endfunction

function! s:hifg(group,guifg,ctermfg,backup)
    let ctermfg = s:choose(a:ctermfg,a:backup)
    exe "highlight ".a:group." guifg=".a:guifg." ctermfg=".ctermfg
endfunction

function! s:hibg(group,guibg,ctermbg,backup)
    let ctermbg = s:choose(a:ctermbg,a:backup)
    exe "highlight ".a:group." guibg=".a:guibg." ctermbg=".ctermbg
endfunction

hi link railsMethod         PreProc
hi link rubyDefine          Keyword
hi link rubySymbol          Constant
hi link rubyAccess          rubyMethod
hi link rubyAttribute       rubyMethod
hi link rubyEval            rubyMethod
hi link rubyException       rubyMethod
hi link rubyInclude         rubyMethod
hi link rubyStringDelimiter rubyString
hi link rubyRegexp          Regexp
hi link rubyRegexpDelimiter rubyRegexp
"hi link rubyConstant        Variable
"hi link rubyGlobalVariable  Variable
"hi link rubyClassVariable   Variable
"hi link rubyInstanceVariable Variable
hi link javascriptRegexpString  Regexp
hi link javascriptNumber        Number
hi link javascriptNull          Constant

if &background == "light" || has("gui_running")
    hi Normal guifg=White guibg=Black ctermfg=White ctermbg=Black
else
    hi Normal guifg=White guibg=Black ctermfg=White ctermbg=NONE
endif
highlight StatusLine   guifg=Black guibg=White gui=bold ctermfg=Black ctermbg=White cterm=bold
highlight StatusLineNC guifg=Black guibg=Grey gui=italic ctermfg=Black ctermbg=Grey cterm=none
highlight Cursor     guifg=Black guibg=White ctermfg=Black ctermbg=White
highlight CursorLine guibg=#333333 guifg=NONE
highlight CursorColumn guibg=#333333 guifg=NONE
highlight NonText    guifg=#404040 ctermfg=8
highlight SpecialKey guifg=#404040 ctermfg=8
highlight Directory  none
high link Directory  Identifier
highlight ErrorMsg   guibg=Red ctermbg=DarkRed guifg=NONE ctermfg=NONE
highlight Search     guibg=#101000 ctermbg=Black guifg=NONE ctermfg=NONE gui=italic cterm=underline
highlight MoreMsg    guifg=#00AA00 ctermfg=Green
highlight LineNr     guifg=#DDEEFF ctermfg=White
call s:hibg("LineNr"        ,"#222222",80,"DarkBlue")
highlight Question   none
high link Question   MoreMsg
highlight Title      guifg=Magenta ctermfg=Magenta
hi VisualNOS gui=none cterm=none
call s:hibg("Visual"        ,"#888888",83,"LightBlue")
call s:hibg("VisualNOS"     ,"#555555",81,"DarkBlue")
highlight WarningMsg    guifg=Red ctermfg=Red
highlight Folded        guibg=#1100aa ctermbg=DarkBlue
call s:hibg("Folded"        ,"#110077",17,"DarkBlue")
call s:hifg("Folded"        ,"#aaddee",63,"LightCyan")
highlight FoldColumn    none
high link FoldColumn    Folded
highlight Pmenu         guifg=White ctermfg=White gui=bold cterm=bold
highlight PmenuSel      guifg=White ctermfg=White gui=bold cterm=bold
call s:hibg("Pmenu"     ,"#000099",18,"Blue")
call s:hibg("PmenuSel"  ,"#5555ff",39,"DarkCyan")
highlight PmenuSbar     guibg=Grey ctermbg=Grey
highlight PmenuThumb    guibg=White ctermbg=White
highlight TabLine       gui=underline cterm=underline
call s:hifg("TabLine"   ,"#bbbbbb",85,"LightGrey")
call s:hibg("TabLine"   ,"#333333",80,"DarkGrey")
highlight TabLineSel    guifg=White guibg=Black ctermfg=White ctermbg=Black
highlight TabLineFill   gui=underline cterm=underline
call s:hifg("TabLineFill"   ,"#bbbbbb",85,"LightGrey")
call s:hibg("TabLineFill"   ,"#808080",83,"Grey")

hi Type gui=none
hi Statement gui=none
"highlight PreProc       guifg=#EDF8F9
call s:hifg("Comment"       ,"#9933CC",51,"DarkMagenta") " 92
call s:hifg("Constant"      ,"#339999",21,"DarkCyan") " 30
call s:hifg("rubyNumber"    ,"#CCFF33",60,"Yellow") " 190
call s:hifg("String"        ,"#66FF00",44,"LightGreen") " 82
call s:hifg("Identifier"    ,"#FFCC00",72,"Yellow") " 220
call s:hifg("Statement"     ,"#FF6600",68,"LightRed") " 202
call s:hifg("PreProc"       ,"#AAFFFF",47,"LightCyan") " 213
call s:hifg("Type"          ,"#999966",57,"Brown") " 101
call s:hifg("Special"       ,"#AAAAAA", 7,"Grey") " 7
call s:hifg("Regexp"        ,"#44B4CC",21,"DarkCyan") " 74
call s:hifg("rubyMethod"    ,"#DDE93D",77,"Yellow") " 191
"highlight railsMethod   guifg=#EE1122 ctermfg=1
