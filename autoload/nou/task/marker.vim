""" task-marker e.g. [_] [X] [⡟⠝⡾⣼]

fun! nou#task#marker#rgx()
  return '\[%([_$X]|[\u2800-\u28FF]{4}|\d\d\%)\]'
endf

fun! nou#task#marker#pos(text, ...)
  let beg = get(a:, 1, 0)
  let rgx = nou#task#marker#rgx()

  " let [x, off] = xtref#get(a:visual)
  " if empty(x) | return |en
  " let b = col('.')-1 + off
  " let e = b + len(x)
  " let l = getline('.')
  " call setline('.', (b>0 ? l[0:b-1] : '') . a:sub . l[e:])
endf

fun! nou#task#marker#getcur()
  let l = getline('.')
  let [b, e] = nou#task#marker#pos()
  return strpart(l, b, e - b)
endf

fun! nou#task#marker#delcur()
  let line = getline('.')
  let [b, e] = nou#task#marker#pos()
  let e = match(l, '\S', e)
  let repl = (b>0 ? l[0:b-1] : '') . l[e:]
  if line !=# repl| call setline('.', repl) |en
endf

fun! nou#task#marker#replace()
  let l = getline('.')
  let [b, e] = nou#task#marker#pos()
  call setline('.', (b>0 ? l[0:b-1] : '') . a:sub . l[e:])
  return strpart(l, b, e - b)
endf
