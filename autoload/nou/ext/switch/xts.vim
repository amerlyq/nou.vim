""" MOVED: xtref.vim
if !exists('s:grps')
  let s:grps = []
endif

"" WF: from everywhere-notches
" [_] TODO: toggle xtref <-> date
"   REQ: https://github.com/AndrewRadev/switch.vim/issues/78
" switch#NormalizedCase(['one', 'two']),
" switch#NormalizedCaseWords(['five', 'six']),
let s:grps +=
  \[ {
  \    '\v⌇([\u2800-\u28FF]{2,4})': '※\1',
  \    '\v※([\u2800-\u28FF]{2,4})': '^\1',
  \    '\v\^([\u2800-\u28FF]{2,4})': '⌇\1',
  \  }
  \, {
  \    '\v\[([\u2800-\u28FF]{2,4})\]': '<\1>',
  \    '\v\<([\u2800-\u28FF]{2,4})\>': '[\1]',
  \  }
  \]


"" VIZ: date/time
" BUG: default ALG="smallest len match" results in cvt(datetime -> xts2)
"   FAIL: using "g:switch_find_smallest_match=0" requires strict order of all rules
"     << we must load "xtref.vim" and "nou.vim" in explicit order
"     !! impossible to ensure global order for intermixed regexes from two plugins
"   FAIL: zero-match regex in "xtref.vim" can't convert surrounding brackets
"   FIXED: disambigue "date" by trailing text
" let g:nou_switch_groups +=
let s:grps +=
  \[ { '\v<(\d{10})>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' unix fts'))}
  \  , '\v<(20\d{6}_\d{6})>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' fts unix'))}
  \},{ '\v<('.nou#rgx#Rdatetime.')>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' date xts4'))}
  \  , '\v<([\u2800-\u28FF]{4})>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' xts4 date'))}
  \},{ '\v<(20\d{6}|'.nou#rgx#Rcal.')>%(.'.nou#rgx#Rtime.')@!'
  \      : {m -> trim(system('just xts cvt '.shellescape(strpart(m[0],0,10)).' date xts2'))}
  \  , '\v<([\u2800-\u28FF]{2})>' : {m -> trim(system('just xts cvt '.shellescape(m[0]).' xts2 datew'))}
  \}]
"" ALT
" '\v<([\u2800-\u28FF]{4})>' : {br -> strftime('%Y-%m-%d %H:%M:%S%z', str2nr(substitute(br, '.', '\=printf("%02x",and(char2nr(submatch(0)),0xff))', 'g'), 16))}

" HACK! nou#rgx s:Rcomment &commentstring should be read only after ftplugin/*
" autocmd BufReadPost * let g:switch_custom_definitions = s:gen_switch_groups()
" let g:switch_custom_definitions = s:grps
let nou#ext#switch#xts#groups = s:grps
