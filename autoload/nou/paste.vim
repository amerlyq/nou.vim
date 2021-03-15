""" Clipboard and extsrc copy-pasting

fun! nou#paste#dedent(lines, ...)
  " NOTE: find common minimal indent length, ignoring empty/space-only lines
  " WARN: breaks with \t
  let len_indents = map(copy(a:lines), {i,x -> match(x,'\S')})
  let indentlen = min(filter(len_indents, 'v:key<0'))
  if a:0 == 0
    let Trfm = {i,x -> strpart(x, indentlen)}
  elseif a:1 == 0
    return a:lines
  elseif a:1 > 0
    " NOTE: keep block nesting structure when dedenting
    let skip = min([&tabstop * a:1, indentlen])
    let Trfm = {i,x -> strpart(x, skip)}
  elseif a:1 < 0
    " NOTE: destructuring dedent -- intently ignores "&expandtab" value
    let rgx_dedent = '\v^( {'.&tabstop.'}|\t){'.a:1.'}'
    let Trfm = {i,x -> substitute(x, rgx_dedent, '', '')}
  end
  return map(copy(a:lines), Trfm)
endf


fun! nou#paste#indent(lines, lvl)
  let tab = &expandtab ? repeat(' ', &tabstop) : "\t"
  let pfx = repeat(tab, a:lvl)
  return map(copy(a:lines), {i,x -> pfx . x})
endf


fun! nou#paste#reindent(lines, lvl)
  let lines0 = nou#paste#dedent(a:lines)
  return nou#paste#indent(lines0, a:lvl)
endf


fun! nou#paste#insert(lines, cmd)
  " ALT: exe 'put' . (a:cmd ==# 'P' ? '!' : '') . '=a:lines'
  if a:cmd ==# 'P'| put! = a:lines |else| put = a:lines |en

  "" HACK: don't touch system clipboard (@", @+, @*) when modifying text
  " call setreg('p', a:lines, 'V')
  " exe 'norm! 1"p'. a:cmd

  "" HACK: replace whole buffer
  " let cmd = '%delete_ | put = a:lst | 1delete _'
  " silent exec cmd
endf


fun! nou#paste#smart(reg, cmd, lvl1) range
  let reg = a:reg == '_' ? '"' : a:reg
  " [_] BUG: uses 'V' from <"p> when inserting short inline
  if getregtype(reg) !=# 'V'
    exe 'norm! "'. reg . a:cmd
    return
  end

  "" NOTE: use explicit level from <count> instead of contextual heuristics
  if a:lvl1 > 0
    let lines = nou#paste#reindent(getreg(reg,1,1), a:lvl1 - 1)
    return nou#paste#insert(lines, a:cmd)
  end

  "" NOTE: don't touch buffer if first line (OR:FIXME? any line) is indented
  " [_] TODO: if we paste item i.e. /[:punct:]\s/ is equal for curr and prev lines
  if getreg(reg) =~# '\v^%(\t|\s\s)'
    exe 'norm! "'. reg . a:cmd
    return
  end

  "" skip empty lines
  let i = line('.')
  let line = getline(i)
  while empty(line) && i > 0
    let i = i - 1
    let line = getline(i)
  endwhile
  let skipped = line('.') - i

  let pfx = substitute(line, '^\(\s*\).*', '\1', '')
  let body = strpart(line, strlen(pfx))

  "" NOTE: reduce indent
  "" ALT: use indent of above line
  " let pfx = substitute(getline(i - 1), '^\(\s*\).*', '\1', '')
  let off = &expandtab ? repeat(' ', &tabstop) : "\t"
  if body =~# '^https\?://'
    let pfx = substitute(pfx, off.'$', '', '')
  elseif body =~# '\V\^[_]' && getreg(reg) =~# '\V\^[_] '
    "" don't reindent tasks
  elseif !empty(body)  " increase indent
    let pfx = pfx . off
  else
    "" use current spaced line as indent
    " if !empty(pfx) | let pfx = pfx
  end

  "" HACK: skip multiple lines before pasting to deindent
  if skipped > 0
    let dedent = repeat(off, skipped)
    let pfx = strpart(pfx, 0, strlen(pfx) - strlen(dedent))
  end

  "" MAYBE: rasterize "\t" -> "  " on paste
  ""   << easier to write external plugins e.g. qute
  call setreg('p', map(getreg(reg,1,1), "pfx . v:val"))
  exe 'norm! "p'. a:cmd
endf
