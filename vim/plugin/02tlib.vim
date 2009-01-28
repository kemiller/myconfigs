" tlib.vim -- Some utility functions
" @Author:      Thomas Link (micathom AT gmail com?subject=[vim])
" @Website:     http://www.vim.org/account/profile.php?user_id=4037
" @License:     GPL (see http://www.gnu.org/licenses/gpl.txt)
" @Created:     2007-04-10.
" @Last Change: 2007-11-06.
" @Revision:    0.19.416
" GetLatestVimScripts: 1863 1 tlib.vim
"
" Please see also ../test/tlib.vim for usage examples.
"
" TODO:
" - tlib#cache#Purge(): delete old cache files (for the moment use find)
" - tlib#file#Relative(): currently relies on cwd to be set
" - tlib#input#EditList(): Disable selection by index number
" - tlib#input#List(): Some kind of command line to edit some 
"   preferences on the fly
" - tlib#input#List(): Make commands accessible via popup-menu

if &cp || exists("loaded_tlib")
    finish
endif
if v:version < 700 "{{{2
    echoerr "tlib requires Vim >= 7"
    finish
endif
let loaded_tlib = 19
let s:save_cpo = &cpo
set cpo&vim


" Commands {{{1
" :display: :TLet VAR = VALUE
" Set a variable only if it doesn't already exist.
" EXAMPLES: >
"   TLet foo = 1
"   TLet foo = 2
"   echo foo
"   => 1
command! -nargs=+ TLet if !exists(matchstr(<q-args>, '^[^=[:space:]]\+')) | exec 'let '. <q-args> | endif


" Open a scratch buffer (a buffer without a file).
"   TScratch  ... use split window
"   TScratch! ... use the whole frame
" This command takes an (inner) dictionnary as optional argument.
" EXAMPLES: >
"   TScratch 'scratch': '__FOO__'
"   => Open a scratch buffer named __FOO__
command! -bar -nargs=* -bang TScratch call tlib#scratch#UseScratch({'scratch_split': '<bang>' != '!', <args>})


" :display: :TVarArg VAR1, [VAR2, DEFAULT2] ...
" A convenience wrapper for |tlib#arg#Let|.
" EXAMPLES: >
"   function! Foo(...)
"       TVarArg ['a', 1], 'b'
"       echo 'a='. a
"       echo 'b='. b
"   endf
command! -nargs=+ TVarArg exec tlib#arg#Let([<args>])


" :display: :TKeyArg DICT, VAR1, [VAR2, DEFAULT2] ...
" A convenience wrapper for |tlib#arg#Let|.
" EXAMPLES: >
"   function! Foo(keyargs)
"       TKeyArg a:keyargs, ['a', 1], 'b'
"       echo 'a='. a
"       echo 'b='. b
"   endf
command! -nargs=+ TKeyArg exec tlib#arg#Key([<args>])


" :display: TBrowseOutput COMMAND
" Every wondered how to effciently browse the output of a command 
" without redirecting it to a file? This command takes a command as 
" argument and presents the output via |tlib#input#List()| so that you 
" can easily search for a keyword (e.g. the name of a variable or 
" function) and the like.
"
" If you press enter, the selected line will be copied to the command 
" line. Press ESC to cancel browsing.
"
" EXAMPLES: >
"   TBrowseOutput 20verb TeaseTheCulprit
command! -nargs=1 -complete=command TBrowseOutput call tlib#cmd#BrowseOutput(<q-args>)



" Variables {{{1

" When 1, automatically select a the last remaining item after applying 
" any filters.
TLet g:tlib_pick_last_item = 1

" If a list is bigger than this value, don't try to be smart when 
" selecting an item. Be slightly faster instead.
TLet g:tlib_sortprefs_threshold = 200

" Scratch window position
TLet g:tlib_scratch_pos = 'botright'

" Size of the input list window (in percent) from the main size (of &lines).
TLet g:tlib_inputlist_pct = 70

" Size of filename columns when listing filenames
TLet g:tlib_inputlist_width_filename = '&co / 3'
" TLet g:tlib_inputlist_width_filename = 25

