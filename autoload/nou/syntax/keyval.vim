""" Key-value

" TODO: split into multiple separate matches with same name
hi! nouArtifactKey cterm=bold ctermfg=167 gui=bold guifg=#df5f5f
syn cluster nouArtifactQ add=nouArtifactKey
syn match nouArtifactKey display excludenl
  \ '\v%(^|[^[:lower:][:upper:][:digit:]]@1<=\s\zs)[^#[:blank:]]\S*[^:)[:blank:]]:%(:\s*$|\ze\s)'
  " \ '\v%(^|[^[:lower:][:upper:][:digit:]]@1<=\s\zs)[^#[:blank:]]\S*[^:[:blank:]]:%(:\s*$|\ze\s+\S)'
  " \ '\v%(^|[^[:lower:][:upper:][:digit:]]@1<=\s\zs|\s:)\S*[^:[:blank:]]:%(:\s*$|\ze\s*%($|\s\S))'
  " \ '\v^%(\A{-}\s@1<=)?\zs\S+%(::?\s*$|:\ze\s)'
  " \ '\v^%(\A{-}\s@1<=)?\zs\k+:%(\ze\s|$)'

"" BET: register s:nou.term.colors[:] instead of extending this match
" syn match nouArtifactKey display excludenl '\v%(^|\s):\S*[^:[:blank:]]:%(\s|$)'


" FAIL: :e to reload "nou-keyval.txt" with ft=nou looses some of highlight
syn cluster nouArtifactQ add=@nouKeyvalQ
syn cluster nouKeyvalQ add=nouKeyval,nouKeyvalQuoted
  \,nouKeyvalGroup1,nouKeyvalGroup2,nouKeyvalGroup3,nouKeyvalGroup4

" FIXME: using @nouPathQ prevents path highlight directly after /'"/
"   ALT:FAIL: using @nouPathUnixQ will always interpret content as path
"   ALT:BUG: using nouPathHead highlighs "b/path/to" from the middle
syn cluster nouKeyvalValueQ add=nouPathHead,nouPathRegion,@nouGroupQ
  \,nouArtifactVar,nouArtifactFunction

" MAYBE: allow path inside term "double quotes" -- to colorize :: key="/path/to"
"   FAIL: leading '"' prevents path prefix detection (expects empty or comma)
"     ~~ same problem with unquoted :: key=/path/to
"     BET:IDEA: use chained "nextgroup" and simplified "contained" @nouPathUnixQ
"   FAIL: trailing '"' is highlighted as part of path itself instead of quote
"
" MAYBE: use nextgroup=nouAccent with contained path
"   CRIT! free quoted text will always be highlighted as path
"     BET: use specialized syntaxes for key="/word" and key='$(var)/word'

" TRY: rainbow hi! for train of assignments e.g. r0=r6[0]=m_val
"   NICE: use different colors for each "key="-like member
"   TEMP: only highlight "=" like "key="
hi def link nouKeyvalXtrain nouKeyvalXkey
syn match nouKeyvalXtrain display excludenl contained '='


hi nouKeyvalXkey cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=33 guifg=#2060e0
hi nouKeyval     cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=10 guifg=#688e95

syn region nouKeyval display oneline keepend excludenl
  \ matchgroup=nouKeyvalXkey
  \ contains=@nouKeyvalValueQ,nouKeyvalXtrain
  \ start='\v%(^|[[:punct:][:blank:]]@1<=)\k+[=]'
  \ end='\ze,\s'
  \ end='\ze,$'
  \ end='\ze[[:blank:]]'
  \ end='$'

" BAD:(extend): contained nouPath extends till end of line
syn region nouKeyvalQuoted display oneline keepend excludenl
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\v%(^|[[:punct:][:blank:]]@1<=)\k+[=]\z(["'."'".'])'
  \ skip='\\\z1' end='\z1'

" NOTE: groups for symmetrical /([{</ braces to support embedded spaces/lists
"   ALSO: additionally allow quoted accents as list args
" ALT:TRY: highlight whole region from key= till end, then use nextgroup=...
"   NICE: reuse quoted args between multiple syntax expressions
"   BAD:PERF: each quotes require different end=/.../
" ALT:BAD:(spaces not supported): :syn cluster nouKeyvalValueQ add=@nouGroupQ

syn region nouKeyvalGroup1 display oneline keepend excludenl
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\v%(^|[[:punct:][:blank:]]@1<=)\k+[=][(]'
  \ skip='\\)' end=')'

syn region nouKeyvalGroup2 display oneline keepend excludenl
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\v%(^|[[:punct:][:blank:]]@1<=)\k+[=][[]'
  \ skip='\\\]' end='\]'

syn region nouKeyvalGroup3 display oneline keepend excludenl
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\v%(^|[[:punct:][:blank:]]@1<=)\k+[=][{]'
  \ skip='\\}' end='}'

syn region nouKeyvalGroup4 display oneline keepend excludenl
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\v%(^|[[:punct:][:blank:]]@1<=)\k+[=][<]'
  \ skip='\\>' end='>'
