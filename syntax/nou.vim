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
runtime autoload/nou/syntax/tag.vim
call nou#syntax#artf_contact()


"" ATT: placed before nouObjectPfx to override @Name.Surname
syn cluster nouArtifactQ add=nouArtifactAddressing
hi nouArtifactAddressing cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=80 guifg=#5fdfdf
syn match nouArtifactAddressing display excludenl /\v%(^|[(\[{,;|[:blank:]]@1<=)%(\@\a\k{-}%(\.\k{-})?)%([|;,}\])[:blank:]]@1=|$)/
hi nouArtifactAddrName cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=75 guifg=#67afff
syn match nouArtifactAddrName display excludenl contained containedin=nouArtifactAddressing /\v\@%(\k{-}\.|\u\u@1=)?/


"" e.g. tag-token like <^JIRA-12345>
syn cluster nouArtifactQ add=nouArtifactUrlAlias
hi nouArtifactUrlAlias cterm=bold,reverse ctermbg=NONE gui=bold,reverse guibg=NONE ctermfg=62 guifg=#6c71c4
syn match nouArtifactUrlAlias display excludenl /\v%(^|[(\[{,;|[:blank:]]@1<=)%(\^\S{-1,})%([|;,}\])[:blank:]]@1=|$)/

"" user group OR role like <%dev>
syn cluster nouArtifactQ add=nouArtifactRole
hi nouArtifactRole cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=172 guifg=#df8700
syn match nouArtifactRole display excludenl /\v%(^|[(\[{,;|[:blank:]]@1<=)%(\%\a\k{-})%([|;,}\])[:blank:]]@1=|$)/


" ATT: define after artf_hashtag() to override #1 hashtag
" ALT: subgroups :: *Index{Hash,Dot,No,Braces,...}
" TRY: diff color :: nextgroup=nouPathBody
" BET? isolate by space :: \%(^\|[[:punct:][:blank:]]\@1<=\)...
" ALT: *Numero  '№'  BAD: incomplete font support -- and blades with next number
syn cluster nouArtifactQ add=nouArtifactIndex,nouArtifactAltMod
hi nouArtifactIndex cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=172 guifg=#df8700
syn match nouArtifactIndex display excludenl '\v%([#]\d+>|\(\d+\))'
hi nouArtifactAltMod cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=142 guifg=#df4fbf
syn match nouArtifactAltMod display excludenl '\v%([%]\d+>|\{\d+\})'


syn cluster nouArtifactQ add=@nouArtifactEmojiQ
" SEE: https://emojipedia.org/red-heart/
" VIZ: green=💚 yellow=💛 orange=🧡 brown=🤎 purple=💜 blue=💙 white=🤍♡ black=🖤♥ spark=💖 broken=💔 two=💕 glow=💗 jap=心
" IDEA: prio-emoji: "↥↑⮬⤉⤒⮭￪🔝🢙🮸⮉" | "⮎↪↓⮮⮯￬🮷⮋" | "￩𐇙￫⮩⮫⮊⭮⥁➺➲➛⌁⇴⇝↝→🔜"
syn cluster nouArtifactEmojiQ add=nouEmojiRed
hi nouEmojiRed cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=196 guifg=#ff0000
syn match nouEmojiRed display excludenl '[✗♡♥🤍🖤💛💜🔝‼]'

syn cluster nouArtifactEmojiQ add=nouEmojiGreen
hi nouEmojiGreen cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=40 guifg=#00ff00
syn match nouEmojiGreen display excludenl '[✓➺⊞➕]'

" #1060ff #6060ff #87afff #87dfff
syn cluster nouArtifactEmojiQ add=nouEmojiBlue
hi nouEmojiBlue cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=117 guifg=#87dfff
syn match nouEmojiBlue display excludenl '[↯⁃]'

" SPLIT: rename "syn match" to "nouInfix" and "hi link" to nouEmoji colors
" nouInfix(source/intent) {{{
syn cluster nouArtifactEmojiQ add=nouEmojiOrange
hi nouEmojiOrange cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=172 guifg=#df8700
syn match nouEmojiOrange display excludenl '[⋆⇴🔜⁇]'

syn cluster nouArtifactEmojiQ add=nouEmojiGray
hi nouEmojiGray cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=242 guifg=#707070
syn match nouEmojiGray display excludenl '[↻📲📩↓🔚終]'

