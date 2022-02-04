"" Syntax highlight for nou.vim
if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish  " EXPL: allows to redefine this syntax by user's 'syntax/ag.vim'
endif
call nou#opts#init()    " Init opts when only 'syntax on' called

syntax case match       " Individual ignorecase done by '\c' prefix (performance)
syntax sync clear
syntax sync minlines=5  " Correct hi! for embed regions opened at the middle
syntax spell toplevel   " Check for spelling errors in all text.
" hi def link nouConceal NonText
hi! nouConceal ctermfg=8 guifg=#001b26
" hi! link Conceal nouConceal

" ATTENTION: _defining order_ problem
" USE: guisp=color, guifg=fg, guibg=bg

" ENH:THINK if array of colors is empty -- don't generate this syntax part
" BAD: transparent+matchgroup with same region/matchgroup name
"   => BUG: higlighting end match don't work
"   => ALT: don't use 'transparent' -- list groups separately
"     => BUT: then can't inherit outline body color (uses match color instead)


""" NOTE: placed at top to be overrided by decisions
" BUG: inlined decisions (? ... ) -- will be FIXED by def their syntax
call nou#syntax#art_delim('[[:punct:]]+')
" ATT: placed before accents, to distinguish _underline_ from _extension
call nou#syntax#artf_ext()
runtime autoload/nou/syntax/tag.vim
call nou#syntax#artf_contact()
runtime autoload/nou/syntax/artf.vim
runtime autoload/nou/syntax/infix.vim

" ATT: must be before "nou#syntax#term(k)" to be overridden by "!term!"
runtime autoload/nou/syntax/version.vim


" BUG: w/o embedded syntax highlight -- "IDEA:(aa):" isn't highlighted as function
"   => stick to single method despite presence of '$ ...' pattern in file
call nou#syntax#artf_function()

""" Accents
" '"`{[(_: -- symmetrical pair.
" ALSO: complex bounds like {: ... :} -- make diff bg/fg accents spectrum
" ALSO: -strikethrough-  ~wavy~  >small<  <big>  __word__
" BUT:NEED: distinguish accents from hashtags!
" USE: conceal in syntax, but disable conceal in ftplugin (if horrible)
" CHECK: using normal/bold/italic we can span multiline if remove 'keepend'
" USE: bold underline undercurl reverse/inverse italic standout NONE
" TRY:(option) unused color 15/#ffffff (instead of 8) -- as main for accents?
" ADD: unconcealed accent/object <...> link to Special (? only borders or whole?). Or better conceal?

" THINK: blue asteriks/nums for lists inside comments (part of notches?)
" -- support extended comments in any text file
" THINK: italic -- as part of 'hi' or as accent itself?
" -- italic accent inside italic hi/accent -> must become non-italic
" WARNING: if I will use combined accents ( _*some*_ ) -- defining order must
"     be strict -- so must use list instead of map

" BUG: when changing only attributes -- color is not inherited
"   ALT: union of attribute + link to -- create individual groups for outline
"     :hi nouItalic1 gui=italic | hi! link nouItalic1 nouOutline1
"   DEV: toggle by option -- individual colors or general one
"     NOTE: general has merits of contrast and more performance than individual

runtime autoload/nou/syntax/operator.vim
for k in keys(g:nou.term.colors)
  call nou#syntax#term(k)
endfor
for k in keys(g:nou.accent.colors)
  call nou#syntax#accent(k)
endfor


""" Outline (cyclic N-colors)
" ALT:BAD? reuse spaces as colormap keys \z%(\s*)\S -> g:nou.color[\z1]
" THINK: using other symbols beside spaces

" THINK: use 'match' for indent and then 'nextgroup' for text/decision/etc
"   => BAD: text/decision can't inherit color of outline, need separate define
" BUG:FIXME: generate syntax with correct indent only after modline was read
"   -- # vim:ft=nou:sts=4:ts=4:sw=4:spell

for i in range(len(g:nou.outline.colors))
  call nou#syntax#outline(i)
endfor


""" Headers
" WARNING: define after accents!

for i in range(len(g:nou.header.colors))
  call nou#syntax#header(i)
endfor


""" Delimiters
" WARNING: define after accents!

" THINK: use for zero-level only or for any level? Make option?
"   BUG: currently don't work for non-zero level
" THINK: horizontal rulers
" -- BETTER? constant color or change by indent

for i in range(len(g:nou.delimit.colors))
  call nou#syntax#delimit(i)
endfor


""" Decision
" %([?*><]|--)\s -- separated from words by space
" NOTE: also highlight on 0-level
" NOTE: treat \s as part of start/end match -- nice for underlined blocks
"   -- ALT: start.'rs=e-1' end.'re=s+1
" BUG: pressing <CR> in insert mode --> diff indent after diff symbols

" ENH:TRY: multiline blocks can be achieved by removing 'keepend' in outlines
"   -- THEN decision block will span until ending symbol found
" THINK: colorize only marker, keep color from level
" THINK: using decision markers in the middle of sentence?
" -- MAYBE surround them like PL: (? good idea) or [< because of] or {> bad}
" THINK: notches include in 'plugin/' of nou.vim
" -- as them are mark-up for notes throughout all text files
" -- can setup include/exclude ft

" FIXME: must be placed before 'outline' defs (due to patt-match order)
for i in range(len(g:nou.decision.colors))
  call nou#syntax#decision(i)
endfor


"" ATT: must be after nouArtifactKey for correct 'nouNumberXaddr' hi!
"" BAD:(syntax/nou/*): will load all files inside by vim itself
runtime autoload/nou/syntax/number.vim
runtime autoload/nou/syntax/path.vim
call nou#syntax#regex()  " ATT: must be after nouPath to override rgx=/.../
runtime autoload/nou/syntax/keyval.vim
runtime autoload/nou/syntax/group.vim
runtime autoload/nou/syntax/datetime.vim
runtime autoload/nou/syntax/goal.vim


" CHECK:
" -- syntax higlighting block between two marks start=/\%'m/ end=/\%'n/
" -- rule to highlight till/from cursor position start=/\%#/

" syn cluster nouSpoilerQ add=nouSpoiler
" syn region nouSpoiler display oneline keepend transparent extend conceal
"   \ matchgroup=nouConceal cchar=…
"   \ start='{+' end='+}'
" TRY:MOVE: spoiler as matchadd() overlay to not conflict with underlying groups
"   BAD:(, {"conceal": "…"}): produces cchars per each hi group inside spoiler
call matchadd('Conceal', '{+.*+}', -1, -1)
" ALT:TRY:(exclusive for LocationSpoiler): /…\zs.*\ze\s|/

for ft in keys(g:nou.embed)
  call nou#syntax#embedded(ft)
endfor

syn cluster nouTextQ add=@Spell,@nouGenericQ
  \,@nouArtifactQ,@nouAccentQ,@nouTermQ,@nouEmbedQ

" WARNING: define after accents!
runtime autoload/nou/syntax/block.vim
runtime autoload/nou/syntax/xtref.vim

" EXPL: must be last line -- set single-loading guard only if no exceptions
let b:current_syntax = 'nou'
