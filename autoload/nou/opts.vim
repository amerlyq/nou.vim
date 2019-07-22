""" Registry Hive

let s:nou = {}
let s:nou.deflvl = 1  " def color on first D levels (OR: immediate outline)
let s:nou.cyclic = 1  " cyclic colors (OR: def color when indent >Nc)
let s:nou.widesp = 0  " indent by also \u3000 (OR: only spaces/tabs)
" TRY:ALT: join loose text with upper item on same level
let s:nou.loose = 0   " round inexact indent to prev lvl


let s:nou.decision = {}
let s:nou.decision.symbol = '[.]'
let s:nou.decision.colors = [
  \ ['\*{1,3}', '#268bd2'],
  \ ['\+{1,3}', '#859900'],
  \ ['\-{1,3}', '#2aa198'],
  \ ['\={1,3}', '#6c71c4'],
  \ ['\:{1,3}', '#6c71c4'],
  \ ['\~{1,3}', '#d33682'],
  \ ['\?{1,3}:?', '#dd6616'],
  \ ['\!{1,3}', '#dc322f'],
  \ ['\<{1,3}[-~=]*', '#c5a900'],
  \ ['[-~=]*\>{1,3}', '#d33682'],
  \ ]

let s:nou.accent = {}
let s:nou.accent.colors = {
  \ 'Normal': ['`', 'NONE'],
  \ 'Bold': ['\*', 'bold'],
  \ 'Italic': ["'", 'italic'],
  \ 'Underlined': ['_', 'underline'],
  \ }

" FIXME: 'Str' must not contains @accents for cases like "_some_symbol_"
let s:nou.term = {}
let s:nou.term.colors = {
  \ 'Key': ['\<', '\>', 'ctermfg=1 guifg=#dc322f'],
  \ 'Str': ['"', '"', 'ctermfg=81 guifg=#5fdfff'],
  \ 'Err': ['!', '!', 'ctermfg=196 guifg=#ff0000 gui=bold,italic'],
  \ 'Que': ['\?', '\?', 'ctermfg=208 guifg=#ff8700 gui=bold,italic'],
  \ 'Wrn': ['\~', '\~', 'ctermfg=226 guifg=#ffff00 gui=bold,italic'],
  \ 'Add': ['\+', '\+', 'ctermfg=46 guifg=#00ff00 gui=bold,italic'],
  \ 'Not': ['\-', '\-', 'ctermfg=44 guifg=#00dfdf gui=bold,italic,undercurl'],
  \ 'Standout': ['\|', '\|', 'ctermbg=16 guibg=#000000'],
  \ }


let s:nou.header = {}
let s:nou.header.symbol = '\%'
let s:nou.header.ascending = 0
let s:nou.header.colors = [
  \ '#d33682',
  \ '#dc322f',
  \ '#dd6616',
  \ '#c5a900',
  \ '#859900',
  \ ]

let s:nou.delimit = {}
let s:nou.delimit.colors = [
  \ ['"X', '#586e75'],
  \ ['+', '#859900'],
  \ ['>@', '#d33682'],
  \ ['=^', '#268bd2'],
  \ ['-', '#2aa198'],
  \ ['?*', '#c5a900'],
  \ ['!<', '#dd6616'],
  \ ['.~', '#dc322f'],
  \ [':', '#6c71c4'],
  \ ['#_', '#fdf6e3'],
  \ ]

let s:nou.outline = {}
" NOTE: whole 'hi' cmdline can be specified
let s:nou.outline.colors = [
  \ '#268bd2',
  \ '#2aa198',
  \ '#859900',
  \ '#c5a900',
  \ '#dd6616',
  \ '#dc322f',
  \ '#d33682',
  \ '#6c71c4',
  \ '#586e75',
  \ ]

let s:nou.embed = {
  \ 'sh': ['\$#?', '[$#]'],
  \ }

" THINK:TRY: using text bg colors
" -- additional levels/markers equivalent as combo (fg + bg)
" -- only as accents for existing levels (inside concealed block of `[{,etc)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! nou#opts#init()
  if exists('g:nou._loaded') && g:nou._loaded| return |en
  if exists('g:nou') && type(g:nou) == type({})
    call nou#opts#merge(s:nou, g:nou, 'force')
  endif
  let g:nou = s:nou
  let g:nou._loaded = 1
endf


" EXPL: deep merge traversing whole tree
fun! nou#opts#merge(dst, aug, ...)
  call extend(a:dst, a:aug, get(a:, 1, 'keep'))
  for k in keys(a:aug) | if type(a:aug[k]) == type({})
    if type(a:dst[k]) != type({})
      throw "Wrong type '".type(a:dst[k])."' for '".k."' option."
    endif
    call nou#opts#merge(a:dst[k], a:aug[k])
  endif | endfor
endf
