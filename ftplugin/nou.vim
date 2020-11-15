" BUG: loaded 3 times -- verify by wild echo
if exists("b:did_ftplugin")| finish |else| let b:did_ftplugin = 1 |endif
let b:undo_ftplugin = "setl ai< cin< inde< ts< sw< sts< com< cms< fdm< cole< cocu< wrap<"
call nou#opts#init()

" Line-format has no sense for widechar lines, being treated as one long word
setl autoindent nocindent indentexpr=
setl tabstop=2 shiftwidth=2 softtabstop=2
" TEMP:(experimental) using text indented by one ' ' on any outline level
"   + intuitive support for embedded text paragraphs
"   - lose ability to align mixed-indented text
setl noshiftround
setl comments=b:#,b:#%,bO:\|,b:¦,b:│  ",f:'''
setl commentstring=#\ %s

setl nowrap
setl foldmethod=indent
setl conceallevel=2  " NEED=2: nouSpoiler uses 'cchar'

" NOTE: don't use any of "nv" -- to show nouSpoiler on cursor
"   * ALSO:BAD: irritating 'lag' on cursor move in line
"   * BUG="i" in deoplete.vim -- wrong cursor/menu position
setl concealcursor=""


" digraph ,. 8230  " … =DFL somewhere in vim path
" digraph *1 9734  " ☆ =DFL generic feature
" digraph *2 9733  " ★ =DFL favorite feature
digraph @@ 9764    " ☤  dev repo (aura/**)
digraph @# 9798    " ♆  program/package configuration (airy/*)
digraph (( 10629   " ⦅ = nouLineSyntax
digraph )) 10630   " ⦆ = nouLineSyntax
digraph ** 8226    " •
digraph *  8226    " •