" The highlight group to use for showing matches in the input list window.
TLet g:tlib_inputlist_higroup = 'IncSearch'

" If a list contains more items, don't do an incremental "live search", 
" but use |input()| the quere the user for a filter. This is useful on 
" slower machines or with very long lists.
TLet g:tlib_inputlist_livesearch_threshold = 500

" Extra tags for |tlib#tag#Retrieve()|. Can also be buffer-local.
TLet g:tlib_tags_extra = ''

TLet g:tlib_filename_sep = '/'
" TLet g:tlib_filename_sep = exists('+shellslash') && !&shellslash ? '\' : '/'   " {{{2

" The cache directory. If empty, use |tlib#dir#MyRuntime|.'/cache'
TLet g:tlib_cache = ''

" Where to display the line when using |tlib#buffer#ViewLine|.
" For possible values for position see |scroll-cursor|.
TLet g:tlib_viewline_position = 'zz'

" :doc:
" Keys for |tlib#input#List|~

TLet g:tlib_inputlist_and = ' '
TLet g:tlib_inputlist_or  = '|'
TLet g:tlib_inputlist_not = '-'

" When editing a list with |tlib#input#List|, typing these numeric chars 
" (as returned by getchar()) will select an item based on its index, not 
" based on its name. I.e. in the default setting, typing a "4" will 
" select the fourth item, not the item called "4".
" In order to make keys 0-9 filter the items in the list and make 
" <m-[0-9]> select an item by its index, remove the keys 48 to 57 from 
" this dictionary.
" Format: [KEY] = BASE ... the number is calculated as KEY - BASE.
" :nodefault:
TLet g:tlib_numeric_chars = {
            \ 48: 48,
            \ 49: 48,
            \ 50: 48,
            \ 51: 48,
            \ 52: 48,
            \ 53: 48,
            \ 54: 48,
            \ 55: 48,
            \ 56: 48,
            \ 57: 48,
            \ 176: 176,
            \ 177: 176,
            \ 178: 176,
            \ 179: 176,
            \ 180: 176,
            \ 181: 176,
            \ 182: 176,
            \ 183: 176,
            \ 184: 176,
            \ 185: 176,
            \}

" :nodefault:
TLet g:tlib_keyagents_InputList_s = {
            \ "\<PageUp>":   'tlib#agent#PageUp',
            \ "\<PageDown>": 'tlib#agent#PageDown',
            \ "\<Up>":       'tlib#agent#Up',
            \ "\<Down>":     'tlib#agent#Down',
            \ "\<c-Up>":     'tlib#agent#UpN',
            \ "\<c-Down>":   'tlib#agent#DownN',
            \ "\<Left>":     'tlib#agent#ShiftLeft',
            \ "\<Right>":    'tlib#agent#ShiftRight',
            \ 18:            'tlib#agent#Reset',
            \ 242:           'tlib#agent#Reset',
            \ 17:            'tlib#agent#Input',
            \ 241:           'tlib#agent#Input',
            \ 27:            'tlib#agent#Exit',
            \ 26:            'tlib#agent#Suspend',
            \ 250:           'tlib#agent#Suspend',
            \ 15:            'tlib#agent#SuspendToParentWindow',  
            \ 63:            'tlib#agent#Help',
            \ "\<F1>":       'tlib#agent#Help',
            \ "\<bs>":       'tlib#agent#ReduceFilter',
            \ "\<del>":      'tlib#agent#ReduceFilter',
            \ "\<c-bs>":     'tlib#agent#PopFilter',
            \ "\<m-bs>":     'tlib#agent#PopFilter',
            \ "\<c-del>":    'tlib#agent#PopFilter',
            \ "\<m-del>":    'tlib#agent#PopFilter',
            \ 191:           'tlib#agent#Debug',
            \ char2nr(g:tlib_inputlist_or):  'tlib#agent#OR',
            \ char2nr(g:tlib_inputlist_and): 'tlib#agent#AND',
            \ }

" Number of items to move when pressing <c-up/down> in the input list window.
TLet g:tlib_scroll_lines = 10

" :nodefault:
TLet g:tlib_keyagents_InputList_m = {
            \ 35:          'tlib#agent#Select',
            \ "\<s-up>":   'tlib#agent#SelectUp',
            \ "\<s-down>": 'tlib#agent#SelectDown',
            \ 1:           'tlib#agent#SelectAll',
            \ 225:         'tlib#agent#SelectAll',
            \ }
" "\<c-space>": 'tlib#agent#Select'

" :nodefault:
TLet g:tlib_handlers_EditList = [
            \ {'key': 5,  'agent': 'tlib#agent#EditItem',    'key_name': '<c-e>', 'help': 'Edit item'},
            \ {'key': 4,  'agent': 'tlib#agent#DeleteItems', 'key_name': '<c-d>', 'help': 'Delete item(s)'},
            \ {'key': 14, 'agent': 'tlib#agent#NewItem',     'key_name': '<c-n>', 'help': 'New item'},
            \ {'key': 24, 'agent': 'tlib#agent#Cut',         'key_name': '<c-x>', 'help': 'Cut item(s)'},
            \ {'key':  3, 'agent': 'tlib#agent#Copy',        'key_name': '<c-c>', 'help': 'Copy item(s)'},
            \ {'key': 22, 'agent': 'tlib#agent#Paste',       'key_name': '<c-v>', 'help': 'Paste item(s)'},
            \ {'pick_last_item': 0},
            \ {'return_agent': 'tlib#agent#EditReturnValue'},
            \ ]


augroup TLib
    autocmd!
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo

finish
-----------------------------------------------------------------------

CHANGES:
0.1
Initial release

0.2
- More list convenience functions
- tlib#EditList()
- tlib#InputList(): properly handle duplicate items; it type contains 
'i', the list index + 1 is returned, not the element

0.3
- tlib#InputList(): Show feedback in statusline instead of the echo area
- tlib#GetVar(), tlib#GetValue()

0.4
- tlib#InputList(): Up/Down keys wrap around list
- tlib#InputList(): FIX: Problem when reducing the filter & using AND
- tlib#InputList(): Made <a-numeric> work (can be configured via 
- tlib#InputList(): special display_format: "filename"
- tlib#Object: experimental support for some kind of OOP
- tlib#World: Extracted some functions from tlib.vim to tlib/World.vim
- tlib#FileJoin(), tlib#FileSplit(), tlib#RelativeFilename()
- tlib#Let()
- tlib#EnsureDirectoryExists(dir)
- tlib#DirName(dir)
- tlib#DecodeURL(url), tlib#EncodeChar(char), tlib#EncodeURL(url)
- FIX: Problem when using shift-up/down with filtered lists

0.5
- tlib#InputList(): FIX: Selecting items in filtered view
- tlib#InputList(): <c-bs>: Remove last AND pattern from filter

0.6
- tlib#InputList(): Disabled <c-space> map
- tlib#InputList(): try to be smart about user itentions only if a 
list's length is < g:tlib_sortprefs_threshold (default: 200)
- tlib#Object: Super() method
- tlib#MyRuntimeDir()
- tlib#GetCacheName(), tlib#CacheSave(), tlib#CacheGet()
- tlib#Args(), tlib#GetArg()
- FIX: tlib#InputList(): Display problem with first item

0.7
- tlib#InputList(): <c-z> ... Suspend/Resume input
- tlib#InputList(): <c-q> ... Input text on the command line (useful on 
slow systems when working with very large lists)
- tlib#InputList(): AND-pattern starting with '!' will work as 'exclude 
matches'
- tlib#InputList(): FIX <c-bs> pop OR-patterns properly
- tlib#InputList(): display_format == filename: don't add '/' to 
directory names (avoid filesystem access)

0.8
- FIX: Return empty cache name for buffers that have no files attached to it
- Some re-arranging

0.9
- Re-arrangements & modularization (this means many function names have 
changed, on the other hand only those functions are loaded that are 
actually needed)
- tlib#input#List(): Added maps with m-modifiers for <c-q>, <c-z>, <c-a>
- tlib#input#List(): Make sure &fdm is manual
- tlib#input#List(): When exiting the list view, consume the next 5 
characters in the queue (if any)
- tlib#input#EditList(): Now has cut, copy, paste functionality.
- Added documentation and examples

0.10
- tlib#input#List(): (v)split type of commands leave the original window 
untouched (you may use <c-w> to replace its contents)
- tlib#file#With(): Check whether an existing buffer is loaded.
- Scratch related functions went to tlib/scratch.vim so that they are 
accessible from other scripts.
- Configure the list window height via g:tlib_inputlist_pct (1..100%)

0.11
NEW:
    - The :TLet command replaces :TLLet (which was removed)
    - :TScratch[!] command (with ! don't split but use the whole window)
    - tlib#rx#Escape(text, ?magic='m')
    - tlib#buffer#GetList(?show_hidden=0)
    - tlib#dir#CD(), tlib#dir#Push(), tlib#dir#Pop()
    - tlib#input#ListW: A slightly remodeled version of tlib#input#List 
    that takes a World as second argument.
    - Added some documentation doc/tlib.txt (most of it is automatically 
    compiled from the source files)
CHANGES:
    - tlib#input#List(): The default keys for AND, NOT have changed to 
    be more Google-like (space, minus); the keys can be configured via 
    global variables.
IMPROVEMENTS:
    - In file listings, indicate if a file is loaded, listed, modified 
    etc.
    - tlib#input#List(): Highlight the filter pattern
    - tlib#input#List(): <c-up/down> scrolls g:tlib_scroll_lines 
    (default=10) lines
FIXES:
    - tlib#input#List(): Centering line, clear match, clear & restore 
    the search register
    - tlib#input#List(): Ensure the window layout doesn't change (if the 
    number of windows hasn't changed)
    - tlib#arg#Ex(): Don't escape backslashes by default

0.12
NEW:
    - tlib/tab.vim
CHANGES:
    - Renamed tlib#win#SetWin() to tlib#win#Set()
IMPROVEMENTS:
    - tlib#input#List(): <left>, <right> keys work in some lists
    - tlib#input#List(): If an index_table is provided this will be used 
    instead of the item's list index.
FIXES:
    - tlib#input#List(): Problem with scrolling, when the list was 
    shorter than the window (eg when using a vertical window).
    - tlib#cache#Filename(): Don't rewrite name as relative filename if 
    explicitly given as argument. Avoid double (back)slashes.
    - TLet: simplified

0.13
CHANGES:
    - Scratch: Set &fdc=0.
    - The cache directory can be configured via g:tlib_cache
    - Renamed tlib#buffer#SetBuffer() to tlib#buffer#Set().
FIXES:
    - tlib#input#List(): Select the active item per mouse.
    - TLet: simplified

0.14
NEW:
    - tlib#buffer#InsertText()
CHANGES:
    - tlib#win#[SG]etLayout(): Use a dictionnary, set &cmdheight.
FIXES:
    - Wrong order with pre-defined filters.

0.15
NEW:
    - tlib#string#TrimLeft(), tlib#string#TrimRight(), tlib#string#Strip()
    - Progress bar

0.16
NEW:
    - tlib#string#Printf1()

0.17
NEW:
    - TBrowseOutput
- Some minor changes

0.18
NEW:
    - tlib/time.vim
    - g:tlib_inputlist_livesearch_threshold
CHANGES:
    - tlib#input#ListD(), World: Don't redisplay the list while typing 
    new letters; calculate filter regexps only once before filtering the 
    list.
    - World.vim: Minor changes to how filenames are handled.

0.19
NEW:
    - tag.vim
FIX:
    - dir.vim: Use plain dir name in tlib#dir#Ensure()
    - tlib#input#List(): An initial filter argument creates [[filter]] 
    and not as before [[''], [filter]].
    - tlib#input#List(): When type was "si" and the item was picked by 
    filter, the wrong index was returned.
    - tlib#input#List(): Don't check if chars are typed when displaying 
    the list for the first time.

