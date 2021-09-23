""" Clipboard and extsrc copy-pasting

" [_] FAIL: didn't deindent copied blocks on explicit level past
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


""" [⡠⡖⠦⡓] BUG: paste from wrong register
"   ALT:BUG: uses 'V' from <"p> when inserting short inline
"   REQ v:register incorrectly persists into the next command · Issue #11202 · neovim/neovim ⌇⡠⡖⠋⢠
"     https://github.com/neovim/neovim/issues/11202
"     ::: FIXED: nvim>=0.5
"   Vim - General - clipboard=unnamedplus, v:register and yanks ⌇⡠⡖⠍⡤
"     http://vim.1045645.n5.nabble.com/clipboard-unnamedplus-v-register-and-yanks-td4822337.html
"   neovim - Clipboard is reset after first paste in Visual Mode - Vi and Vim Stack Exchange ⌇⡠⡖⠍⣄
"     https://vi.stackexchange.com/questions/25259/clipboard-is-reset-after-first-paste-in-visual-mode
"   CASE: :nnoremap <buffer><silent> p  :<C-u>call setreg('p', map(getreg(v:register,1,1), "'  '. v:val"), 'V') \| exe 'norm! "pp'<CR>
fun! nou#paste#insert(lines, cmd, ...)
  "" MAYBE: rasterize "\t" -> "  " on paste
  ""   << easier to write external plugins e.g. qute

  "" HACK: don't touch system clipboard (@", @+, @*) when modifying text
  let rtp = get(a:,1,'V')
  let reg = get(a:,2,'p')
  let cnt = get(a:,3,'1')
  call setreg(reg, a:lines, rtp)
  exe 'norm! '. cnt .'"'. reg . a:cmd

  "" ALT: exe 'put' . (a:cmd ==# 'P' ? '!' : '') . '=a:lines'
  " OR: if a:cmd ==# 'P'| put! = a:lines |else| put = a:lines |en
  "" HACK: replace whole buffer
  " let cmd = '%delete_ | put = a:lst | 1delete _'
  " silent exec cmd
  return a:lines
endf


fun! nou#paste#keep_unchanged(lines, type)
  "" NOTE: don't touch buffer if first line (OR:FIXME? any line) is indented
  " [_] TODO: if we paste item i.e. /[:punct:]\s/ is equal for curr and prev lines
  return a:type !=# 'V' || a:lines[0] =~# '\v^%(\t|\s\s)'
endf


fun! nou#paste#ctx_guess_indent(lines)
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
  elseif body =~# '\V\^[\.]' && a:lines[0] =~# '\V\^[\.] '
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

  return pfx
endf


" [_] ALSO:IDEA: when pasting into some code (instead of .nou) -- prepend &comment to each line
fun! nou#paste#smart(reg, cmd, lvl1) range
  " ALT:WKRND:(nvim<0.5.0): let reg = a:reg == '_' ? '"' : a:reg
  let [Rlines, Rtype] = [getreg(a:reg,1,1), getregtype(a:reg)]

  "" NOTE: use explicit level from <count> instead of contextual heuristics
  if a:lvl1 > 0
    return nou#paste#insert(nou#paste#reindent(Rlines, a:lvl1 - 1), a:cmd)
  end

  if nou#paste#keep_unchanged(Rlines, Rtype)
    exe 'norm! "'. a:reg . a:cmd
    return
  end

  " [_] FIXME: use newer #reindent() function + guess indent int(lvl) instead of pfx
  let pfx = nou#paste#ctx_guess_indent(Rlines)
  return nou#paste#insert(map(Rlines, "pfx . v:val"), a:cmd, Rtype)
endf
