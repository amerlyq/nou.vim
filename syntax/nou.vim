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


" ATT: define before accents, to suppress conflicts with |..|
hi! nouTableDelim cterm=bold ctermfg=172 gui=bold guifg=#d78700
syn cluster nouArtifactQ add=nouTableDelim
syn match nouTableDelim display excludenl '|'

" ATT: placed before accents, to distinguish _underline_ from _extension
call nou#syntax#artf_ext()
call nou#syntax#artf_hashtag()
call nou#syntax#artf_addressing()
call nou#syntax#artf_contact()
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


" WARNING: define after accents!
" THINK: concealends -> replace by some unusual unicode chars
"   -- MAYBE: completely hidden? for nice joining multiline
"   ``` some
"   text ```
"   BUT we lose nice block emphasis
"   some ```
"   nteee
"   ```
"   CHECK:(option?) compare two possible styles. Document both ways and their merits.
" BUG: conflicting/tearing syntax on up/down motion for text after closing ```
"   -- seems problem in transparent+containedin
" BUG: w/o 'matchgroup': closing '```' is concealed transparent rules of accent
"   -- Moreover -- we can't make something like oneline block (``` ... ```)
" BAD:(fold) don't work with 'fdm=indent'
syn region nouBlock display keepend excludenl transparent contained extend fold
  \ matchgroup=Special containedin=@nouOutlineQ
  \ start='\v`{3}' end='\v`{3}'


""" Blocks
" plain text/notes/lists -- multiline

" THINK: colorized list
" -- make diff colors for items (prepended by '*', etc) on same outline level
" ?? nested lists -- indistinguishable bounds between lists

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


""" Artifacts
" comments, url, path -- objects

" THINK: hashtags -- directly attached to words
" -- EXPL: @some #tag &link
" -- multiple: #(tag1,tag2,tag3) OR:(can't 'ga') #tag1,#tag2 BAD #tag1#tag2

hi def link nouComment Comment
syn region nouComment display oneline keepend
  \ start='^#\s' start='\s\s\zs#\s' excludenl end='\s#\ze\s\s' end='$'

" EXPL: https, ftp, news, file
" THINK: diff color urls -- don't do 'contains=@nouArtifactG'
" TRY: different color for heading and '[/?=]' in url
hi! nouArtifactUrl cterm=underline ctermfg=62 gui=underline guifg=#6c71c4
syn cluster nouArtifactQ add=nouArtifactUrl
syn match nouArtifactUrl display excludenl
  \ '\v<%(\w{3,}://|www\.|%(mailto|javascript):)\S*'
" OR:(exclude trailing): \S{-}\ze%([[:blank:],)]|$)

" File-like urls override for direct download (.pdf, .md, .doc, ...)
hi! nouArtifactUrlFile cterm=underline ctermfg=27 gui=underline guifg=#005fff
syn cluster nouArtifactQ add=nouArtifactUrlFile
syn match nouArtifactUrlFile display excludenl
  \ '\v<%(\w{3,}://)\S{-}\.%(x?html?|php)@!\a{2,4}\ze%([[:blank:],)]|$)'

call nou#syntax#path()
call nou#syntax#regex()

" " BUG: breaks '<' decision
" hi! nouPunct ctermfg=1 guifg=#ff0000
" syn cluster nouArtifactQ add=nouPunct
" syn match nouPunct display excludenl '[<>]'

" BAD: ignored after task marker [X] !~ \A+ or after any other 'decision'
"  => E.G. even '\v^%(\s{4})@<=\k+' isn't working
hi! nouArtifactKey cterm=bold ctermfg=167 gui=bold guifg=#df5f5f
syn cluster nouArtifactQ add=nouArtifactKey
syn match nouArtifactKey display excludenl
  \ '\v^%(\A{-}\s@1<=)?\zs\k+:%(\ze\s|$)'

" BAD: ignored after task marker [X] !~ \A+ or after any other 'decision'
"  => E.G. even '\v^%(\s{4})@<=\k+' isn't working
hi! nouArtifactVar cterm=bold ctermfg=9 gui=bold guifg=#df5f00
syn cluster nouArtifactQ add=nouArtifactVar
syn match nouArtifactVar display excludenl
  \ '\v%([$]\w+|[$]\{\w+\})>'

"" ATT: must be after nouArtifactKey for correct 'nouNumberXaddr' hi!
runtime autoload/nou/number.vim


" MAYBE: make "nouDate/nouTime" into overlay notches to be highlighted everywhere
hi! nouDate ctermfg=178 guifg=#dfaf00
syn match nouDate display excludenl
  \ '\v<20\d\d-%(0\d|1[012])-%([012]\d|3[01])>'

" hi! nouTime ctermfg=210 guifg=#ff8787
hi! nouTime ctermfg=248 guifg=#a8a8a8
syn match nouTime display excludenl
  \ '\v<%(\d|[01]\d|2[0-4]):[0-5]\d%(:[0-5]\d)?>'


"" ATT: must be after nouNumber to override date
" DISABLED: too bright checkbox is distracting
" hi! nouTaskTodo ctermfg=15 guifg=#beeeee
hi! nouTaskTodo ctermfg=14 guifg=#586e75
syn cluster nouTaskQ add=nouTaskTodo
syn match nouTaskTodo display excludenl '\V[_]'

hi! nouTaskDone ctermfg=14 guifg=#586e75
syn cluster nouTaskQ add=nouTaskDone
syn match nouTaskDone display excludenl '\V[X]'

hi! nouTaskCancel ctermfg=160 guifg=#df0000
syn cluster nouTaskQ add=nouTaskCancel
syn match nouTaskCancel display excludenl '\V[$]'

" HACK: different yellowish/rainbow color for incomplete tasks /[01-99%]/
for i in keys(g:nou.task.colors)
  exe 'hi! nouTaskProgress'.i .' '. g:nou.task.colors[i]
  exe 'syn cluster nouTaskQ add=nouTaskProgress'.i
  exe 'syn match nouTaskProgress'.i.' display excludenl "\V['.i.'\d%]"'
endfor

hi! nouTask ctermfg=14 guifg=#586e75
syn match nouTask display excludenl contains=@nouTaskQ
  \ '\v%(\d{4}-\d\d-\d\d )?\[%([_$X]|\d\d\%)\]'



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

syn cluster nouTextQ add=@Spell,nouComment,nouDate,nouTime,nouTask
  \,@nouTaskQ,@nouArtifactQ,@nouAccentQ,@nouTermQ,@nouEmbedQ

" EXPL: must be last line -- set single-loading guard only if no exceptions
let b:current_syntax = 'nou'
