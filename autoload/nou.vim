
fun! nou#bar(...)
  if a:0<1 || type(a:1) != type('')| throw "wrong a:1" |en
  let pfx = empty(a:1) ? '' : '['.a:1.'] '
  if a:1 ==# 'X'| let pfx = strftime("%Y-%m-%d").' '.pfx |en
  let line = getline('.')
  let chgd = substitute(line,
    \ '\v^(\s*)%(%(\d{4}-\d\d-\d\d )?\[[_$x]\]\s*)?(.*)$',
    \ '\1'.pfx.'\2', '')
  if chgd !=# line| call setline('.', chgd) |en
endf
