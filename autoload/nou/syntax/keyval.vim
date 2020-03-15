""" Key-value

syn cluster nouArtifactQ add=nouKeyval

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

syn region nouKeyval display oneline excludenl extend excludenl
  \ matchgroup=nouKeyvalXkey
  \ contains=nouKeyval
  \ start='\%(^\|[[:punct:][:blank:]]\@1<=\)\k\+[=]'
  \ end='\ze,\s'
  \ end='\ze,$'
  \ end='\ze[[:blank:]]'
  \ end='$'
