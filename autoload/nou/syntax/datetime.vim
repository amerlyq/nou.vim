""" Date, Time and Span

""" Date
" MAYBE: make "nouDate/nouTime" into overlay notches to be highlighted everywhere
" TODO: hi! weekdays/weekends dayname differently
" ALT: explicit sfx /%(-%(Mon|Tue|Wed|Thu|Fri|Sat|Sun|Mo|Tu|We|Th|Fr|Sa|Su))?/
" MAYBE: different darkish color for dates below 2000-- to emphasize unrelated historical meaning?

syn cluster nouGenericQ add=nouDate
hi! nouDate ctermfg=178 guifg=#dfaf00
syn match nouDate display excludenl
  \ '\v<%(19|20)\d\d-%(0\d|1[012])%(-%([012]\d|3[01])%(-\u\l\l?)?)?%(-W%([0-4]\d|5[0-3]))?>'
syn match nouDate display excludenl '\v<20\d\d-W%([0-4]\d|5[0-3])>'
syn match nouDate display excludenl '\v<CW%([0-4]\d|5[0-3])>'
syn match nouDate display excludenl '\v<20\d\d-Q[1-4]>'
syn match nouDate display excludenl '\v<20\d\d:\ze\s'

" e.g. 20161114 OR 20161114_043540
syn match nouDate display excludenl
  \ '\v<20\d\d%(0\d|1[012])%([012]\d|3[01])%(_%([01]\d|2[0-4])[0-5]\d[0-5]\d)?>'


"" HACK: emphasize today()
hi! nouDateToday cterm=bold,reverse gui=bold,reverse ctermfg=248 guifg=#a8a8a8
exe 'syn match nouDateToday display excludenl contained containedin=nouDate '
  \. strftime("'\\v%(%Y-%m-%d|%Y%m%d)'")


"" NOTE dim hi for extended suffixes :: dayname, weekends (Sat/Sun), and weeknum
hi! nouDateDay ctermfg=94 guifg=#875f00
syn match nouDateDay display excludenl contained containedin=nouDate '-\u\l\l'
hi! nouDateOff ctermfg=88 guifg=#8c0000
syn match nouDateOff display excludenl contained containedin=nouDate '-[S]\l\l'
hi! nouDateWeek ctermfg=23 guifg=#005f5f
syn match nouDateWeek display excludenl contained containedin=nouDate '-W\d\d'



""" Time
syn cluster nouGenericQ add=nouTime
" hi! nouTime ctermfg=210 guifg=#ff8787
hi! nouTime ctermfg=248 guifg=#a8a8a8
syn match nouTime display excludenl
  \ '\v<%(\d|[01]\d|2[0-4]):[0-5]\d%(:[0-5]\d)?>'


"" HACK: emphasize now() and floored time window
" ALT:BET? cvt localtime()±1h30m -> rgx for full time
" MAYBE: different color for past and future parts of the window
let s:nowh = join(map([-1,0,1], {x-> printf('%02d',(strftime('%H')+23+x)%24)}),'|')
hi! nouTimeWnd cterm=bold gui=bold ctermfg=248 guifg=#a8a8a8
exe 'syn match nouTimeWnd display excludenl contained containedin=nouTime '
  \. "'\\v:@1<!%(". s:nowh ."):[0-9:]+'"

hi! nouTimeNow cterm=bold,reverse gui=bold,reverse ctermfg=248 guifg=#a8a8a8
exe 'syn match nouTimeNow display excludenl contained containedin=nouTime '
  \. "'\\v:@1<!". strftime('%H') .":[0-9:]+'"


""" Span
"" NOTE: task duration estimates and time spans
"" FIXME: must be placed before #artf_ext() to treat ".5h" as timespan instead of extension
""   FAIL: must be after number.vim to prevent overriding wild numbers
" [_] MOVE = :/autoload/nou/syntax
" MAYBE: use different color when "time" is related to "task estimate"
"   * [_] 1h ...
"   * 13:30 1h ...
"   * [_] 13:30 1h ...
" THINK: use dif. colors for each [wdhms] letter inside this hi! group
" ADD? longer abbrev 1day4hr2min3sec
" ADD? volume-speed 1h/task OR task/1h
hi! nouTimeSpan cterm=bold,undercurl gui=bold,undercurl ctermfg=135 guifg=#4f7fef
syn cluster nouArtifactQ add=nouTimeSpan
" ALT:OLD: syn match nouTimeSpan display excludenl '\v<%(\d+[wdhms]){1,5}>'
" MAYBE:allow: 1mo 2mo3d 2y4mo
syn match nouTimeSpan display excludenl
  \ '\v<%(\d+[wdhms]|\d+w\d+d|\d+d\d+h|\d+h\d+m|\d+m\d+s)>'