syn cluster nouArtifactEmojiQ add=nouEmojiPink
hi nouEmojiPink cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=161 guifg=#df1f5f
syn match nouEmojiPink display excludenl '[≈▶➥]'
" }}}


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


""" Artifacts
" comments, url, path -- objects

syn cluster nouGenericQ add=nouComment
hi def link nouComment Comment
syn region nouComment display oneline keepend excludenl
  \ start='\v%(^|\s\zs)\z([#]{1,4})\s' end='\v\s\z1%(\ze\s|$)' end='$'

" NOTE: developer's documentation comments
syn cluster nouGenericQ add=nouCommentDevDoc
hi nouCommentDevDoc cterm=NONE gui=NONE ctermbg=8 guibg=#002430 ctermfg=242 guifg=#707070
syn region nouCommentDevDoc display oneline keepend
  \ start='^#%' start='\s\zs#%' excludenl end='$'

" NOTE: hi! dot-prefix of "obj.sub.key=val" and "obj.func()"
" ORNG: ctermfg=224 guifg=#cb4b16 YELW: ctermfg=121 guifg=#b58900 BLUE: ctermfg=33 guifg=#2060e0
" NICE: #c56b1f | #8f4f1f
syn cluster nouGenericQ add=nouObjectPfx
hi nouObjectPfx cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=224 guifg=#8f4f1f
syn match nouObjectPfx display excludenl
  \ '\v%(^|[[:punct:][:blank:]]@1<=)%(\k+[.])+\ze\k'


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
syn match nouArtifactVar display excludenl contains=nouArtifactVarPfx
  \ '\v%([$]\w+>|[$]\{\w+\}|[$]\(\w+\))'

hi nouArtifactVarPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=9 guifg=#8f3f00
syn match nouArtifactVarPfx display excludenl contained '[$]'

"" ATT: must be after nouArtifactKey for correct 'nouNumberXaddr' hi!
"" BAD:(syntax/nou/*): will load all files inside by vim itself
runtime autoload/nou/syntax/number.vim
runtime autoload/nou/syntax/path.vim
call nou#syntax#regex()  " ATT: must be after nouPath to override rgx=/.../
runtime autoload/nou/syntax/keyval.vim
runtime autoload/nou/syntax/group.vim
runtime autoload/nou/syntax/datetime.vim


"" ATT: must be after nouNumber to override date
" DISABLED: too bright checkbox is distracting
" hi! nouTaskTodo ctermfg=15 guifg=#beeeee
hi! nouTaskTodo ctermfg=14 guifg=#586e75
syn cluster nouTaskQ add=nouTaskTodo
syn match nouTaskTodo display excludenl '\V[_]'

" MAYBE:ADD: inprogress/ongoing "[o]"

hi! nouTaskWait cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=169 guifg=#ef3f9f
syn cluster nouTaskQ add=nouTaskWait
syn match nouTaskWait display excludenl '\V[…]'

hi! nouTaskDone ctermfg=14 guifg=#586e75
syn cluster nouTaskQ add=nouTaskDone
syn match nouTaskDone display excludenl '\V[X]'
syn match nouTaskDone display excludenl '\v\[[\u2800-\u28FF]{2}\]'  " day
syn match nouTaskDone display excludenl '\v\[[\u2800-\u28FF]{4}\]'  " ts

"" MAYBE:
" gui=reverse,bold
" hi! nouTaskDoneB ctermfg=14 guifg=#586e75
" syn match nouTaskDoneB display excludenl contained
"   \ containedin=nouTaskDone '[[\]]'


""" ALT: separate xts group
" " hi! nouTaskXts cterm=bold gui=bold ctermfg=14 guifg=#586e75
" hi! nouTaskXts ctermfg=14 guifg=#586e75
" syn cluster nouTaskQ add=nouTaskXts
" syn match nouTaskXts display excludenl '\v\[[\u2800-\u28FF]{4}\]'

hi! nouTaskFrame cterm=bold gui=bold ctermfg=14 guifg=#586e75
syn cluster nouTaskQ add=nouTaskFrame
syn match nouTaskFrame display excludenl '\[[∞◦‣%#￪￬⟫]\]'

