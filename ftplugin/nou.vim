" BUG: loaded 2 times on startup and 1 more for each :edit / reopen
" DEBUG: $ nvim -V20/t/vv backup.task
if exists("b:did_ftplugin")| finish |else| let b:did_ftplugin = 1 |endif
let b:undo_ftplugin = "setl ai< cin< inde< ts< sw< sts< com< cms< fdm< cole< cocu< wrap<"
call nou#opts#init()

""" Mappings

"" TODO:FUTURE: append timeslot size "2021-06-01-Tue-W22 [-/5h30m|8h]"
" [_] 45m(40m‥1h20m) TODO 22<LL>I -> aug cur month | 2205<LL>I -> aug current year
" nnoremap <silent> <Plug>(nou-date) :<C-u>put=strftime('%Y-%m-%d')<CR>
" xnoremap <Plug>(nou-date) "=strftime('%Y-%m-%d')<CR>P
inoremap <Plug>(nou-date) <C-R>=strftime('%Y-%m-%d')<CR>
nnoremap <Plug>(nou-date-i) "=strftime('%Y-%m-%d')<CR>P
nnoremap <Plug>(nou-datew-i) "=strftime('%Y-%m-%d-%a-W%W')<CR>P
nnoremap <Plug>(nou-date-a) "=strftime('%Y-%m-%d')<CR>p
nnoremap <Plug>(nou-datew-a) "=strftime('%Y-%m-%d-%a-W%W')<CR>p

" ENH: augment many other objects beside date
nnoremap <Plug>(nou-complement) E"=join(systemlist("date +'-%a-W%W' -d ".expand('<cWORD>')))<CR>p

runtime ftplugin/nou/abbrev-gen.vim
runtime ftplugin/nou/abbrev-tags.vim
runtime ftplugin/nou/digraphs.vim
runtime ftplugin/nou/options.vim

" [_] FAIL: path with spaces is cropped e.g. "@/so\ me/" OR "⋮@/so me/⋮"
nnoremap <silent> <Plug>(nou-path-open) :call nou#path_open(expand('<cWORD>'))<CR>
xnoremap <silent> <Plug>(nou-path-open) :<C-u>call nou#path_open(nou#vsel())<CR>

nnoremap <silent> <Plug>(nou-task-next) :call setreg('/', '\v'.nou#util#Rtodo, 'c')<CR>n
xnoremap <silent> <Plug>(nou-task-next) :<C-u>call setreg('/', '\v%V'.nou#util#Rtodo, 'c')<CR>n

" BET:TRY: extract regex from syn-match itself
"   [X] SEE: kana/vim-textobj-syntax ::: BAD: it simply increments cursor until finds syntax boundary
" OR: :call search('\V[•]')<CR>
nnoremap <silent> <Plug>(nou-jump-current) :call setreg('/', '\V[\[•‣\]]', 'c')<CR>n
nnoremap <silent> <Plug>(nou-jump-today) :for r in nou#syntax#datetime#Rall\|if search(r)\|break\|en\|endfor<CR>

" FIXME: use vim function to insert 0-line
nnoremap <Plug>(nou-spdx-header) 1G"=nou#spdx_header()<CR>P

" ALSO:TODO: "<LL>>" OR "<LL>p" to postpone ⌇⡟⢋⡚⡀
" convert status "[_]" -> "[>]" when postponing
" - save item's old planned time for tasks with time "[_] xx:yy"
" - use next completed task as a deadline for "[_]" subtasks
" - use "[braille]" for completed tasks
"   i.e. cancel their completion and register ony fact of attention
" - OR that day's 00:00 if planned time is absent "[@]" / "[!]"
" IDEA: convert each new progress [50%] into appended progress train
"   - FSM: [50%] -> [>50%] OR [>|50%]
"   - <⡟⢋⡚⡀50%>⡟⢋⡚⡀70%>⡟⢋⡚⡀90%>
"   - <50%⡟⢋⡚⡀>70%⡟⢋⡚⡀>90%⡟⢋⡚⡀>
"
"" NOTE: map yx -> convert task(time_completion + date-fallback) into xts
fun! s:yank_xts(finished, ...)
  " ALG: get(planned_time) OR: match(nou#util#Rdate, expand('%')) OR: gitblame OR mtime
  "   ALSO: try match both 20201020 and 2020-10-20 in any place of line
  let ymd = matchstr(expand('%:t'), '\v^'.g:nou#util#Rdate)
  if a:finished
    " use next task start time OR completion time from progress
"     " if no date
"     let xts = match(nou#util#Rbraille, nou#util#get('status'))
"     if !length(xts) | let hms = ...
    let L = getline(line('.') + 1)
    let hms = nou#util#parsetask(L).time.m
  else
    " use log time OR planned time
    let hms = nou#util#parsetask().time.m
  end
  let iso = ymd .'T'. hms .':00'. strftime('%z')[:2] .':'.strftime('%z')[3:]
  " INFO:ALT:FAIL: strftime('%s', iso) don't support iso8601
  let ts = py3eval('int(__import__("datetime").datetime.fromisoformat("'.iso.'").timestamp())')
  " DEBUG: echo iso.' --> '.ts
  let xts = substitute(printf('%08x', ts), '..', '\=nr2char("0x28".submatch(0))', 'g')
  call setreg(get(a:,1,'+'), xts, 'c')
endf
nnoremap <buffer> <Plug>(nou-task-xts-beg) :call <SID>yank_xts(0)<CR>
nnoremap <buffer> <Plug>(nou-task-xts-end) :call <SID>yank_xts(1)<CR>

" TODO: jump cursor to "now" or nearest to "now"
"   CASE: navigate agenda.nou and !today after reopening
"   i.e. ( /^<date>/ | /<date>/ | None) -> /<time>/
"     << TRY: current date first, then parse everything,
"     sort by date/time, and search for nearest to current date/time

"" HACK: paste with smart indent
nnoremap <buffer> gp p
nnoremap <buffer> gP P
" ENH: trim all spaces + always cvt to charwise
nnoremap <buffer> <Space>p  a<Space><Esc>p
nnoremap <buffer> <Space>P  a<Space><Esc>P
" Force in-line
" nnoremap <silent><unique>  <Leader>p  :RegConvert b<CR>p
" nnoremap <silent><unique>  <Leader>P  :RegConvert b<CR>P
" nnoremap [Frame]p "+p
" nnoremap [Frame]P "+P

" vnoremap <buffer><unique> gp pgvy
" ENH: if single word -- past on same line by default
nmap <buffer><silent> P <Plug>(nou-paste-smart-above)
nmap <buffer><silent> p <Plug>(nou-paste-smart-below)
" FIXME: use some "=" or "@" register to hide function call
nnoremap <buffer> <Plug>(nou-paste-smart-above) :call nou#paste#smart(v:register,'P',v:count)<CR>
nnoremap <buffer> <Plug>(nou-paste-smart-below) :call nou#paste#smart(v:register,'p',v:count)<CR>


" [_] TODO
" nnoremap <buffer> <Plug>(nou-copy-time-above) :call <SID>TBD(0)<CR>
" nnoremap <buffer> <Plug>(nou-copy-time-below) :call <SID>TBD(0)<CR>
"   \ ['n', '<LocalLeader>O', '<Plug>(nou-copy-time-above)'],
"   \ ['n', '<LocalLeader>o', '<Plug>(nou-copy-time-below)'],

" ALT:
"   nnoremap <silent> <Plug>(nou-set-goal-subdone) :call nou#vsel_apply(0,{x->nou#util#replace('state','+',x)})<CR>
"   xnoremap <silent> <Plug>(nou-set-goal-subdone) :<C-u>call nou#vsel_apply(1,{x->nou#util#replace('state','+',x)})<CR>
" WF:NOTE:(<LL>[_+>]): immediately convert to subtask (i.e. set indent=2)
nmap <buffer> <Plug>(nou-cvt-subtask) d<Plug>(textobj-nou-time-i)c<Plug>(textobj-nou-lead-i)<Space><Space><Esc>3l
nmap <buffer> <Plug>(nou-set-goal-mandatory) "_c<Plug>(textobj-nou-goal-i)!<Esc>
xnoremap <buffer> <Plug>(nou-set-goal-mandatory) :<C-u>exe "'<,'>norm \"_c\<Plug>(textobj-nou-goal-i)!<C-v><Esc>"<CR>
nmap <buffer> <Plug>(nou-set-goal-today) "_c<Plug>(textobj-nou-goal-i)@<Esc>

" HACK: use black-hole-register("_) to keep clipboard during WF=task-postponing
" NOTE: cvt to subtask is useful for *flat* log, but NOT for workflow-structured one
"   c<Plug>(textobj-nou-goal-i)+<Esc><Plug>(nou-cvt-subtask)
nmap <buffer> <Plug>(nou-set-goal-subtodo) "_c<Plug>(textobj-nou-goal-i)_<Esc>
nmap <buffer> <Plug>(nou-set-goal-subdone) "_c<Plug>(textobj-nou-goal-i)+<Esc>
" MAYBE:RENAME:(postpone[>]): -> carry [forward] | rescheduled -- as it's what I actually do
nmap <buffer> <Plug>(nou-set-goal-postpone) "_c<Plug>(textobj-nou-goal-i)><Esc>
nmap <buffer> <Plug>(nou-set-goal-waiting) "_c<Plug>(textobj-nou-goal-i)…<Esc>
nmap <buffer> <Plug>(nou-set-goal-likely) "_c<Plug>(textobj-nou-goal-i)~<Esc>
nmap <buffer> <Plug>(nou-set-goal-unlikely) "_c<Plug>(textobj-nou-goal-i)?<Esc>
nmap <buffer> <Plug>(nou-set-goal-now) "_c<Plug>(textobj-nou-goal-i)•<Esc>
nmap <buffer> <Plug>(nou-set-goal-next) "_c<Plug>(textobj-nou-goal-i)‣<Esc>
nmap <buffer> <Plug>(nou-set-goal-feed) "_c<Plug>(textobj-nou-goal-i)∞<Esc>
nmap <buffer> <Plug>(nou-set-goal-partial) "_c<Plug>(textobj-nou-goal-i)%<Esc>
nmap <buffer> <Plug>(nou-set-goal-progress) "_c<Plug>(textobj-nou-goal-i)-/<C-r>=v:count1<CR>h<Esc>
nmap <buffer> <Plug>(nou-set-goal-low) "_c<Plug>(textobj-nou-goal-i)￬<Esc>
nmap <buffer> <Plug>(nou-set-goal-high) "_c<Plug>(textobj-nou-goal-i)￪<Esc>
nmap <buffer> <Plug>(nou-set-goal-rephrase) "_c<Plug>(textobj-nou-goal-i)#<Esc>
nmap <buffer> <Plug>(nou-set-goal-delegated) "_c<Plug>(textobj-nou-goal-i)⟫<Esc>
nmap <buffer> <Plug>(nou-set-goal-deferred) "_c<Plug>(textobj-nou-goal-i)≫<Esc>

"" DISABLED: can't batch-replace status for multiple tasks
" nmap <buffer> <Plug>(nou-set-goal-todo) c<Plug>(textobj-nou-goal-i)_<Esc>
" omap <buffer> <Plug>(nou-set-goal-todo) <Plug>(textobj-nou-goal-i)_<Esc>

nmap <buffer> <Plug>(nou-del-status) d<Plug>(textobj-nou-status-i)
nmap <buffer> <Plug>(nou-del-assoc) d<Plug>(textobj-nou-assoc-i)
nmap <buffer> <Plug>(nou-set-date-today) "_c<Plug>(textobj-nou-date-i)<C-r>=strftime('%Y-%m-%d')<CR><Esc>
nmap <buffer> <Plug>(nou-set-time-now) "_c<Plug>(textobj-nou-time-i)<C-r>=nou#now(v:count)<CR><Esc>


" HACK: merge next task with prev line time
" nmap <buffer> <Plug>(nou-merge-plan) d<Plug>(textobj-nou-plan-i)kJ
nmap <buffer> <Plug>(nou-merge-plan) d<Plug>(textobj-nou-goal-i)d<Plug>(textobj-nou-time-i)kJ
nmap <buffer> <Plug>(nou-del-plan) d<Plug>(textobj-nou-plan-i)

" FAIL: can't apply multiple times to visual selection
nmap <buffer> <Plug>(nou-cvt-task) d<Plug>(textobj-nou-lead-i)c<Plug>(textobj-nou-goal-i)_<Esc>


" Python #just
nmap <buffer> <Plug>(nou-fix-claimed) :call NouFixClaimed()<CR>
map <buffer> <Plug>(nou-log-next) :<C-u>call NouLogAdvance(1)<CR>
map <buffer> <Plug>(nou-log-prev) :<C-u>call NouLogAdvance(-1)<CR>

" TODO: <count><LL>m must set minutes w/o changing hours
"   IDEA: pick different cmd depending on <count>
"     e.g. <Plug>(nou-me-or-minutes) and <Plug>(nou-task-or-hours)
"   NEED: 1st arg=>100 always treated as hours:minutes
"   NEED: 2nd arg=0/1/-1 to pick both/hours/minutes
"   IDEA: 3rd arg=0/1/-1 to pick abs value or increment/decrement
"   FAIL: for 2nd and 3rd I must know value under cursor -- easier to parse by #tenjo python
"     BAD: not much easier from #tenjo considering massive RFC needed in manipulate.py
" nmap <buffer> <Plug>(nou-set-time-now) "_c<Plug>(textobj-nou-time-i)<C-r>=nou#now(v:count,1)<CR><Esc>

" DISABLED: I never expect to convert subtask to task
"   ['n', '<LocalLeader><Space>', '<Plug>(nou-cvt-task)'],
"   ['n', '<LocalLeader><Space>', '<Plug>(nou-set-goal-todo)'],
"" FAIL: don't work -- because rhs already bound
"   ['n', '<LocalLeader>;', '<Plug>(nou-set-goal-now)'],
let s:nou_mappings = [
  \ ['nx', 'gf', '<Plug>(nou-path-open)'],
  \ ['nx', '[g', '<Plug>(nou-log-prev)'],
  \ ['nx', ']g', '<Plug>(nou-log-next)'],
  \ ['n', '<LocalLeader>yx', '<Plug>(nou-task-xts-beg)'],
  \ ['n', '<LocalLeader>yX', '<Plug>(nou-task-xts-end)'],
  \ ['n', '<LocalLeader>a', '<Plug>(nou-date-a)'],
  \ ['n', '<LocalLeader>A', '<Plug>(nou-datew-a)'],
  \ ['n', '<LocalLeader>C', '<Plug>(nou-jump-current)'],
  \ ['n', '<LocalLeader>D', '<Plug>(nou-set-date-today)'],
  \ ['n', '<LocalLeader>E', '<Plug>(nou-fix-claimed)'],
  \ ['n', '<LocalLeader>T', '<Plug>(nou-set-time-now)'],
  \ ['n', '<LocalLeader>i', '<Plug>(nou-date-i)'],
  \ ['n', '<LocalLeader>I', '<Plug>(nou-datew-i)'],
  \ ['n', '<LocalLeader>L', '<Plug>(nou-spdx-header)'],
  \ ['nx','<LocalLeader>n', '<Plug>(nou-task-next)'],
  \ ['n', '<LocalLeader>N', '<Plug>(nou-jump-today)'],
  \
  \ ['n', '<LocalLeader>_', '<Plug>(nou-set-goal-subtodo)'],
  \ ['nx','<LocalLeader>!', '<Plug>(nou-set-goal-mandatory)'],
  \ ['n', '<LocalLeader>@', '<Plug>(nou-set-goal-today)'],
  \ ['n', '<LocalLeader>#', '<Plug>(nou-set-goal-rephrase)'],
  \ ['n', '<LocalLeader>+', '<Plug>(nou-set-goal-subdone)'],
  \ ['n', '<LocalLeader>>', '<Plug>(nou-set-goal-postpone)'],
  \ ['n', '<LocalLeader><', '<Plug>(nou-set-goal-delegated)'],
  \ ['n', '<LocalLeader>,', '<Plug>(nou-set-goal-waiting)'],
  \ ['n', '<LocalLeader>~', '<Plug>(nou-set-goal-likely)'],
  \ ['n', '<LocalLeader>?', '<Plug>(nou-set-goal-unlikely)'],
  \ ['n', '<LocalLeader>%', '<Plug>(nou-set-goal-partial)'],
  \ ['n', "<LocalLeader>'", '<Plug>(nou-set-goal-low)'],
  \ ['n', '<LocalLeader>"', '<Plug>(nou-set-goal-high)'],
  \ ['n', '<LocalLeader>.', '<Plug>(nou-set-goal-now)'],
  \ ['n', '<LocalLeader>;', '<Plug>(nou-set-goal-next)'],
  \ ['n', '<LocalLeader>:', '<Plug>(nou-set-goal-deferred)'],
  \ ['n', '<LocalLeader>0', '<Plug>(nou-set-goal-feed)'],
  \ ['n', '<LocalLeader>/', '<Plug>(nou-set-goal-progress)'],
  \
  \ ['n', '<LocalLeader><Backspace>', '<Plug>(nou-merge-plan)'],
  \ ['n', '<LocalLeader><Del>', '<Plug>(nou-del-status)'],
  \ ['n', '<LocalLeader><Tab>', '<Plug>(nou-complement)'],
  \ ['n', '<LocalLeader>w<Space>', '<Plug>(nou-del-assoc)'],
  \]


" NOTE: <assoc> :: easier to switch association "c<LL>ame<Esc>" -> "<LL>wm"
let s:nou_assoc =
  \[ 'a agenda A'
  \, 'b both W:both'
  \, 'c common W:common'
  \, 'd dev'
  \, 'e env'
  \, 'h home'
  \, 'i important I'
  \, 'k wakeup'
  \, 'l low'
  \, 'm me'
  \, 'n next'
  \, 'o overtime OT'
  \, 'p prevwork prev:W'
  \, 'r raw W:raw'
  \, 's sleep'
  \, 't travel'
  \, 'u urgent U'
  \, 'w work W'
  \, 'x misc'
  \, 'y daybreak'
  \, 'z dozeoff'
  \, '+ workjoin W+OT'
  \, '. worknow W'
  \]
" [_] TODO:(python): vim.command("nnoremap <buffer> <silent> ...")
"   BET: multiline to exec at once :: vim.eval() OR vim.exec_lua
for x in s:nou_assoc
  let m = split(x, ' ')
  let plug = '<Plug>(nou-set-assoc-'.m[1].')'
  exe 'nmap <buffer> '.plug.' c<Plug>(textobj-nou-assoc-i)'.m[-1].'<Esc>'
  let s:nou_mappings += [['n', '<LocalLeader>w'.m[0], plug]]
endfor



" Range-wise modifiers
for i in range(1,9)
  exe 'nnoremap <silent> <Plug>(nou-barX'.i.')'
    \.' :<C-u>call nou#bar("X'.i.'",'.i.',0)<CR>'
  let s:nou_mappings += [['n', '<LocalLeader>'.i, '<Plug>(nou-barX'.i.')']]
endfor
for s in ['', '_', '$', 'X', 'DX', '⪡', 'T', 'B', 'C']
  for m in ['n', 'x'] | exe m.'noremap <silent> <Plug>(nou-bar'.s.')'
      \" :<C-u>call nou#bar('".s."',v:count,".(m==#'x').")<CR>"
endfor | endfor

" [_] FIXME:(nou-barDB): must insert "done" by xts2 "day" instead of xts4 time
" [_] BET:TRY: <LocalLeader> = <Space>  OR:BET? [Xtref] = <Space>
" ALT(batch-ops for 'x'):TRY:USE: textobj#user#select() which returns list of positions
" OBSOLETE
" \ ['nx', '<LocalLeader>#', '<Plug>(nou-barD$)'],
" \ ['nx', '<LocalLeader>D', '<Plug>(nou-barD_)'],
" \ ['nx', '<LocalLeader>d', '<Plug>(nou-barD)'],
" \ ['n',  '<LocalLeader>^', '<Plug>(nou-barD<)'],
" \ ['nx', '<LocalLeader>T', '<Plug>(nou-barDT)'],
let s:nou_mappings += [
  \ ['x', '<LocalLeader><Del>', '<Plug>(nou-bar)'],
  \ ['nx', '<LocalLeader><Space>', '<Plug>(nou-bar_)'],
  \ ['nx', '<LocalLeader>$', '<Plug>(nou-bar$)'],
  \ ['nx', '<LocalLeader>x', '<Plug>(nou-barX)'],
  \ ['nx', '<LocalLeader>X', '<Plug>(nou-barDX)'],
  \ ['n',  '<LocalLeader>^', '<Plug>(nou-bar⪡)'],
  \ ['nx', '<LocalLeader>t', '<Plug>(nou-barT)'],
  \ ['nx', '<LocalLeader>b', '<Plug>(nou-barB)'],
  \ ['nx', '<LocalLeader>B', '<Plug>(nou-barC)'],
  \]

" TODO: <LL>rt -> replace on hours, <LL>rm -> replace on minutes ALT: "c<LL>:"
"   ALT: <LL>m/h -> directly set/replace minutes/hours (in contrast to <LL>t for whole time)
"     MAYBE: use count=[1..6] to convert into 10..60 minutes
"     ALSO? use count=[1..9] to set [10..19] hours, as I sleep inside [1h..5h] anyway ?
"   DEV: <LL>e -- evaluate and set elapsed time between entries


if exists('s:nou_mappings')
  for [modes, lhs, rhs] in s:nou_mappings
    for m in split(modes, '\zs')
      if empty(maparg(rhs, m))| echoe 'Err: no maparg='.rhs|continue |en
      if hasmapto(rhs, m)
        " FAIL: will ERR on each file reload
        " BET: silently ignore -- to allow user to remap <Plug> himself
        " echoe "Err: hasmapto=".rhs
        continue
      end
      if !empty(mapcheck(lhs, m))
        " FAIL: my own 'xmap' conflicts with textobj dfl 'vmap' keys
        "   << especially when you open second .nou file
        " echoe 'Err: exists='.lhs.' --> '.mapcheck(lhs, m)
        continue
      end
      exe m.'map <buffer><silent><unique>' lhs rhs
    endfor
  endfor
endif

runtime ftplugin/textobj/nou.vim

" FAIL: lazy loading + WTF? plugin loading order
"   TEMP: add directly to /@/airy/vim/cfg/plugins/environment.vim
" if exists('*altr#define')
" call altr#define(['%/key/%', '%/log/%', '%/key/*/%', '%/log/*/%'])
