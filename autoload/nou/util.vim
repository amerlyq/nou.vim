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
let s:Rstatus0 = '%([_]|[@!?]|[0-9])'
let s:RstatusN = '[X+$]'
let s:RstatusD = '%('.s:RstatusN.'|'.s:Rbraille.'|'.s:Rdatetime.')'
let s:Rstatus = '%('.s:Rstatus0.'|'.s:RstatusN.')'
let s:Rtodo = '%(\['.s:Rstatus0.'\]|'.s:Rprogress0.')'
let s:Rdone = '%(\['.s:RstatusD.'\]|'.s:RprogressN.')'
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
let s:Raddressing = '\@\k\S{-}'
let s:Rurlalias = '\^\k\S{-}'
let s:Rhashtag = '[#]\k\S{-}'
let s:Rtag = '[#@^]\k\S{-}'  " OR: %('.s:Raddressing.'|'.s:Rurlalias.'|'.s:Rhashtag.')
let s:Rtags = '%(\s*'.s:Rtag.')+'
" let s:Rxtref = '\u2307'.s:Rbraille  " OR: /⌇[⠀-⣿]{4}/

"" body
let s:Rtext = '.*'  " BUG: consumes trailing everything :: s:Rxtref, ...
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
" \3 = goal
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


" DEV:(replace): call substitute(nou#util#getline(), s:Rtaskline, '\=nou#util#print(lst, submatch(0))', 'g')
fun! nou#util#parsetask() abort
  " DEBUG: ultimate task
  " let l = '  # 2020-08-27 [⡟⠜⠪⣡] 15:00 1h15m(30m) <me> +++ ^JIRA-12345 @user #tag1#tag2 ultimate ⌇⡟⠉⠁⠸'
  " ALT: directly use :: let [bln,bco] = searchpos(a:patt, 'cW',  line('.'))
  let l = getline('.')
  let elems = matchlist(l, '\v^'.s:Rtaskline.'$')
  if !len(elems)| echoerr "WTF/impossible: no taskline" |en

  let dpos = {}
  let dpos[s:R_elems[0]] = [elems[0], getpos('.')]

  " NOTE: extract position of each submatch
  let pos = 0
  for i in range(1, len(elems) - 1)
    let m = elems[i]
    let b = stridx(l, m, pos)  " ALT? matchstrpos() by regex
    if b<0| echoerr "WTF/impossible: no task elem" |en
    let e = b + strlen(m)
    let pos = e + (strlen(matchstr(l, '^\s*', e)))  " HACK: skip spaces
    "" FAIL: positions are useful to insert only single entry OR span
    ""   ALT:(workaround): start inserting from the end to keep positions
    " call add(mpos, printf('[%d,%d] %s"', b, e, strpart(l, b, e - b)))
    " return join(mpos, "\n")
    let dpos[s:R_elems[i]] = [m, b, e]
  endfor
  return dpos
endf

" FIXME: if new line is the same -- don't modify it
fun! nou#util#get_goal_i()
  let dpos = nou#util#parsetask()
  let [m, b, e] = dpos.goal
  let pos1 = deepcopy(dpos.line[1])
  let pos2 = deepcopy(dpos.line[1])
  let pos1[2] = b + 1
  let pos2[2] = e
  return ['v', pos1, pos2]
endf

fun! nou#util#get_goal_a()
  let dpos = nou#util#parsetask()
  let [m, b, e] = dpos.goal
  let pos1 = deepcopy(dpos.line[1])
  let pos2 = deepcopy(dpos.line[1])
  let pos1[2] = b + 1
  echo strlen(matchstr(getline('.'), '^\s*', e))
  let pos2[2] = e + strlen(matchstr(getline('.'), '^\s*', e))
  return ['v', pos1, pos2]
endf

" DEP:NEED: |kana/vim-textobj-user|
call textobj#user#plugin('task', {
\   'goal': {
\     'select-i': '<LocalLeader>t',
\     'select-a': '<LocalLeader>T',
\     'select-i-function': 'nou#util#get_goal_i',
\     'select-a-function': 'nou#util#get_goal_a',
\   },
\ })