hi! nouTaskFeed cterm=bold gui=bold ctermfg=251 guifg=#c6c6c6
syn match nouTaskFeed display excludenl contained containedin=nouTaskFrame '[∞◦‣]'

hi! nouTaskPartial cterm=bold gui=bold ctermfg=32 guifg=#0087df
syn match nouTaskPartial display excludenl contained containedin=nouTaskFrame '%'

" RENAME? nouTaskAmend
hi! nouTaskRephrase cterm=bold gui=bold ctermfg=148 guifg=#afdf00
syn match nouTaskRephrase display excludenl contained containedin=nouTaskFrame '#'

hi! nouTaskDelegated ctermfg=169 guifg=#ef3f9f
syn match nouTaskDelegated display excludenl contained containedin=nouTaskFrame '⟫'

" cterm=bold gui=bold
hi! nouTaskBringFwd ctermfg=46 guifg=#00ff00
syn match nouTaskBringFwd display excludenl contained containedin=nouTaskFrame '￪'

hi! nouTaskPushBwd ctermfg=196 guifg=#ff0000
syn match nouTaskPushBwd display excludenl contained containedin=nouTaskFrame '￬'


hi! nouTaskNow cterm=bold gui=bold ctermfg=251 guifg=#c6c6c6
syn cluster nouTaskQ add=nouTaskNow
syn match nouTaskNow display excludenl '\V[•]'

hi! nouTaskMandatory cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=196 guifg=#ff0000
syn cluster nouTaskQ add=nouTaskMandatory
syn match nouTaskMandatory display excludenl '\V[!]'

hi! nouTaskToday cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=172 guifg=#df8700
syn cluster nouTaskQ add=nouTaskToday
syn match nouTaskToday display excludenl '\V[@]'

hi! nouTaskCancel ctermfg=88 guifg=#870000
syn cluster nouTaskQ add=nouTaskCancel
syn match nouTaskCancel display excludenl '\V[$]'

hi! nouTaskAlso ctermfg=22 guifg=#1f881f
syn cluster nouTaskQ add=nouTaskAlso
syn match nouTaskAlso display excludenl '\V[+]'

hi! nouTaskPostpone ctermfg=62 guifg=#5f5fdf
syn cluster nouTaskQ add=nouTaskPostpone
syn match nouTaskPostpone display excludenl '\V[>]'

hi! nouTaskDoneBefore ctermfg=94 guifg=#875f00
syn cluster nouTaskQ add=nouTaskDoneBefore
syn match nouTaskDoneBefore display excludenl '\V[<]'
syn match nouTaskDoneBefore display excludenl '\v\[⪡[\u2800-\u28FF]{2,4}\]'

" [_] FIXME: instead of "cluster" use nested items and universal "\V[\.]" task
hi! nouTaskLikely ctermfg=169 guifg=#ef3f9f
syn cluster nouTaskQ add=nouTaskLikely
syn match nouTaskLikely display excludenl '\V[~]'

hi! nouTaskUnlikely ctermfg=172 guifg=#df8700
syn cluster nouTaskQ add=nouTaskUnlikely
syn match nouTaskUnlikely display excludenl '\V[?]'


" HACK: different yellowish/rainbow color for incomplete tasks /[01-99%]/
for i in keys(g:nou.task.colors)
  exe 'hi! nouTaskProgress'.i .' '. g:nou.task.colors[i]
  exe 'syn cluster nouTaskQ add=nouTaskProgress'.i
  exe 'syn match nouTaskProgress'.i.' display excludenl contains=nouProgressTotal "\v\['.i.'\d%(\.\d+)?\%%(\ze/\d+)?\]"'
endfor

hi def link nouTaskProgressDone nouTaskDone
syn cluster nouTaskQ add=nouTaskProgressDone
syn match nouTaskProgressDone display excludenl contains=nouProgressTotal "\v\[XX\%%(\ze/\d+)?\]"

" IDEA: use Total suffix for all tasks to specify allocated/spent/expected resources
"   e.g. [⡟⣌⢅⠰/214] [X/214] [+/2h/214] [_/4h] [$/2h]
hi! nouProgressTotal ctermfg=14 guifg=#586e75
syn match nouProgressTotal display excludenl contained '/\d\+'

