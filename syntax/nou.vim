"" Syntax highlight for nou.vim
if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish  " EXPL: allows to redefine this syntax by user's 'syntax/ag.vim'
endif

syntax case match       " Individual ignorecase done by '\c' prefix (performance)
syntax spell toplevel   " Check for spelling errors in all text.

""" Outline (cyclic N-colors)
" ALT:BAD? reuse spaces as colormap keys \z%(\s*)\S -> g:nou.color[\z1]
" THINK: using other symbols beside spaces

for i in range(len(g:nou.outline.colors))
  call nou#syntax#outline(i)
endfor

""" Structure
" headers/delimiters

" THINK: use for zero-level only or for any level?

" THINK: horizontal rulers
" -- BETTER? constant color or change by indent
for i in range(len(g:nou.delimit.colors))
  call nou#syntax#delimit(i)
endfor

""" Blocks
" plain text/notes/lists -- multiline

" THINK: colorized list
" -- make diff colors for items (prepended by '*', etc) on same outline level
" ?? nested lists -- indistinguishable bounds between lists

""" Decision
" %([?*><]|--)\s -- separated from words by space

" THINK: using decision markers in the middle of sentence?
" -- MAYBE surround them like PL: (? good idea) or [< because of] or {> bad}
" THINK: notches include in 'plugin/' of nou.vim
" -- as them are mark-up for notes throughout all text files
" -- can setup include/exclude ft

""" Accents
" '"`{[(_: -- symmetrical pair

" THINK: blue asteriks/nums for lists inside comments (part of notches?)
" -- support extended comments in any text file
" THINK: italic -- as part of 'hi' or as accent itself?
" -- italic accent inside italic hi/accent -> must become non-italic

""" Artifacts
" comments, url, path -- objects

" THINK: hashtags -- directly attached to words
" -- EXPL: @some #tag &link
" -- multiple: #(tag1,tag2,tag3) OR:(can't 'ga') #tag1,#tag2 BAD #tag1#tag2

syn match Comment display excludenl '#\s.*$'

" EXPL: https, ftp, news, file
hi def link nouArtifactUrl Underlined
syn match nouArtifactUrl display excludenl
  \ '\v<%(\w{3,}://|www\.|%(mailto|javascript):)\S*'

" THINK: diff color urls -- don't do 'contains=@nouArtifactG'

" CHECK:
" -- syntax higlighting block between two marks start=/\%'m/ end=/\%'n/
" -- rule to highlight till/from cursor position start=/\%#/

" EXPL: must be last line -- set single-loading guard only if no exceptions
let b:current_syntax = 'nou'
