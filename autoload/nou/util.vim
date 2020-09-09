""" Common vimscript utils
" USAGE: :runtime autoload/nou/util.vim | echo nou#util#parsetask()

"" linebeg
" FIXME: use function -- to get local &cms per fmt ALSO parse whole range of &comments
let s:Rcomment = printf(&commentstring, '\s*')  " OR: '['. &commentstring[0] .']+\s*'
let s:Rindent = '\s*'
let s:Rsubject = '.*'.s:Rcomment

" REGR: in .nou instead of task itself "comment" treated as "task"
" let s:Rlinebeg = '%('.s:Rsubject.'|'.s:Rindent.')'
let s:R_incomments = 0 > index(map(['nou', 'text'], '&filetype =~ v:val'), 1)
let s:Rlinebeg = (s:R_incomments ? s:Rsubject : s:Rindent)


"" date
let s:Ryear = '20[0-9][0-9]'
let s:Rmonth = '%(0[0-9]|1[012])'
let s:Rday = '%([012][0-9]|3[01])'
let s:Rwkdaynm ='(Mon|Tue|Wed|Thu|Fri|Sat|Sun)'  " OR: %(-\u\l\l?)
let s:Rweek='W([0-4][0-9]|5[0-3])'
let s:Rdate = s:Ryear.'-'.s:Rmonth.'-'.s:Rday
let s:Rcal  = s:Rdate.'%(-'.s:Rwkdaynm.')?%(-'.s:Rweek.')?'
let s:Rwkyear = s:Ryear.'-'.s:Rweek
let s:Rwkcury = 'C'.s:Rweek
let s:Ranydate = '<%('.s:Rcal.'|'.s:Rwkyear.'|'.s:Rwkcury.')>'

"" time
let s:Rhours = '%([0-9]|[01][0-9]|2[0-4])'
let s:Rminutes = '[0-5][0-9]'
let s:Rseconds = '[0-5][0-9]'
let s:Rtime = s:Rhours.':'.s:Rminutes.'%(:'.s:Rseconds.')?'
let s:Rtimezone = '%(Z|\+%([01][0-9]|2[0-4])00)'  " ATT: don't allow fractional time zones
let s:Rdatetime = s:Rdate.'[^0-9]'.s:Rtime.'%('.s:Rtimezone.')?'
let s:Rbraille = '[\u2800-\u28FF]{4}'
" TODO: "nano{datetime,braille}"

"" progress
let s:Rratio  = '\d+/\d*'
let s:Rratio0 = '0+/\d*'
let s:RratioN = '\d*[1-9]\d*/\d*'
let s:Rpercent = '\d+\%'
let s:Rpercent0 = '0+\%'
let s:RpercentN = '\d*[1-9]\d*\%'
let s:Rprogress = '\[%('.s:Rratio.'|'.s:Rpercent.')\]'
let s:Rprogress0 = '\[%('.s:Rratio0.'|'.s:Rpercent0.')\]'
let s:RprogressN = '\[%('.s:RratioN.'|'.s:RpercentN.')\]'

"" status
" FIXME: mixed :: status .vs. priority .vs. progress
let s:Rstate0 = '%([_]|[@!?]|[0-9])'
let s:RstateN = '[X+$]'
let s:RstateD = '%('.s:RstateN.'|'.s:Rbraille.'|'.s:Rdatetime.')'
let s:Rstate = '%('.s:Rstate0.'|'.s:RstateN.')'
let s:Rtodo = '%(\['.s:Rstate0.'\]|'.s:Rprogress0.')'
let s:Rdone = '%(\['.s:RstateD.'\]|'.s:RprogressN.')'
let s:Rgoal = '%('.s:Rtodo.'|'.s:Rdone.')'

"" duration
let s:Rtimespan = '%([0-9.]+[wdhms]){1,5}>'
let s:Rduration = '<'.s:Rtimespan.'>'
let s:Restimated = '\('.s:Rtimespan.'\)'
let s:Relapsed = '%('.s:Rduration.'|'.s:Restimated.'|'
  \.s:Rduration.s:Restimated.'|'.s:Rduration.'\(\))'

let s:Rassoc = '\<\k+\>'
let s:Rmood = '[-*•@+=:~?!<>]{-1,3}'

"" tags
let s:Rperson = '\@\k\S{-}'
let s:Rwebref = '\^\k\S{-}'
let s:Rhashtag = '[#]\k\S{-}'
let s:Rtag = '[#@^]\k\S{-}'  " OR: %('.s:Rperson.'|'.s:Rwebref.'|'.s:Rhashtag.')
let s:Rtags = '%(\s*'.s:Rtag.')+'
let s:Rxtpin = '\u2307'.s:Rbraille  " OR: /⌇[⠀-⣿]{4}/
let s:Rxtref = '\u203b'.s:Rbraille  " OR: /※[⠀-⣿]{4}/

"" TODO: search by regex whole "ctx" and then use #seekE() to pick tags/group/etc.
" let s:Rctx = '%(\s*%('.s:Rtags.'|'.s:Rgroup.'|'.s:Rvar.'|'.s:Rwebref.'|'.s:Rperson.'|'.s:Rxtref.'))+'

"" body
" BUG: consumes trailing everything :: s:Rxtref, ...
" NEED: search s:Rxtref from any position inside of a line
" TODO: ignore developer's trailing comments e.g. ... #% ...
let s:Rtext = '.*'
let s:Rexplanation = s:Rcomment.s:Rtext
let s:Rbody = ''
  \.'%(('.s:Rassoc.')%(\s+|$))?'
  \.'%(('.s:Rmood.')\s+)?'
  \.'%(('.s:Rtags.')%(\s+|$))?'
  \.'('.s:Rtext.')\s*'
  " \.'%('.s:Rxtref.'\s*)?'
  " \.'%('.s:Rexplanation.'\s*)?'

let s:Rtask = ''
  \.'%(('.s:Rdate.')\s+)?'
  \.'%(('.s:Rgoal.')\s+)?'
  \.'%(('.s:Rtime.')\s+)?'
  \.'%(('.s:Relapsed.')\s+)?'

"" LEGEND:ATT: only 9 submatch() allowed --> no space for composite groups "task-metadata" and "body"
" \0 = whole-line OR empty match
" \1 = indent / leading comment
" \2 = date
" \3 = goal OR 'state' inside of 'goal'
" \4 = time
" \5 = elapsed
" \6 = association
" \7 = mood
" \8 = tags
" \9 = text
let s:R_elems = ['line', 'lead', 'date', 'goal', 'time', 'dura', 'assoc', 'mood', 'tags', 'text']
let s:Rtaskline = ''
  \.'%(('.s:Rlinebeg.')\s*)?'
  \.'%('.s:Rtask.'\s*)?'
  \.'%('.s:Rbody.'\s*)?'

"" VIZ: different combined objects
" status = date + goal
" span = time + dura
" plan = status + span
" task = plan + assoc
" meta = assoc + mood + tags
" body = meta + text
" entry/whole = <all> - indent
let s:R_combo = ['status', 'span', 'plan', 'task', 'meta', 'actx', 'body', 'entry', 'state']


" DEV:(replace): call substitute(nou#util#getline(), s:Rtaskline, '\=nou#util#print(lst, submatch(0))', 'g')
fun! nou#util#parsetask(...) abort
  " DEBUG: ultimate task
  " let L = '  # 2020-08-27 [⡟⠜⠪⣡] 15:00 1h15m(30m) <me> +++ ^JIRA-12345 @user #tag1#tag2 ultimate ⌇⡟⠉⠁⠸'
  " ALT: directly use :: let [bln,bco] = searchpos(a:patt, 'cW',  line('.'))
  let L = a:0 ? a:1 : getline('.')
  let elems = matchlist(L, '\v^'.s:Rtaskline.'$')
  if !len(elems)| echoerr 'WTF/impossible: no taskline' |en

  let T = {}
  let T.pos = getpos('.')
  let l = elems[0]
  let T[s:R_elems[0]] = {'m': l, 's': '', 'B': 0, 'b': 0, 'e': strlen(l), 'E': strlen(L)}

  " NOTE: extract position of each submatch
  let c = 0
  for i in range(1, len(elems) - 1)
    let m = elems[i]
    let b = stridx(L, m, c)  " ALT? matchstrpos() by regex
    if b<0| echoerr 'WTF/impossible: no task elem' |en
    let e = b + strlen(m)
    let s = matchstr(L, '^\s*', e)
    let c = e + strlen(s)  " HACK: skip spaces
    "" FAIL: positions are useful to insert only single entry OR span
    ""   ALT:(workaround): start inserting from the end to keep positions
    " call add(mpos, printf('[%d,%d] %s"', b, e, strpart(L, b, e - b)))
    " return join(mpos, "\n")
    let T[s:R_elems[i]] = {'m': m, 's': s, 'B': b, 'b': b + 1, 'e': e, 'E': c}
  endfor
  return T
endf

"" NOTE: search free elements
" xtref
" group
" tag
fun! nou#util#seek_E(T, elem, ...) abort
  let pos = get(a:, 1)
endf

fun! nou#util#merge_E(lhs, rhs) abort
  return {'m': a:lhs.m + a:lhs.s + a:rhs.m, 's': a:rhs.s
    \, 'B': a:lhs.B, 'b': a:lhs.b, 'e': a:rhs.e, 'E': a:rhs.E}
endf

fun! nou#util#combo_task(...) abort
  let T = a:0 ? a:1 : nou#util#parsetask()
  let T.status = nou#util#merge_E(T.date, T.goal)
  let T.span = nou#util#merge_E(T.time, T.dura)
  let T.plan = nou#util#merge_E(T.status, T.span)
  let T.task = nou#util#merge_E(T.plan, T.assoc)
  let T.meta = nou#util#merge_E(T.mood, T.tags)
  let T.actx = nou#util#merge_E(T.assoc, T.meta)
  let T.body = nou#util#merge_E(T.meta, T.text)
  let T.entry = nou#util#merge_E(T.task, T.body)  " WTF: dif. line .vs. entry

  " FIXME: B!=b if spaces surround state inside of goal
  let T.state = {'m': T.goal.m[1:-2], 's': ''
    \, 'B': T.goal.b, 'b': T.goal.b + 1
    \, 'e': T.goal.e - 1, 'E': T.goal.e}
  return T
endf

fun! nou#util#Targs(...)
  if a:0>1| return a:000
  elseif a:0<1||a:1==0| return ['b', 'e']
  elseif a:1==1 | return ['b', 'E']
  elseif a:1=='S' | return ['B', 'E']
  else | return ['B', a:1]
  endif
endf

" FIXME: if new line is the same -- don't modify it to preserve buffer state
"   TRY: return empty list i.e. invalid textobj selection ?
fun! nou#util#Tpos(outer, elem, ...)
  let T = a:0 ? a:1 : nou#util#parsetask()
  " NOTE: lazy extend
  if index(s:R_elems, a:elem) < 0| let T = nou#util#combo_task(T) |en
  let x = T[a:elem]
  let [b, e] = nou#util#Targs(a:outer)
  let Pb = deepcopy(T.pos)
  let Pb[2] = x[b]
  let Pe = deepcopy(T.pos)
  let Pe[2] = x[e]
  return ['v', Pb, Pe]
endf

fun! nou#util#replace(elem, newval, ...)
  let L = a:0 ? a:1 : getline('.')
  let [_, Pb, Pe] = nou#util#Tpos(0, a:elem, nou#util#parsetask(L))
  " REF: [bufnum, lnum, col, off]
  return L[:Pb[2]] . a:newval . L[Pe[2]:]
endf

"""""""""""""""""""
for s:nm in extend(copy(s:R_elems), s:R_combo)
  let s:fnm = 'nou#util#textobj_'. s:nm
  exe "fun! ".s:fnm."_i()\nreturn nou#util#Tpos(0,'".s:nm."')\nendf"
  exe "fun! ".s:fnm."_a()\nreturn nou#util#Tpos(1,'".s:nm."')\nendf"
endfor
