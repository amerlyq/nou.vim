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


fun! nou#vsel_apply(visual, fn)
  " BUG: in VSEL mode wrong cursor pos: '.' == '<
  let pos = exists('*getcurpos') ? getcurpos() : getpos('.')
  " echom string(l:pos)
  let rgn = a:visual ? range(getpos("'<")[1], getpos("'>")[1]) : [line('.')]
  for i in rgn
    let line = getline(i)
    let chgd = call(a:fn, [line])
    if chgd !=# line| call setline(i, chgd) |en
  endfor
  call setpos('.', pos)
endf


fun! nou#bar(...) range
  if a:0<1 || type(a:1) != type('')| throw "wrong a:1" |en
  " USAGE: <5,.x> → 50% | <45,.x> → 45% | <105,.x> 05%
  let pfx = a:1
  let pfx = substitute(pfx, '[0-9]', '', 'g')  " Strip progress lvl
  let pfx = substitute(pfx, 'D', strftime('%Y-%m-%d '), '')
  if pfx =~# '[_$X<]'
    " BET: use separate keys: 50<Space>% and <Space>%50 (inserts cursor at "[|%]")
    " IDEA: use mixed log-xts "[⡟⢝⣣⣔%50]" OR "[50%⡟⢝⣣⣔]" instead of "[50%] s <⡟⢝⣣⣔>"
    let pg = a:2 < 10 ? a:2*10 : a:2 >= 100 ? a:2 % 100 : a:2
    let mrk = '['. (a:2 ? printf('%02d', pg).'%' : '&') .'] '
    let pfx = substitute(pfx, '[_$X<]', mrk.'\\2', '')
  endif
  if pfx =~# 'T'
    " HACK: asymmetric rounding to nearest 5min interval :: 02+ -> 05, 07+ -> 10
    let ivl5 = str2float(strftime('%M')) / 5
    let min5 = float2nr(round(ivl5 + 0.1) * 5)
    let hour = float2nr(str2float(strftime('%H'))) + min5/60
    let now = (a:2 == 0) ? printf('%02d:%02d', hour % 24, min5 % 60)
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
      \ '\v^(\s*%([-+=*<>!?]{-1,3}\s+)?)'
      \.'%(<\d{4}-%(0\d|1[012])-%([012]\d|3[01])>\s*)?'
      \.'%('. g:nou#util#Rgoal .'\s+)?'
      \.'(<%(\d|[01]\d|2[0-4]):[0-5]\d%(:[0-5]\d)?>\s*)?'
      \.'(.*)$',
      \ '\1'.pfx.'\3', '')
    if chgd !=# line| call setline(i, chgd) |en
  endfor

  call setpos('.', l:pos)
endf


