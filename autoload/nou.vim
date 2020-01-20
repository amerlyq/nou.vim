fun! nou#vsel()
  let [lbeg, cbeg] = getpos("'<")[1:2]
  let [lend, cend] = getpos("'>")[1:2]
  let lines = getline(lbeg, lend)
  if len(lines) == 0
      return ''
  endif
  let lines[-1] = lines[-1][: cend - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][cbeg - 1:]
  return join(lines, "\n")
endf


fun! nou#bar(...) range
  if a:0<1 || type(a:1) != type('')| throw "wrong a:1" |en
  let pfx = substitute(a:1, '[_$X]', '[&] ', '')
  let pfx = substitute(pfx, 'D', strftime("%Y-%m-%d").' ', '')

  " BUG: in VSEL mode wrong cursor pos: '.' == '<
  let l:pos = exists('*getcurpos') ? getcurpos() : getpos('.')
  " echom string(l:pos)

  let rgn = [line('.')]
  if get(a:,3)| let rgn = range(getpos("'<")[1], getpos("'>")[1]) |en

  for i in rgn
    let line = getline(i)
    " FIXME: impossible decions ~ '=[', '<[', '-]'
    "   => extract first word from $line and directly compare in vimscript
    let chgd = substitute(line,
      \ '\v^(\s*%([^[:alpha:][:blank:][\]]{-1,3}\s+)?)'
      \.'%(%(\d{4}-\d\d-\d\d )?\[[_$X]\]\s*)?(.*)$',
      \ '\1'.pfx.'\2', '')
    if chgd !=# line| call setline(i, chgd) |en
  endfor

  call setpos('.', l:pos)
endf


fun! nou#path_open(path)
  let p = a:path

  let idx = stridx(p, '/')
  if idx < 0| let idx = 0 |en
  let pfx = strpart(p, 0, idx)
  let p = strpart(p, idx)

  if pfx ==# '' || pfx ==# '.' || pfx ==# '..' | let p = pfx . p
  elseif pfx ==# '~' | let p = $HOME . p
  elseif pfx ==# '@' | let p = $HOME .'/aura'. p  " BAD: I have nested repo
  elseif pfx ==# '%' | let p = expand('%:h') . p  " CHECK: different $PWD
  elseif pfx ==# ':'
    " ALT: see "\cd" cmd impl
    let d = fnameescape(expand('%:h'))
    let g = systemlist('git -C '.d.' rev-parse --show-toplevel')
    let p = g[0] . p
  elseif pfx ==# '…'
    let p = strpart(p, 1)
    " NOTE: search in all 'path' like usual 'gf' do
    exe 'find' fnameescape(p)
    return
  else
    norm! gf
    return
  en
  exe 'edit' fnameescape(p)
endf