syn cluster nouGenericQ add=nouTask
hi! nouTask ctermfg=14 guifg=#586e75
syn match nouTask display excludenl contains=@nouTaskQ
  \ '\v%(\d{4}-\d\d-\d\d )?\[%([_$X]|[\u2800-\u28FF]{4}|\d\d%(\.\d+)?\%%(/\d+)?)\]'


"{{{ NOTE: progress highlight e.g. "[1/8]"
" TRY:DEV: convert ratio to percent and highlight the same as above 5..95%
"   FAIL:NEED conditional hi! (?Idris dependent types?)
" MAYBE:BET: add "progress" cluster globally insted of limiting into nouTaskQ
syn cluster nouTaskQ add=nouProgressRatio
exe 'hi! nouProgressRatio '. g:nou.task.colors[8]
syn match nouProgressRatio display excludenl contains=@nouProgressRatioQ '\v\[%(\d+[/+\\])?\d+%(\.\d+)?[/⁄]\d+\]'

"" WARN: must be above "nouProgressRatioF" for [1/1] to highlight as "finished"
exe 'hi! nouProgressRatio1 '. g:nou.task.colors[1]
syn cluster nouProgressRatioQ add=nouProgressRatio1
syn match nouProgressRatio1 display excludenl contained '\D1\D\d\+\D'

hi! nouProgressRatioF ctermfg=14 guifg=#586e75
syn cluster nouProgressRatioQ add=nouProgressRatioF
syn match nouProgressRatioF display excludenl contained '\v\D(\d+%(\.\d+)?)[/⁄]\1\D'

exe 'hi! nouProgressRatio0 '. g:nou.task.colors[7]
syn cluster nouProgressRatioQ add=nouProgressRatio0
syn match nouProgressRatio0 display excludenl contained '\D0\+\D\d\+\D'
"}}}

"{{{ NOTE: spent time progress e.g. "[1h30m/4h|6h]" OR "[-/-]"
" [_] ENH: make it more arbitrary i.e. support anything in shape of delimiters "[…/…|…]"
syn cluster nouTaskQ add=nouProgressTime
exe 'hi! nouProgressTime '. g:nou.task.colors[8]
syn match nouProgressTime display excludenl contains=@nouProgressTimeQ,nouTimeSpan,nouTableDelim
  \ '\v\[%(-|<%(\d+[wdhms]){1,2}%(\+%(\d+[wdhms]){1,2})*>)[/⁄]%(-|<%(\d+[wdhms]){1,2}%(\|%(\d+[wdhms]){1,2})?>)\]'

hi! nouProgressTimePart ctermfg=14 guifg=#586e75
syn cluster nouProgressTimeQ add=nouProgressTimePart
syn match nouProgressTimePart display excludenl contained contains=nouTimeSpan,nouTableDelim
  \ '\v\D%(\w+\+)?(<%(\d+[wdhms]){1,2}>)[/⁄]\1%(\|%(\d+[wdhms]){1,2})?\D'

exe 'hi! nouProgressTimePlan '. g:nou.task.colors[7]
syn cluster nouProgressTimeQ add=nouProgressTimePlan
syn match nouProgressTimePlan display excludenl contained contains=nouTimeSpan,nouTableDelim
  \ '\v\D-\D<%(\d+[wdhms]){1,2}>\D'

exe 'hi! nouProgressTimeLog '. g:nou.task.colors[1]
syn cluster nouProgressTimeQ add=nouProgressTimeLog
syn match nouProgressTimeLog display excludenl contained contains=nouTimeSpan
  \ '\v\D<%(\d+[wdhms]){1,2}>\D-\D'

" OR: [9]
exe 'hi! nouProgressTimeTodo '. g:nou.task.colors[0]
syn cluster nouProgressTimeQ add=nouProgressTimeTodo
syn match nouProgressTimeTodo display excludenl contained '\D-\D-\D'
"}}}


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

syn cluster nouTextQ add=@Spell,@nouGenericQ,@nouTaskQ
  \,@nouArtifactQ,@nouAccentQ,@nouTermQ,@nouEmbedQ

" WARNING: define after accents!
runtime autoload/nou/syntax/block.vim
runtime autoload/nou/syntax/xtref.vim

" EXPL: must be last line -- set single-loading guard only if no exceptions
let b:current_syntax = 'nou'
