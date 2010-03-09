" Vim syntax file
" Language:     Cobra
" Maintainer:   Todd Alexander
" Last Change:  2009-07-02

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


syn keyword cobraModule       use import nextgroup=cobraTypeName
syn keyword cobraContract     require ensure old implies invariant
syn keyword cobraStatement    shared private protected virtual body test abstract
syn keyword cobraStatement    is vari shared event
syn keyword cobraOperator     as to inherits nextgroup=cobraType,cobraTypeName,cobraGeneric skipwhite
syn keyword cobraOperator     not of where must and or all out inout callable
syn keyword cobraStatement    try catch finally throw success pass print stop trace
syn keyword cobraStatement    return yield listen ignore raise end do ref this base
syn keyword cobraDeclaration  namespace class interface extend enum struct mixin implements inherits nextgroup=cobraTypeName skipwhite
syn keyword cobraStatement    def cue get set pro var sig from const nextgroup=cobraIdentifier skipwhite
syn match   cobraTypeName     "[a-zA-Z_][a-zA-Z0-9_.]*" contained nextgroup=cobraModifier
syn keyword cobraType         nil int int8 int16 int32 int64 uint8 bool char float number decimal dynamic same contained
syn keyword cobraType         Object String StringBuilder Exception List IList Dictionary IDictionary contained
syn keyword cobraType         Set Queue Stack TextWriter TextReader StringWriter DateTime contained
syn match   cobraIdentifier   "[a-zA-Z_][a-zA-Z0-9_]*" contained
syn keyword cobraModifier     public private protected abstract virtual extern partial override internal
syn keyword cobraStatement    if else using while post for break continue branch on off in
syn match   cobraComment      "#.*$"
syn match   cobraOperator     "<>\|==\|=\|<\|>"
syn region  cobraGeneric      matchgroup=Type start=+<of+ end=+>+ contains=cobraTypeName,cobraGenericName,cobraGeneric contained
syn match   cobraGenericName  "\<\|\>\|\s\|[a-zA-Z0-9_]\+" contained


" strings
syn region  cobraString       matchgroup=String start=+r\='+ end=+'+ skip=+\\\\\|\\'+ contains=cobraEscape,cobraNoSub,cobraSub
syn region  cobraString       matchgroup=String start=+r\="+ end=+"+ skip=+\\\\\|\\"+ contains=cobraEscape,cobraNoSub,cobraSub

syn region  cobraComment      matchgroup=Comment start=+"""+ end=+"""+ 
syn region  cobraComment      matchgroup=Comment start=+'''+ end=+'''+
syn region  cobraComment      matchgroup=Comment start=+\/\#+ end=+\#\/+

syn match   cobraEscape       +\\[abfnrtv'"\\]+ contained
syn match   cobraEscape       "\\\o\{1,3}" contained
syn match   cobraEscape       "\\x\x\{2}" contained
syn match   cobraEscape       "\(\\u\x\{4}\|\\U\x\{8}\)" contained
syn match   cobraEscape       "\\$"
syn match   cobraSubText      "\(_.\)\=[a-zA-Z][a-zA-Z0-9_]" contained
"syn region  cobraNoSub        matchgroup=String start=+\\\[+ end=+\]\|'+ contains=cobraSubText contained
syn match   cobraSub          "\[[.a-zA-Z0-9_]\+\]" contained
syn match   cobraNoSub        "\\\[[.a-zA-Z0-9_]\+\(\[[a-zA-Z0-9_]\+\]\)*\]" contained

syn match   cobraNumber       "\<0x\x\+[Ll]\=\>"
syn match   cobraNumber       "\<\d\+[Ll]\=\>"
syn match   cobraNumber       "\.\d\+\([eE][+-]\=\d\+\)\=\>"
syn match   cobraNumber       "\<\d\+\.\([eE][+-]\=\d\+\)\=\>"
syn match   cobraNumber       "\<\d\+\.\d\+\([eE][+-]\=\d\+\)\=\>"

hi def link cobraModule       Statement
hi def link cobraDeclaration  Statement
hi def link cobraContract     Statement
hi def link cobraStatement    Statement
hi def link cobraModifier     Statement
hi def link cobraTypeName     Type
hi def link cobraType         Type
hi def link cobraGeneric      Special
hi def link cobraGeneric2     Special
hi def link cobraGeneric3     Special
hi def link cobraIdentifier   Identifier
hi def link cobraRepeat       Statement
hi def link cobraConditional  Statement
hi def link cobraLabel        Statement
hi def link cobraOperator     Special
hi def link cobraException    Statement

hi def link cobraComment      Comment
hi def link cobraString       String
hi def link cobraRawString    String
hi def link cobraNumber       Number
hi def link cobraEscape       Special
hi def link cobraSub          Special
hi def link cobraSubText      String
hi def link cobraNoSub        String


" prevent """ synchronization problems
syn sync maxlines=200
syn sync minlines=500

" Comment Constant Identifier Statement Type Special Underlined Ignore Error Toto
let b:current_syntax = "cobra"