fun! nou#path_open(path, ...)
  let p = a:path
  let bang = get(a:, 1, 0)  "ALT:USE: <count> i.e. <1 g f> == force open non-existent file

  let idx = stridx(p, '/')
  if idx < 0| let idx = 0 |en
  if idx == 0 && strpart(p,1,1) == '/'| let idx = 1 |en
  let pfx = strpart(p, 0, idx)
  let p = strpart(p, idx)

  " TODO: parse paths like /⡟⢟⢗⡼ OR /@/⡟⢟⢗⡼ virtually and limit results
  "   only to standalone tags on the first lines of the files
  " IDEA: use sfx/pfx as "selectors" e.g. /⡟⢟⢗⡼/web/github to limit search by
  " ALSO use regex to conduct full-text search /⡟⢟⢗⡼/ into quickfix instead of opening file
  "   -- useful for top project when you wish to collect all related ^⡟⢟⢗⡼ subtasks

  " FIXME: ./path/ must count from current file, not cwd
  " ENH: prepend mounted-at / remote-host prefix FIXME: '~' = remote $HOME
  " THINK: distinguish "here" and "there" for path relative to current file
  if pfx ==# ''  " NOTE:(/...): use abspath as-is
    if match(a:path, '\v[\u2800-\u28FF]{4}') > -1
      norm g]
      return
    endif
  elseif pfx ==# '.' | let p = expand('%:h') . p " NOTE:(./): rel to curr file
  " elseif pfx ==#'..' | let p = expand('%:h').'/'.pfx . p " NOTE: rel to 'here'
  elseif pfx ==#'..' | let p = expand('%:p:h:h') . p " NOTE:(../): rel to 'there'
  elseif pfx ==# '~' | let p = $HOME . p
  elseif pfx ==# '@' | let p = '/@/aura'. p  " BAD: I have nested repo
  elseif pfx ==# '♆' | let p = map(['', '/.edit', '/setup'], '"/@/airy'.p.'".v:val')
  elseif pfx ==# '☆' | let p = '/x'. p
  elseif pfx ==# '★' | let p = '/x/_fav'. p
  " BET? merge and replace '//' by '%'
  "   OR split WF and use '=/' for file-local vars
  "   OR:BET: use VARs ::  '$var/path' where ⋮var=/path/to⋮ is defined in file
  elseif pfx ==# '%' | let p = getcwd() . p  " CHECK: different $PWD
  elseif pfx ==# '/'
    " TODO: search ctx ⋮//=/path/to/dir⋮ inside same file above current line
    let d = get(b:,'nou',g:nou).loci
    " BAD: unpredictably changes in each buffer due to locally saved view settings
    if d ==# ''| let d = getcwd() |en
    let p = d . p
  elseif pfx ==# '☤'
    " DEV:NEED: better introspection, similar to '&'
    " [_] FIXME:BET: allow subpath under repo "@/nou.vim/Makefile" instead of prefix grouping ⌇⡞⣥⣕⡋
    " WARN: prefixes not allowed (i.a. @/miur/kirie) <= indistinguishable from repo subpath
    " ALT:MAYBE: extend ":" syntax ":/file/here" .vs. ":somerepo/file/there"
    let cmdline = "find -H '".$HOME."/aura' -path '*".p."/.git' -execdir pwd \\;"
    let res = systemlist(cmdline)
    let repo = (len(res) > 0) ? res[0] : ($HOME .'/aura'. p)
    " BET? open dir in netrw instead of single file ? BUT: dir is accessible by <,r> anyways
    " ALT: repeat search for list of globs ['README*', 'Makefile'] in repo dir and open first found file
    let p = repo .'/Makefile'
  elseif pfx ==# '&'
    "" FIXME:DEV: search ignored dir '/&/' up-pwd to open referenced untracked file
    "" IDEA:(aura): track filelist and restore on demand the content of /&/ on other devices beside home PC
    "  DEV:(commit hook): dump list of untracked files under ./&/ into '&.nou' as "&/path/to/file" lines
    " let d = expand('%:h')
    " while d !=# '/'
    "   if exists(d .'/&/') | let p = d .'/&/'. p | en
    " endwhile
    " if !exists(d .'/&/')
    "   echom 'Not found: '. d .'/&/'. p
    "   return
    " en
  elseif pfx ==# ':'
    " ALT: see "\cd" cmd impl
    let d = fnameescape(expand('%:h'))
    let g = systemlist('git -C '.d.' rev-parse --show-toplevel')
    let p = g[0] . p
  " ALT:IDEA: use "…/t_parglare" or "?/t_parglare" to search file system-wide through "locate(1)"
  elseif pfx ==# '…'
    let p = strpart(p, 1)
    " NOTE: search in all 'path' like usual 'gf' do
    exe 'find' fnameescape(p)
    return
  else
    norm! gf
    return
  en
  " NOTE: find primary file as first readable candidate in multivariants
  if type(p) == type([])| let [p, xs] = [get(p, 0, ''), p]
    for x in xs| if filereadable(x)| let p = x | break |en |endfor
  endif
  if !bang && !filereadable(p)
    echohl ErrorMsg
    echom "No such file:" p
    echohl None
  else
    exe 'edit' fnameescape(p)
  endif
endf


fun! nou#spdx_header()
  let year = strftime('%Y')
  let name = join(systemlist('git config --get user.name'))
  let email = join(systemlist('git config --get user.email'))
  if email =~# '@gmail' && email !~# '+'
    let sfx = 'nou'
    let email = substitute(email, '@', ('+'.sfx.'@'), '')
  fi
  let tail = ' and contributors.'
  let copyright = year .' '. name .' <'. email .'>'. tail
  let license = 'CC-BY-SA-4.0'
  " TODO: generate optional xtref on first line
  " ARCH: file ::= shebang | vimopts | xtref | spdx | #% | body
  let header = 'SPDX-FileCopyrightText: '. copyright
    \."\n\n" . 'SPDX-License-Identifier: '. license
    \."\n-----\n"
  return header
endf