""" Mappings

" nnoremap <silent> <Plug>(nou-date) :<C-u>put=strftime('%Y-%m-%d')<CR>
nnoremap <Plug>(nou-date) "=strftime('%Y-%m-%d')<CR>P
" xnoremap <Plug>(nou-date) "=strftime('%Y-%m-%d')<CR>P
nnoremap <Plug>(nou-datew) "=strftime('%Y-%m-%d-%a-W%V')<CR>P
inoremap <Plug>(nou-date) <C-R>=strftime('%Y-%m-%d')<CR>

" THINK:BET:USE: `dts` like in Wolfram
inoreab <buffer><expr> !dts! strftime('%Y-%m-%d')

" SEE: https://www.thetopsites.net/article/58187038.shtml
" BAD: substitute(getline('.'), '^\s*\zs['.a:sym.']\ze $', a:rpl, '')
" ALSO: https://www.reddit.com/r/vim/comments/blw37i/expanding_abbreviations_through_a_cr_expression/
" BET?⌇⡟⢁⠉⠠ https://vi.stackexchange.com/questions/24791/how-to-create-an-abbreviation-with-space
" ALT: https://vi.stackexchange.com/questions/20962/is-it-possible-to-supply-arguments-to-inoremap/20966#20966
function! s:lead_correct(sym, rpl)
  let pfx = getline('.')[:col('.') + 1]
  " DEBUG: echom '|'.getline('.').v:char.'|'
  let y = (v:char == ' ') && (trim(pfx) == a:sym)
  return y ? a:rpl : a:sym
endfunction
" ALT: inoreab <buffer> . <C-r>=<sid>lead_correct('.', '•')<CR>
" FAIL: inoreab <buffer><expr> \<Space>\<Space>.\<Space> "  • "
" [_] FAIL: enlarges first dot in "^   ..."
" FAIL: abbrevs insert into beg of line "I.<Esc>"
inoreab <buffer><expr> . <sid>lead_correct('.', '•')


" [_] FAIL: path with spaces is cropped e.g. "@/so\ me/" OR "⋮@/so me/⋮"
nnoremap <silent> <Plug>(nou-path-open) :call nou#path_open(expand('<cWORD>'))<CR>
xnoremap <silent> <Plug>(nou-path-open) :<C-u>call nou#path_open(nou#vsel())<CR>

nnoremap <silent> <Plug>(nou-task-next) :call setreg('/', '\v'.nou#util#Rtodo, 'c')<CR>n
xnoremap <silent> <Plug>(nou-task-next) :<C-u>call setreg('/', '\v%V'.nou#util#Rtodo, 'c')<CR>n

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
  py import datetime as DT
  " INFO:ALT:FAIL: strftime('%s', iso) don't support iso8601
  let ts = pyeval('int(DT.datetime.fromisoformat("'.iso.'").timestamp())')
  " DEBUG: echo iso.' --> '.ts
  let xts = substitute(printf('%08x', ts), '..', '\=nr2char("0x28".submatch(0))', 'g')
  call setreg(get(a:,1,'+'), xts, 'c')
endf
nnoremap <buffer> <Plug>(nou-task-xts-beg) :call <SID>yank_xts(0)<CR>
nnoremap <buffer> <Plug>(nou-task-xts-end) :call <SID>yank_xts(1)<CR>

" ALT:
"   nnoremap <silent> <Plug>(nou-set-goal-subdone) :call nou#vsel_apply(0,{x->nou#util#replace('state','+',x)})<CR>
"   xnoremap <silent> <Plug>(nou-set-goal-subdone) :<C-u>call nou#vsel_apply(1,{x->nou#util#replace('state','+',x)})<CR>
" WF:NOTE:(<LL>[_+>]): immediately convert to subtask (i.e. set indent=2)
nmap <buffer> <Plug>(nou-cvt-subtask) d<Plug>(textobj-nou-time-i)c<Plug>(textobj-nou-lead-i)<Space><Space><Esc>3l
nmap <buffer> <Plug>(nou-set-goal-mandatory) c<Plug>(textobj-nou-goal-i)!<Esc>
nmap <buffer> <Plug>(nou-set-goal-today) c<Plug>(textobj-nou-goal-i)@<Esc>

" NOTE: cvt to subtask is useful for *flat* log, but NOT for workflow-structured one
"   c<Plug>(textobj-nou-goal-i)+<Esc><Plug>(nou-cvt-subtask)
nmap <buffer> <Plug>(nou-set-goal-subtodo) c<Plug>(textobj-nou-goal-i)_<Esc>
nmap <buffer> <Plug>(nou-set-goal-subdone) c<Plug>(textobj-nou-goal-i)+<Esc>
nmap <buffer> <Plug>(nou-set-goal-postpone) c<Plug>(textobj-nou-goal-i)><Esc>

" nmap <buffer> <Plug>(nou-set-goal-todo) c<Plug>(textobj-nou-goal-i)_<Esc>
" omap <buffer> <Plug>(nou-set-goal-todo) <Plug>(textobj-nou-goal-i)_<Esc>

nmap <buffer> <Plug>(nou-del-status) d<Plug>(textobj-nou-status-i)
nmap <buffer> <Plug>(nou-del-plan) d<Plug>(textobj-nou-plan-i)
" FAIL: can't apply multiple times to visual selection
nmap <buffer> <Plug>(nou-cvt-task) d<Plug>(textobj-nou-lead-i)c<Plug>(textobj-nou-goal-i)_<Esc>

" DISABLED: I never expect to convert subtask to task
"   ['n', '<LocalLeader><Space>', '<Plug>(nou-cvt-task)'],
"   ['n', '<LocalLeader><Space>', '<Plug>(nou-set-goal-todo)'],
let s:nou_mappings = [
  \ ['nx', 'gf', '<Plug>(nou-path-open)'],
  \ ['n', '<LocalLeader>yx', '<Plug>(nou-task-xts-beg)'],
  \ ['n', '<LocalLeader>yX', '<Plug>(nou-task-xts-end)'],
  \ ['nx', '<LocalLeader>n', '<Plug>(nou-task-next)'],
  \ ['n', '<LocalLeader>i', '<Plug>(nou-date)'],
  \ ['n', '<LocalLeader>I', '<Plug>(nou-datew)'],
  \ ['n',  '<LocalLeader>L', '<Plug>(nou-spdx-header)'],
  \ ['n', '<LocalLeader>_', '<Plug>(nou-set-goal-subtodo)'],
  \ ['n', '<LocalLeader>!', '<Plug>(nou-set-goal-mandatory)'],
  \ ['n', '<LocalLeader>@', '<Plug>(nou-set-goal-today)'],
  \ ['n', '<LocalLeader>+', '<Plug>(nou-set-goal-subdone)'],
  \ ['n', '<LocalLeader>>', '<Plug>(nou-set-goal-postpone)'],
  \ ['n', '<LocalLeader><Backspace>', '<Plug>(nou-del-status)'],
  \ ['n', '<LocalLeader><Del>', '<Plug>(nou-del-plan)'],
  \]


" Range-wise modifiers
for i in range(1,9)
  exe 'nnoremap <silent> <Plug>(nou-barX'.i.')'
    \.' :<C-u>call nou#bar("X'.i.'",'.i.',0)<CR>'
  let s:nou_mappings += [['n', '<LocalLeader>'.i, '<Plug>(nou-barX'.i.')']]
endfor
for s in ['', 'D', '_', 'D_', 'D$', '$', 'X', 'DX', 'D<', 'T', 'DT', 'B', 'DB']
  for m in ['n', 'x'] | exe m.'noremap <silent> <Plug>(nou-bar'.s.')'
      \" :<C-u>call nou#bar('".s."',v:count,".(m==#'x').")<CR>"
endfor | endfor

" [_] BET:TRY: <LocalLeader> = <Space>  OR:BET? [Xtref] = <Space>
" ALT(batch-ops for 'x'):TRY:USE: textobj#user#select() which returns list of positions
let s:nou_mappings += [
  \ ['x', '<LocalLeader><Del>', '<Plug>(nou-bar)'],
  \ ['nx', '<LocalLeader><Space>', '<Plug>(nou-bar_)'],
  \ ['nx', '<LocalLeader>d', '<Plug>(nou-barD)'],
  \ ['nx', '<LocalLeader>D', '<Plug>(nou-barD_)'],
  \ ['nx', '<LocalLeader>$', '<Plug>(nou-bar$)'],
  \ ['nx', '<LocalLeader>#', '<Plug>(nou-barD$)'],
  \ ['nx', '<LocalLeader>x', '<Plug>(nou-barX)'],
  \ ['nx', '<LocalLeader>X', '<Plug>(nou-barDX)'],
  \ ['n',  '<LocalLeader><', '<Plug>(nou-barD<)'],
  \ ['nx', '<LocalLeader>t', '<Plug>(nou-barT)'],
  \ ['nx', '<LocalLeader>T', '<Plug>(nou-barDT)'],
  \ ['nx', '<LocalLeader>b', '<Plug>(nou-barB)'],
  \ ['nx', '<LocalLeader>B', '<Plug>(nou-barDB)'],
  \]


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
