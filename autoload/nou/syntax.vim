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

fun! nou#syntax#_highlight(nm, c)
  if a:c =~ '^#\x\+$'| let c = 'guifg='.a:c |else| let c = a:c |en
  exe 'hi! '. a:nm .' '. c
endf

fun! nou#syntax#outline(i)
  let nm = 'nouOutline'.a:i
  exe 'syn region '.nm.' display oneline keepend'
    \.' start='.s:p(nou#syntax#_indent(a:i))
    \.' excludenl end='.s:p('$')
  call nou#syntax#_highlight(nm, g:nou.outline.colors[a:i])
endf

fun! nou#syntax#delimit(i)
  let nm = 'nouDelimit'.a:i
  let [s, c] = g:nou.delimit.colors[a:i]
  exe 'syn match '.nm.' display excludenl '
    \.s:p('\v(^|\s)\zs['.s.']{5,}\ze(\s|$)')
  " ALT:(pseudo-random) color =~ charcode % 16
  call nou#syntax#_highlight(nm, c)
endf
