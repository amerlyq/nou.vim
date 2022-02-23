""" Common vimscript utils
" USAGE: :runtime autoload/nou/util.vim | echo nou#util#parsetask()

"" linebeg
" FIXME: use function -- to get local &cms per fmt ALSO parse whole range of &comments
" OR: '['. &commentstring[0] .']+\s*'
let s:Rcomment = printf((&l:cms ? &l:cms : &g:commentstring), '\s*')
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
let nou#util#Rdate = s:Ryear.'-'.s:Rmonth.'-'.s:Rday
let s:Rcal  = nou#util#Rdate.'%(-'.s:Rwkdaynm.')?%(-'.s:Rweek.')?'
let s:Rwkyear = s:Ryear.'-'.s:Rweek
let s:Rwkcury = 'C'.s:Rweek
let s:Ranydate = '<%('.s:Rcal.'|'.s:Rwkyear.'|'.s:Rwkcury.')>'

"" time
let s:Rhours = '%([0-9]|[01][0-9]|2[0-4])'
let s:Rminutes = '[0-5][0-9]'
let s:Rseconds = '[0-5][0-9]'
let nou#util#Rtime = s:Rhours.':'.s:Rminutes.'%(:'.s:Rseconds.')?'
let s:Rtimezone = '%(Z|\+%([01][0-9]|2[0-4]):?00)'  " ATT: don't allow fractional time zones
let nou#util#Rdatetime = nou#util#Rdate.'[^0-9]'.nou#util#Rtime.'%('.s:Rtimezone.')?'
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
let s:Rstate0 = '%([_…•‣#≫]|[@!?~￪]|[0-9])'
let s:RstateN = '[/X%*+$<>∞⟫￬]'
let s:RstateD = '%('.s:RstateN.'|'.s:Rbraille.'|'.s:RstateN.s:Rbraille.'|'.nou#util#Rdatetime.')'
let s:Rstate = '%('.s:Rstate0.'|'.s:RstateN.')'
let nou#util#Rtodo = '%(\['.s:Rstate0.'\]|'.s:Rprogress0.')'
let s:Rdone = '%(\['.s:RstateD.'\]|'.s:RprogressN.')'
let nou#util#Rgoal = '%('.nou#util#Rtodo.'|'.s:Rdone.')'

"" duration
let s:Rtimespan = '<%(\d+w\d+d|\d+d\d+h|\d+h\d+m|\d+m\d+s|\d+[wdhms]|\d+\.\d+h)>'
let s:Rduration = '<'.s:Rtimespan.'>'
let s:Restimated = '\('.s:Rtimespan.'\)'
let s:Relapsed = '%('.s:Rduration.'|'.s:Restimated.'|'
  \.s:Rduration.s:Restimated.'|'.s:Rduration.'\(\))'

let s:Rinfix = '[↻ᚹ◔⋆↯✓✗💛▶➥◌⊞]'
let s:Rassoc = '\<\k+\>'
let s:Rmood = '[-*•@+=:~?!<>]{-1,3}'

"" tags
let s:Rperson = '\@\k\S{-}'
let s:Rwebref = '\^\k\S{-}'  " OR: pj-ref
let s:Rhashtag = '[#]\k\S{-}'
let s:Rconcept = '[&]\k\S{-}'
let s:Rtag = '[#@^&]\k\S{-}'  " OR: %('.s:Rperson.'|'.s:Rwebref.'|'.s:Rhashtag.'|'.s:Rconcept.')
let s:Rtags = '%(\s*'.s:Rtag.')+'
let nou#util#Rxtpin = "\u2307".s:Rbraille  " OR: /⌇[⠀-⣿]{4}/
let nou#util#Rxtref = "\u203b".s:Rbraille  " OR: /※[⠀-⣿]{4}/

"" TODO: search by regex whole "ctx" and then use #seekE() to pick tags/group/etc.
" let s:Rctx = '%(\s*%('.s:Rtags.'|'.s:Rgroup.'|'.s:Rvar.'|'.s:Rwebref.'|'.s:Rperson.'|'.nou#util#Rxtref.'))+'

"" body
" BUG: consumes trailing everything :: nou#util#Rxtref, ...
" NEED: search nou#util#Rxtref from any position inside of a line
" TODO: ignore developer's trailing comments e.g. ... #% ...
let s:Rtext = '.*'
let s:Rexplanation = s:Rcomment.s:Rtext
let s:Rbody = ''
  \.'%(('.s:Rassoc.')%(\s+|$))?'
  \.'%(('.s:Rmood.')\s+)?'
  \.'%(('.s:Rtags.')%(\s+|$))?'
  \.'('.s:Rtext.')\s*'
  " \.'%('.nou#util#Rxtref.'\s*)?'
  " \.'%('.s:Rexplanation.'\s*)?'

" [_] BAD: not enough capture groups for infix
"   [_] TRY:HACK: match (parse) in loop one-by-one
"   [_] BET! use external .py library to manipulate tasks
let s:Rtask = ''
  \.'%(('.nou#util#Rdate.')\s+)?'
  \.'%(('.nou#util#Rgoal.')\s+)?'
  \.'%(('.nou#util#Rtime.')\s+)?'
  \.'%('.s:Rinfix.'\s+)?'
  \.'%(('.s:Relapsed.')\s+)?'

"" LEGEND:ATT: only 9 submatch() allowed --> no space for composite groups "task-metadata" and "body"
" \0 = whole-line OR empty match
" \1 = indent / leading comment
" \2 = date
" \3 = goal OR 'state' inside of 'goal'
" \4 = time
" .. = infix
" \5 = elapsed
" \6 = association
" \7 = mood
" \8 = tags
" \9 = text
let nou#util#T_elems = ['line', 'lead', 'date', 'goal', 'time', 'dura', 'assoc', 'mood', 'tags', 'text']
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
let nou#util#T_combo = ['status', 'span', 'plan', 'task', 'meta', 'actx', 'body', 'entry', 'state']
let nou#util#T_all = nou#util#T_elems + nou#util#T_combo
" extend(copy(nou#util#T_elems), nou#util#T_combo)


fun! FLastCharLen(s)
  return strlen(strcharpart(a:s, strchars(a:s) - 1, 1))
endf


" DEV:(replace): call substitute(nou#util#getline(), s:Rtaskline, '\=nou#util#print(lst, submatch(0))', 'g')
fun! nou#util#parsetask(...) abort
  " DEBUG: ultimate task
  " let L = '  # 2020-08-27 [⡟⠜⠪⣡] 15:00 1h15m(30m) <me> +++ ^JIRA-12345 @user #tag1#tag2 ultimate ⌇⡟⠉⠁⠸'
  " ALT: directly use :: let [bln,bco] = searchpos(a:patt, 'cW',  line('.'))
  let L = a:0 ? a:1 : getline('.')
  let nL = strlen(L)
  let elems = matchlist(L, '\v^'.s:Rtaskline.'$')
  if !len(elems)| echoerr 'WTF/impossible: no taskline' |en

  let T = {}
  let T.pos = getpos('.')
  let l = elems[0]


  "" FMT: indexes [b, e]  [B, E)  [B, S]
  "  │elem1   element_2         elem3 ...│
  "  │^0b  ^B ^b {m} e^^E {s} S^      0E^^0S
  let T[g:nou#util#T_elems[0]] = {'m': l, 's': '', 'B': 0, 'b': 0,
    \ 'e': strlen(l) - FLastCharLen(l), 'E': strlen(l), 'S': nL - FLastCharLen(L)}

  " NOTE: extract position of each submatch
  let c = 0
  for i in range(1, len(elems) - 1)
    let m = elems[i]
    let b = (c >= nL) ? nL : stridx(L, m, c)  " ALT? matchstrpos() by regex
    if b<0| echoerr 'WTF/impossible: no #'.i.' task elem='.m
        \.' in L['.c.':'.nL.']. Tokens: '.join(elems[1:], '|') |en
    let E = b + strlen(m)
    let s = matchstr(L, '^\s*', E)
    let c = E + strlen(s)  " HACK: skip spaces

    " ALT:(rev-match): let B = b - strlen(matchstr(join(reverse(split(L[E:], '.\zs')), ''), '\s*'))
    let prev = T[g:nou#util#T_elems[i-1]]
    let B = b - strlen(prev.s)

    "" FAIL: positions are useful to insert only single entry OR span
    ""   ALT:(workaround): start inserting from the end to keep positions
    " call add(mpos, printf('[%d,%d] %s"', b, e, strpart(L, b, e - b)))
    " return join(mpos, "\n")
    let T[g:nou#util#T_elems[i]] = {'m': m, 's': s, 'B': B, 'b': b,
      \ 'e': E - FLastCharLen(m), 'E': E, 'S': c - FLastCharLen((strlen(s) ? s : m))}
    " DEBUG: echom json_encode(T[g:nou#util#T_elems[i]])
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
  return {'m': (a:lhs.m . a:lhs.s . a:rhs.m)
        \,'s': a:rhs.s, 'S': a:rhs.S
        \,'B': a:lhs.B, 'b': a:lhs.b
        \,'e': a:rhs.e, 'E': a:rhs.E}
endf

fun! nou#util#combo_task(...) abort
  let T = a:0 ? a:1 : nou#util#parsetask()
  let T.status = nou#util#merge_E(T.date, T.goal)
  let T.plan = nou#util#merge_E(T.status, T.time)
  let T.span = nou#util#merge_E(T.time, T.dura)
  let T.slot = nou#util#merge_E(T.status, T.span)
  let T.task = nou#util#merge_E(T.plan, T.assoc)
  let T.meta = nou#util#merge_E(T.mood, T.tags)
  let T.actx = nou#util#merge_E(T.assoc, T.meta)
  let T.body = nou#util#merge_E(T.meta, T.text)
  let T.entry = nou#util#merge_E(T.task, T.body)  " WTF: dif. line .vs. entry

  " FIXME: B!=b if spaces surround state inside of goal
  "   CHECK: already fixed by new calculation way of 'B'?
  let T.state = {'m': T.goal.m[1:-2]
    \, 's': '', 'S': T.goal.S
    \, 'B': T.goal.b, 'b': T.goal.b + 1
    \, 'e': T.goal.e - 1, 'E': T.goal.E}
  return T
endf

fun! nou#util#get(...)
  let T = a:0>=2 ? a:2 : nou#util#parsetask()
  if a:0<1| return T |en
  " NOTE: lazy extend
  if index(g:nou#util#T_elems, a:1)<0| let T = nou#util#combo_task(T) |en
  let T[a:1].pos = T.pos
  return T[a:1]
endf

fun! nou#util#Targs(...)
  if a:0>1| return a:000
  elseif a:0<1||a:1==0| return ['b', 'e']
  elseif a:1==1 | return ['b', 'S']
  elseif a:1==#'BS' | return ['B', 'S']
  else | return ['B', a:1]
  endif
endf

" FIXME: if new line is the same -- don't modify it to preserve buffer state
"   TRY: return empty list i.e. invalid textobj selection ?
fun! nou#util#Tpos(spaced, elem, ...)
  let x = call('nou#util#get', [a:elem] + a:000)

  " HACK: invert space logic when deleting
  " WF:BET?(consistence): don't invert textobj
  "   + BET:chg: mechanically train pressing d<LL>G when using delete
  "   - BAD:now: mentally remember to expect different behavior
  let wsp = ((v:operator ==# 'd') ? !a:spaced : a:spaced)

  " NOTE: textobj selection always includes end-char
  let [b, e] = nou#util#Targs(wsp)
  " DEBUG: echom b.'|'.e.'|'.v:operator.'|'.wsp

  let Pb = deepcopy(x.pos)
  let Pb[2] = x[b] + 1  " NOTE: col('.') starts from 1
  let Pe = deepcopy(x.pos)
  let Pe[2] = x[e] + 1

  " ALG:ENH: smart-insert for :h operator
  "   * d<LL>a = must delete whole "<me> " with trailing spaces
  "   * d<LL>A = must delete whole "<me>" w/o spaces (inverted logic)
  "   * d<LL>a = when empty must do nothing
  "   * c<LL>a = must delete only "me" and leave cursor inside "<|>"
  "   * c<LL>a = when empty must insert surrounding chars "<|>"
  "   * c<LL>G = must remove trailing space and drop into change mode
  "     IDEA:TRY: use REPLACE mode for "goal" to insert single char easily
  "
  let [pfx,sfx] = get(
    \{ 'goal': ['[', ']']
    \, 'assoc': ['<', '>']
    \, 'tags': ['#', '']
    \}, a:elem, ['', ''])

  "" ERR: textobj with Pb==Pe still has length=1
  " BET:HACK: only move cursor :: return (Pb == Pe) ? 0 : ['v', Pb, Pe]
  "   FAIL: setpos('.', Pb) don't work in operator-pending mode

  " NOTE: allow textobj with real len>=1
  if x[b] !=# x[e] || x.e !=# x.E
    if v:operator ==# 'c'
      let Pb[2] += strlen(pfx)
      if e==#'e' " NOTE: because in _a mode we must not subtract from 'S'
        let Pe[2] -= strlen(sfx)
      end
    en
    " echom json_encode(['v', Pb, Pe])
    return ['v', Pb, Pe]
  en

  " NOTE: don't do anything when modifying non-existent element
  if v:operator !=# 'c' | return 0 |en

  " FIXED: undesired leading space before "<W>"
  let nopfx = ['lead', 'date', 'goal', 'assoc', 'status', 'plan', 'task', 'entry']
  let pfx = ((x.B == x.b && index(nopfx, a:elem)<0) ? ' ' : '') . pfx
  let ifx = ' '
  let Pb[2] += strlen(pfx)
  let Pe[2] = Pb[2] + strlen(ifx) - FLastCharLen(ifx)

  " BET:FIXME: don't append space if it's EOL {x.E == T['line'].E}
  "   .instead-of. current name matching
  let nosfx = ['lead', 'text', 'body', 'entry']
  let sfx = sfx . ((!strlen(x.s) && index(nosfx, a:elem)<0) ? ' ' : '')

  " DEBUG: echom pfx.ifx.sfx

  let l = getline('.')
  let rest = (e==#'S') ? x.E + strlen(x.s) : x.E
  call setline('.', strpart(l,0,x[b]) .pfx.ifx.sfx. strpart(l,rest))
  return ['v', Pb, Pe]
endf

fun! nou#util#replace(elem, newval, ...)
  let L = a:0 ? a:1 : getline('.')
  let [_, Pb, Pe] = nou#util#Tpos(0, a:elem, nou#util#parsetask(L))
  " REF: [bufnum, lnum, col, off]
  " echo [Pb[2], Pe[2]]
  return L[:Pb[2]] . a:newval . L[Pe[2]:]
endf

"""""""""""""""""""
for s:nm in nou#util#T_all
  let s:fnm = 'nou#util#textobj_'. s:nm
  exe "fun! ".s:fnm."_i() range\nreturn nou#util#Tpos(0,'".s:nm."')\nendf"
  exe "fun! ".s:fnm."_a() range\nreturn nou#util#Tpos(1,'".s:nm."')\nendf"
endfor
