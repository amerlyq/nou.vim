""" Key-value

syn cluster nouArtifactQ add=@nouKeyvalQ
syn cluster nouKeyvalQ add=nouKeyval,nouKeyvalQuoted
  \,nouKeyvalGroup1,nouKeyvalGroup2,nouKeyvalGroup3,nouKeyvalGroup4

" FIXME: using @nouPathQ prevents path highlight directly after /'"/
"   ALT:FAIL: using @nouPathUnixQ will always interpret content as path
"   ALT:BUG: using nouPathHead highlighs "b/path/to" from the middle
syn cluster nouKeyvalValueQ add=nouPathHead,nouPathRegion,nouArtifactVar,@nouGroupQ

" MAYBE: allow path inside term "double quotes" -- to colorize :: key="/path/to"
"   FAIL: leading '"' prevents path prefix detection (expects empty or comma)
"     ~~ same problem with unquoted :: key=/path/to
"     BET:IDEA: use chained "nextgroup" and simplified "contained" @nouPathUnixQ
"   FAIL: trailing '"' is highlighted as part of path itself instead of quote
"
" MAYBE: use nextgroup=nouAccent with contained path
"   CRIT! free quoted text will always be highlighted as path
"     BET: use specialized syntaxes for key="/word" and key='$(var)/word'

hi nouKeyvalXkey cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=33 guifg=#2060e0
hi nouKeyval     cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=10 guifg=#688e95

syn region nouKeyval display oneline keepend excludenl
  \ matchgroup=nouKeyvalXkey
  \ contains=@nouKeyvalValueQ
  \ start='\%(^\|[[:punct:][:blank:]]\@1<=\)\k\+[=]'
  \ end='\ze,\s'
  \ end='\ze,$'
  \ end='\ze[[:blank:]]'
  \ end='$'

" BAD:(extend): contained nouPath extends till end of line
syn region nouKeyvalQuoted display oneline keepend excludenl
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\%(^\|[[:punct:][:blank:]]\@1<=\)\k\+[=]\z\(["'."'".']\)'
  \ skip='\\\z1' end='\z1'

" NOTE: groups for symmetrical /([{</ braces to support embedded spaces/lists
"   ALSO: additionally allow quoted accents as list args
" ALT:TRY: highlight whole region from key= till end, then use nextgroup=...
"   NICE: reuse quoted args between multiple syntax expressions
"   BAD:PERF: each quotes require different end=/.../
" ALT:BAD:(spaces not supported): :syn cluster nouKeyvalValueQ add=@nouGroupQ

syn region nouKeyvalGroup1 display oneline keepend excludenl contained
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\%(^\|[[:punct:][:blank:]]\@1<=\)\k\+[=]('
  \ skip='\\)' end=')'

syn region nouKeyvalGroup2 display oneline keepend excludenl contained
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\%(^\|[[:punct:][:blank:]]\@1<=\)\k\+[=]\['
  \ skip='\\\]' end='\]'

syn region nouKeyvalGroup3 display oneline keepend excludenl contained
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\%(^\|[[:punct:][:blank:]]\@1<=\)\k\+[=]{'
  \ skip='\\}' end='}'

syn region nouKeyvalGroup4 display oneline keepend excludenl contained
  \ matchgroup=nouKeyvalXkey contains=@nouKeyvalValueQ
  \ start='\%(^\|[[:punct:][:blank:]]\@1<=\)\k\+[=]<'
  \ skip='\\>' end='>'
