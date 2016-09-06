
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
    let chgd = substitute(line,
      \ '\v^(\s*%([^[:alpha:][:blank:]]{-1}\s+)?)'
      \.'%(%(\d{4}-\d\d-\d\d )?\[[_$x]\]\s*)?(.*)$',
      \ '\1'.pfx.'\2', '')
    if chgd !=# line| call setline(i, chgd) |en
  endfor

  call setpos('.', l:pos)
endf
