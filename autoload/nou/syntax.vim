""" Syntax helpers
" TODO:MOVE: all regexes in registry hive

fun! s:p(p)
  return '/'.escape(a:p,'/').'/'
endf

fun! nou#syntax#_indent(i)
  " CHECK: if &ts used from current buffer or from script file
  let ind = '%(\t| {'.&ts.'}'.(g:nou.widesp ? "|\u3000" : '').')'
  let p = '\v^'
  if g:nou.deflvl > 0| let p .= '%('.ind.'{'.g:nou.deflvl.'})' |en
  if g:nou.cyclic > 0| let p .= '%('.ind.'{'.len(g:nou.outline.colors).'}){-}' |en
  let p .= '%('.ind .'{'. a:i .'})' . '\ze\S'
  return p
endf

fun! nou#syntax#_highlight(nm, c, ...)
  if a:c =~ '^#\x\+$'| let c = 'guifg='.a:c |else| let c = a:c |en
  " TODO: if =~ '\w\+' -> hi def link
  " CHECK: if used 'def link' -- can't change colors on fly w/o vim restart
  " BAD: don't work user override like with 'def link'
  exe 'hi! '. a:nm .' '. c .(a:0<1?'': ' '.a:1)
endf

fun! nou#syntax#outline(i)
  let nm = 'nouOutline'.a:i
  " THINK: don't use 'keepend/excludenl/oneline' to allow wrap multiline 'url'
  "   -- BUG: irritating EOF highlighting when typing opening accent
  " ENH:USE: ALL ALLBUT,{gr} TOP TOP,{gr} CONTAINED CONTAINED,{gr}
  exe 'syn cluster nouOutlineQ add='.nm
  exe 'syn region '.nm.' display oneline keepend excludenl'
    \.' contains=@nouTextQ,@nouDelimQ,@nouDecisionQ'
    \.' start='.s:p(nou#syntax#_indent(a:i))
    \.' end='.s:p('$')
  call nou#syntax#_highlight(nm, g:nou.outline.colors[a:i])
endf

fun! nou#syntax#decision(i)
  let nm = 'nouDecision'.a:i
  let [s, c] = g:nou.decision.colors[a:i]
  exe 'syn cluster nouDecisionQ add='.nm.'m,'.nm.'u'
  exe 'syn region '.nm.'m display oneline keepend transparent'
    \.' excludenl matchgroup='.nm
    \.' start='.s:p('\v^\s*\zs\z('.s.')%(\d+)?\s')
    \.' end='.s:p('\s\z1$').' end='.s:p('$')
  exe 'syn region '.nm.'u display oneline keepend'
    \.' excludenl matchgroup='.nm
    \.' contains=@nouTextQ'
    \.' start='.s:p('\v^\s*\zs\z('.s.')%(\d+)?'.g:nou.decision.symbol.'\s')
    \.' end='.s:p('\s\z1$').' end='.s:p('$')
  call nou#syntax#_highlight(nm, c, 'gui=bold')
  call nou#syntax#_highlight(nm.'u', c, 'gui=bold,italic')
endf

fun! nou#syntax#accent(k)
  let nm = 'nouAccent'.a:k
  let [s, c] = g:nou.accent.colors[a:k]
  exe 'syn cluster nouAccentQ add='.nm
  exe 'syn region '.nm.' display oneline keepend concealends'
    \.' excludenl matchgroup=nouConceal contains=@nouAccentQ'
    \.' start='.s:p('\%(^\|\W\)\zs'.s.'\ze\S')
    \.' end='.s:p('\S\zs'.s.'\ze\%(\W\|$\)')
  if c !~# '='| let c = 'cterm='.c.' gui='.c |en
  call nou#syntax#_highlight(nm, '', c)
endf

fun! nou#syntax#header(i)
  let nm = 'nouHeader'.a:i
  let c = g:nou.header.colors[a:i]
  let s = repeat(g:nou.header.symbol,
    \ g:nou.header.ascending ? a:i + 1 : len(g:nou.header.colors) - a:i)
  exe 'syn cluster nouHeaderQ add='.nm.'r'
  " NOTE: if used '\zs' in '^\s*\zs\z(' -- will be rematched to outline
  exe 'syn region '.nm.' display oneline keepend excludenl'
    \.' matchgroup=nouComment contains=NONE'
    \.' start='.s:p('\v^\s*\z('.s.')\s')
    \.' end='.s:p('\s\z1$').' end='.s:p('$')
  call nou#syntax#_highlight(nm, c, 'gui=bold,inverse')
endf

fun! nou#syntax#delimit(i)
  let nm = 'nouDelimit'.a:i
  let [s, c] = g:nou.delimit.colors[a:i]
  exe 'syn cluster nouDelimQ add='.nm
  exe 'syn match '.nm.' display excludenl contains=NONE '
    \.s:p('\v(^|\s)\zs['.s.']{5,}\ze(\s|$)')
  " ALT:(pseudo-random) color =~ charcode % 16
  call nou#syntax#_highlight(nm, c)
endf

fun! nou#syntax#embed_load(ft)
  let nm = 'nouEmbedQ_'.a:ft
  let main_syntax = get(b:, 'current_syntax', '')
  " EXPL: remove all previously embedded syntax groups (sole method)
  " syntax clear | let &syntax = main_syntax
  if a:ft ==# ''| return |en
  " EXPL: load even syntax files with single-time loading guards
  if exists('b:current_syntax')| unlet b:current_syntax |en
  " BUG: embedded syntax expects start-of-line '^' -- but there placed '\d:\d:'
  try|exe 'syn include @'.nm.' syntax/'.a:ft.'.vim'      |catch/E403\|E484/|endtry
  try|exe 'syn include @'.nm.' after/syntax/'.a:ft.'.vim'|catch/E403\|E484/|endtry
  let b:current_syntax = main_syntax
  if empty(b:current_syntax)| unlet b:current_syntax |en
endf

fun! nou#syntax#embedded(ft)
  let nm = 'nouEmbed_'.a:ft
  let [b, e] = g:nou.embed[a:ft]
  exe 'syn cluster nouEmbedQ add='.nm
  exe 'syn region '.nm.' display oneline keepend excludenl'
    \.' matchgroup=nouComment contains=@nouEmbedQ_'.a:ft
    \.' start='.s:p('\%(^\|\s\)\zs'.b.'\s')
    \.' end='.s:p('\s'.e.'\ze\%(\s\|$\)').' end='.s:p('$')
  call nou#syntax#embed_load(a:ft)
  " call nou#syntax#_highlight(nm, '#990000')
endf
