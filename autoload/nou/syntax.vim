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
  exe 'syn region '.nm.' display oneline keepend'
    \.' contains=Comment,@nouArtifactQ,@nouAccentQ,@nouDecisionQ'
    \.' start='.s:p(nou#syntax#_indent(a:i))
    \.' excludenl end='.s:p('$')
  call nou#syntax#_highlight(nm, g:nou.outline.colors[a:i])
endf

fun! nou#syntax#decision(i)
  let nm = 'nouDecision'.a:i
  let [s, c] = g:nou.decision.colors[a:i]
  exe 'syn cluster nouDecisionQ add='.nm.'r'
  exe 'syn region '.nm.'r display oneline keepend transparent'
    \.' excludenl matchgroup='.nm
    \.' start='.s:p('\v^\s*\zs\z(['.s.']{1,3})\s')
    \.' end='.s:p('\s\z1$').' end='.s:p('$')
  call nou#syntax#_highlight(nm, c, 'gui=bold')
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

fun! nou#syntax#delimit(i)
  let nm = 'nouDelimit'.a:i
  let [s, c] = g:nou.delimit.colors[a:i]
  exe 'syn match '.nm.' display excludenl '
    \.s:p('\v(^|\s)\zs['.s.']{5,}\ze(\s|$)')
  " ALT:(pseudo-random) color =~ charcode % 16
  call nou#syntax#_highlight(nm, c)
endf
