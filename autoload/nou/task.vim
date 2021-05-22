""" Tasks manipulation

" " FIXME: skip initial commentstring and insert "[_]" directly before actual text
" " BAD: when converting URL into task -- we will have two trailing xtrefs
" nnoremap <Plug>(xtref-task-convert) 0wi[_]<Space><Esc>$"=" ".xtref#new()<CR>p<Plug>(xtref-yank)
" nnoremap <Plug>(xtref-task-insert) i[_]<Space><Esc>
" " FIXME: smart commentstring parsing -- allow "//" and "/*"
" " FIXME: allow inside multiline block comment /* ... */ -- regex w/o leading commentstring
" nnoremap <Plug>(xtref-task-new) :call setline('.', substitute(getline('.'), '\v(['. &commentstring[0] .']+\s*)(\[[_X]\]\s*)?', '\1[_] ', ''))<CR>
" nnoremap <Plug>(xtref-task-done) :call setline('.', substitute(getline('.'), '\V[_]\s\?', xtref#new().' [X] ', ''))<CR><Plug>(xtref-yank)


fun! nou#bar(...) range
  if a:0<1 || type(a:1) != type('')| throw "wrong a:1" |en

  " USAGE: <5,.x> → 50% | <45,.x> → 45% | <105,.x> 05%
  let pfx = a:1
  let pfx = substitute(pfx, '[0-9]', '', 'g')  " Strip progress lvl
  let pfx = substitute(pfx, 'D', strftime('%Y-%m-%d '), '')

  if pfx =~# '[_$X]'
    let pg = a:2 < 10 ? a:2*10 : a:2 >= 100 ? a:2 % 100 : a:2
    let mrk = '['. (a:2 ? printf('%02d', pg).'%' : '&') .'] '
    let pfx = substitute(pfx, '[_$X]', mrk, '')
  endif

  if pfx =~# 'T'
    " HACK: asymmetric rounding to nearest 5min interval :: 02+ -> 05, 07+ -> 10
    let ivl5 = str2float(strftime('%M')) / 5
    let min5 = float2nr(round(ivl5 + 0.1) * 5)
    let hour = float2nr(str2float(strftime('%H')))
    let now = (a:2 == 0) ? printf('%02d:%02d', hour + min5/60, min5 % 60)
          \: a:2 < 24 ? printf('%02d:00', a:2)
          \: a:2 >= 100 ? printf('%02d:%02d', a:2 / 100, a:2 % 100)
          \: a:2 == 24 ? '00:00'
          \: strftime('%H') . printf(':%02d', a:2)
    let pfx = substitute(pfx, 'T', now.' ', '')
  endif

  if pfx =~# 'B'
    let xts = substitute(printf('%08x', strftime('%s')), '..', '\=nr2char("0x28".submatch(0))', 'g')
    let pfx = substitute(pfx, 'B', '['.xts.'] ', '')
  endif

  " BUG: in VSEL mode wrong cursor pos: '.' == '<
  let l:pos = exists('*getcurpos') ? getcurpos() : getpos('.')
  " echom string(l:pos)

  let rgn = [line('.')]
  if get(a:,3)| let rgn = range(getpos("'<")[1], getpos("'>")[1]) |en

  for i in rgn
    let line = getline(i)
    let chgd = substitute(line,
      \ '\v^(\s*%([^[:alpha:][:blank:][\]]{-1,3}\s+)?)'
      \.'%(<\d{4}-%(0\d|1[012])-%([012]\d|3[01])>\s*)?'
      \.'%(\[%([_$X]|[\u2800-\u28FF]{4}|\d\d\%)\]\s*)?'
      \.'%(<%(\d|[01]\d|2[0-4]):[0-5]\d%(:[0-5]\d)?>\s*)?'
      \.'(.*)$',
      \ '\1'.pfx.'\2', '')
    if chgd !=# line| call setline(i, chgd) |en
  endfor

  call setpos('.', l:pos)
endf
