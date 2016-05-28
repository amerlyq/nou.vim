""" Registry Hive

let s:nou = {}
let s:nou.deflvl = 1  " def color on first D levels (OR: immediate outline)
let s:nou.cyclic = 1  " cyclic colors (OR: def color when indent >Nc)
let s:nou.widesp = 0  " indent by also \u3000 (OR: only spaces/tabs)
" TRY:ALT: join loose text with upper item on same level
let s:nou.loose = 0   " round inexact indent to prev lvl


let s:nou.delimit = {}
let s:nou.delimit.colors = [
  \ ['=', '#d33682'],
  \ ['-', '#268bd2'],
  \ ['*', '#c5a900'],
  \ ]

let s:nou.outline = {}
" NOTE: whole 'hi' cmdline can be specified
let s:nou.outline.colors = [
  \ '#dc322f',
  \ '#dd6616',
  \ '#859900',
  \ '#586e75',
  \ '#268bd2',
  \ '#6c71c4',
  \ '#d33682',
  \ '#c5a900',
  \ ]

" THINK:TRY: using text bg colors
" -- additional levels/markers equivalent as combo (fg + bg)
" -- only as accents for existing levels (inside concealed block of `[{,etc)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! nou#opts#init()
  if exists('g:nou') && type(g:nou) == type({})
    call nou#opts#merge(s:nou, g:nou, 'force')
  endif
  let g:nou = s:nou
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
