""" Paths

" FIXME: treat ' // ' as C-comment instead of path

syn cluster nouArtifactQ add=@nouPathQ
syn cluster nouPathQ add=nouPathEscaped,nouPathRegion,nouPathWindows
syn cluster nouPathUnixQ add=nouPathHead,nouPathBody,nouPathTail,nouPathText
syn cluster nouPathXQ contains=nouPathXdelim,nouPathTail,nouPathText,nouPathXspace
  \,nouPathXsh,nouPathXmkV,nouPathXmkF,nouPathXalt


" BUG: totally wrong terminal colors
hi def link nouPathHead  nouPathXdelim
hi nouPathBody   cterm=italic ctermbg=9 gui=italic guibg=#073642 ctermfg=79  guifg=#5fd7af
hi nouPathXdelim cterm=italic ctermbg=9 gui=italic guibg=#073642 ctermfg=34  guifg=#00af00
hi nouPathXspace cterm=italic ctermbg=9 gui=italic guibg=#073642 ctermfg=224 guifg=#dc322f
hi nouPathXsh    cterm=italic ctermbg=9 gui=italic guibg=#073642 ctermfg=81  guifg=#df5f00
hi nouPathXalt   cterm=italic ctermbg=9 gui=italic guibg=#073642 ctermfg=81  guifg=#cb4b16
hi nouPathXmkV   cterm=italic ctermbg=9 gui=italic guibg=#073642 ctermfg=81  guifg=#df5f00
hi nouPathXmkF   cterm=italic ctermbg=9 gui=italic guibg=#073642 ctermfg=10  guifg=#688e95
hi nouPathXmk    cterm=italic ctermbg=9 gui=italic guibg=#073642 ctermfg=33  guifg=#3087ff
hi nouPathTail   cterm=italic ctermbg=9 gui=italic guibg=#073642 ctermfg=10  guifg=#586e75
hi def link nouPathText  nouPathTail


"" Path elements
syn match nouPathXdelim display excludenl contained '[/\\*?]'
syn match nouPathXspace display excludenl contained '\\[[:blank:]]'
syn match nouPathXsh    display excludenl contained '\V$\w\+\|${[^}]\+}'
" MAYBE:FIXME: only allow comma inside {...} as nested syntax region (contains=nouPath)
syn match nouPathXalt   display excludenl contained '[<{,|}>]'


"" Make functions
" ALT: use "keepend" in outer + "extend" in inner
syn region nouPathXmkV display oneline excludenl contained
  \ start='\V$(\ze\w\+)' end=')'

" ALT: hi blue+green+white
syn region nouPathXmkF display oneline excludenl contained
  \ contains=nouPathXmkF,nouPathXmkV matchgroup=nouPathXmk
  \ start='\V$(\ze\w\+\s' skip='\\)' end=')'


"" Aggregation
" NICE: full contained pattern can be reused in doublequote/other "nextgroup"

" WARN:PERF: don't use ".*" as it matches in each position
" TRY: nextgroup=nouPathTail BAD: can't easily match non-gready body
syn match nouPathBody display excludenl contained nextgroup=nouPathTail,nouPathText
  \ contains=@nouPathXQ '.\+'

syn region nouPathTail display oneline excludenl contained
  \ matchgroup=nouPathHead
  \ start='\v:\ze%(\s|$)'
  \ start='\v:\ze\d+%(:\d+)?'
  \ start='\v:[/?*%^=]\ze'
  \ skip='\\/'
  \ end='/'
  \ end='$'

syn region nouPathText display oneline excludenl contained extend
  \ matchgroup=nouPathHead
  \ start='::\ze'
  \ end='$'


" NOTE: highlight all prefixes inside nouPathEscaped and nouPathRegion
" ATT: must be after nouPathBody to override it
"   FIXED:BUG(:/doc/nou): prefix being highlighted as nouPathTail
syn match nouPathHead display excludenl contained nextgroup=nouPathBody
  \ '\v%(^|\k@1<!)%(/[^0-9]@!|[~@:%.&/…☤♆☆★]/|\.\./|[[:alpha:]]:[\\]{1,2})'


" ALT(old):BAD: too complex and fragile incomprehensible regex
" exe 'syn match '.nm.' display excludenl contains=@'.nm.'Q '
"   \.s:p('\v%(^|[,({\[[:blank:]]@1<=)%('
"   \.pfx.'%([^/]|$)|/[^/[:blank:]])'
"   \.'%(%(\\[[:blank:]]|[^[:blank:]⋮]){-}\ze[\\]@<![[:blank:]][^⋮]+$|.{-}%(⋮|$))')


"" Detection
" FIXED(\%(^\|[,({\[[:blank:]]\@1<=\)): prevent hi starting from the middle of any alt-word with slashes
"   ONELINE: '\v%(^|[,({\[[:blank:]]@1<=)%(%([~@:%.&]|\.\.|…)/\ze%([^/]|$)|/\ze[^/[:blank:]])'

syn region nouPathEscaped display oneline keepend excludenl transparent
  \ contains=@nouPathUnixQ
  \ start='\%(^\|[,({\[[:blank:]]\@1<=\)\ze/[^/[:blank:]0-9]'
  \ start='\%(^\|[,({\[[:blank:]]\@1<=\)\ze//[^/[:blank:]]'
  \ start='\%(^\|[,({\[[:blank:]]\@1<=\)\ze[~@:%.&…☤♆☆★]/'
  \ start='\%(^\|[,({\[[:blank:]]\@1<=\)\ze\.\./'
  \ start='\%(^\|[,({\[[:blank:]]\@1<=\)\ze\$\w\+/'
  \ start='\%(^\|[,({\[[:blank:]]\@1<=\)\ze\${[^}]\+}/'
  \ start='\%(^\|[,({\[[:blank:]]\@1<=\)\ze\$(\w\+)/'
  \ skip='\\[[:blank:]]'
  \ end='\ze,\s'
  \ end='\ze,$'
  \ end='\ze[[:blank:]]'
  \ end='$'

syn region nouPathWindows display oneline keepend excludenl transparent
  \ contains=@nouPathUnixQ
  \ start='\%(^\|[[:punct:][:blank:]]\@1<=\)\ze[[:alpha:]]:\\\\\?'
  \ skip='\\[[:blank:]]'
  \ end='\ze,\s'
  \ end='\ze,$'
  \ end='\ze[[:blank:]]'
  \ end='$'

" NICE: can extend this idea to all other artifacts to include spaces
"   e.g. surround ⋮./pa th/to sm⋮ and treat whole content as path
" NOTE:(concealends): irritating when navigating, ALSO:BAD:PERF
"   ALT: use only trailing symbol to end everything "⋮" FAIL:PERF: hard to detect
syn region nouPathRegion display oneline keepend excludenl transparent
  \ contains=@nouPathUnixQ
  \ matchgroup=nouConceal
  \ start='⋮'
  \ skip='\\⋮'
  \ end='⋮'
  \ end='$'
