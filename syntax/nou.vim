"" Syntax highlight for nou.vim
if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish  " EXPL: allows to redefine this syntax by user's 'syntax/ag.vim'
endif

syntax case match       " Individual ignorecase done by '\c' prefix (performance)
syntax spell toplevel   " Check for spelling errors in all text.

let s:colors = [
  \ "#dc322f",
  \ "#dd6616",
  \ "#859900",
  \ "#586e75",
  \ "#268bd2",
  \ "#6c71c4",
  \ "#d33682",
  \ "#c5a900",
  \ ]

""" Outline (cyclic N-colors)
" ALT:BAD? reuse spaces as colormap keys \z%(\s*)\S -> g:nou.color[\z1]
" NOTE:
"   indent by spaces or tabs (ignores \u3000)
"   cyclic colors (TRY:ALT: default text color when >N colors)

let g:nou = {}

fun! s:defL(c, i)
  let ind = '%(\t| {'.&ts.'})'
  let N = len(a:c)
  let nm = 'nouOutline'.a:i
  exe 'hi! '.nm.' guifg='.a:c[a:i]
  exe 'syn region '.nm.' display oneline keepend'
  \.' start=/\v^%('.ind.'{'.N.'}){-}'.ind.'{'.a:i.'}\ze\S/'
  \.' excludenl end=/$/'
endf

for i in range(len(s:colors))
  call s:defL(s:colors, i)
endfor

""" Blocks
" plain text/notes

""" Decision
" ?*><

""" Accents
" '"`{[(_

""" Artifacts
" url, path
syntax match Comment "^\s*:.*$"


" TODO: if cyclic/repeatable coloring impossible
" -- (nested > N) has the same color as ft default text
" -- TRY: make it toggleable -- move functions into 'autoload/nou/syntax.vim'
" THINK: colorized list
" -- make diff colors for items (prepended by '*', etc) on same outline level
" ?? nested lists -- indistinguishable bounds between lists
" THINK: horizontal rulers
" -- any character repeating > 5 times, color =~ charcode % 16
" THINK: blue asteriks/numbers for lists inside comments (part of notches?)
" -- support extended comments in any text file
" THINK: notches include in 'plugin/' of nou.vim
" -- as them are mark-up for notes throughout all text files
" -- can setup include/exclude ft
" CHECK:
" -- syntax higlighting block between two marks start=/\%'m/ end=/\%'n/
" -- rule to highlight till/from cursor position start=/\%#/

" EXPL: must be last line -- set single-loading guard only if no exceptions
let b:current_syntax = 'nou'
