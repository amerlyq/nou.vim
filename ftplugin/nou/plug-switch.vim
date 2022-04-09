
"" NOTE: loop on <CR> DEP: 'AndrewRadev/switch.vim'
"" IDEA: store addressing into file by @/todo/ctl and load back
"    $ grep -hEro '\@[[:upper:]]\w+(\.\w+)?' SU > addressings
"    FAIL:NEED: show autocomplete lists with suggestions
"    FIXME: rename old @/todo/log/201X/ entries '@<taskname>' -> '@ <taskname>'
" ----
" \   switch#Words(['one', 'two'])
" \   switch#NormalizedCase(['one', 'two']),
" \   switch#NormalizedCaseWords(['five', 'six']),

"" VIZ: artifacts
let g:nou_switch_groups =
  \[ ['^%', '^%%', '^%%%', '^%%%%', '^%%%%%']
  \, map(split('_@!', '\zs'), '"[".v:val."]"')
  \, map(split('+X…', '\zs'), '"[".v:val."]"')
  \, map(split('0123456789', '\zs'), '"[".v:val."0%]"')
  \, split('↻⋆↯💜', '\zs')
  \, split('~▶✓✗', '\zs')
  \, split('◔🔚', '\zs')
  \, ['MAIL', '📩']
  \, ['CALL', '📲']
  \, split('0m 5m 10m 20m 30m 40m 50m')
  \, {'\v<(\d)h30m>': '\1.5h', '\v<(\d).5h>': '\1h30m'}
  \, map(split('me A add'), '"<".v:val.">"')
  \, map(split('W U env'), '"<".v:val.">"')
  \, map(split('next home sleep'), '"<".v:val.">"')
  \, map(split('eat tea coffee flax'), '"#body:".v:val')
  \, map(split('comics fantasy RSS'), '"#leisure:".v:val')
  \, map(split('tracking planning overview timesheet'), '"#taskmgmt:".v:val')
  \]


"" VIZ: date/time
" BUG: default ALG="smallest len match" results in cvt(datetime -> xts2)
"   FAIL: using "g:switch_find_smallest_match=0" requires strict order of all rules
"     << we must load "xtref.vim" and "nou.vim" in explicit order
"     !! impossible to ensure global order for intermixed regexes from two plugins
"   FAIL: zero-match regex in "xtref.vim" can't convert surrounding brackets
"   FIXED: disambigue "date" by trailing text
let g:nou_switch_groups +=
  \[ { '\v<(\d{10})>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' unix fts'))}
  \  , '\v<(20\d{6}_\d{6})>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' fts unix'))}
  \},{ '\v<('.nou#util#Rdatetime.')>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' date xts4'))}
  \  , '\v<([\u2800-\u28FF]{4})>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' xts4 date'))}
  \},{ '\v<(20\d{6}|'.nou#util#Rcal.')>%(.'.nou#util#Rtime.')@!'
  \      : {m -> trim(system('just xts cvt '.shellescape(strpart(m[0],0,10)).' date xts2'))}
  \  , '\v<([\u2800-\u28FF]{2})>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' xts2 datew'))}
  \}]

" TODO: wrap into "nou" group
autocmd FileType nou let b:switch_custom_definitions = g:nou_switch_groups

"" ALT
" '\v<([\u2800-\u28FF]{4})>' : {br -> strftime('%Y-%m-%d %H:%M:%S%z', str2nr(substitute(br, '.', '\=printf("%02x",and(char2nr(submatch(0)),0xff))', 'g'), 16))}
