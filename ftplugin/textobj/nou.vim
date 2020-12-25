" DEP:NEED: |kana/vim-textobj-user|

if exists('g:loaded_textobj_nou')| finish |endif
let g:loaded_textobj_nou = 1

let s:save_cpo = &cpo
set cpo&vim

" [_] NEED:DEV: operator <c r> to overwrite "goal" and "time" on top of existing
"   << reduce number of clicks e.g. keep tail ":00" for time (but delete hours)
"   [_] ENH: accept only single char for "goal" and switch to normal mode after that
" [_] ALT: allow to insert "6c<SP>t" -> "6:00" (instead of 6<SP>t)

" BAD: no way to enumerate all functions w/o codedupl or breaking lazy-loading
" TEMP:(prevent conflict): 'lead' {'<Space>', '<Backspace>'} => {'^' '0'}
" [_] BET:DEV: <LL><Backspace> incrementally delete <count> first elements (i.e. indent, goal, time, etc...)
" INFO:free: $ printf '%b\n' $(printf '\\x%x\n' {33..126}) | grep -vxFf <(:Y SS |cut -c2)
"   !"$%&'()+-./0123456789:;=?@FJKNOQRUVW[\]^_`fjklnoqruvw{|}~
let s:keys =
  \[['line', 'L']
  \,['lead', '<Del>', '<Backspace>', 'indent']
  \,['date', 'd', 'D']
  \,['goal', 'g', 'G']
  \,['time', 't', 'T']
  \,['infix', 'i', 'I']
  \,['dura', 'e', 'E', 'elapsed / estimated']
  \,['assoc','a', 'A']
  \,['mood', 'm', 'M']
  \,['tags', '#', '*']
  \,['text', 'b', 'B']
  \,['status', 'x', 'X', 'date + goal']
  \,['plan', 'p', 'P', 'status + time']
  \,['span', 's', 'S', 'time + dura']
  \,['slot', '', '', 'status + span']
  \,['task', 'h', 'H', 'slot + assoc']
  \,['meta', 'c', 'C', 'mood + tags = ctx']
  \,['actx', '<', '>', 'assoc + meta']
  \,['body', 'y', 'Y', 'meta + text']
  \,['entry', 'z', 'Z', 'task + body']
  \]


" BAD: no lazy-loading for spec-generation NEED: query if vim-textobj-user is present
fun! s:gen_textobj_spec(km)
  let spec = {}
  for x in a:km
    let [k, i, a] = [x[0], get(x,1,''), get(x,2,'')]
    let spec[k] = {}
    if !empty(i)| let spec[k]['select-i'] = '<LocalLeader>'.i |endif
    if !empty(a)| let spec[k]['select-a'] = '<LocalLeader>'.a |endif
    let spec[k]['select-i-function'] = 'nou#util#textobj_'.k.'_i'
    let spec[k]['select-a-function'] = 'nou#util#textobj_'.k.'_a'
  endfor
  return spec
endf

" HACK: prevent textobj from creating 'vmap' conflicting with <Plug>(nou-bar*)
" let g:textobj_nou_no_default_key_mappings = 1

" HACK: define .nou text objects only if required dependency exists
try|call textobj#user#plugin('nou', s:gen_textobj_spec(s:keys))
catch /E117: Unknown function: textobj#user#plugin/|endtry

" NOTE: manually define only 'omap' objects, w/o default 'xmap' ones
" for x in s:keys
"   let m = 'o'
"   for k in [1,2]
"     if empty(get(x,k))| continue |en
"     let lhs = '<LocalLeader>'.get(x,k)
"     let rhs = '<Plug>(textobj-nou-'. x[0] .'-'.(k==1?'i':'a').')'

"     if empty(maparg(rhs, m))| echoe 'Err: no maparg='.rhs|continue |en
"     if hasmapto(rhs, m)| continue |end
"     if !empty(mapcheck(lhs, m))
"       echoe 'Err: exists='.lhs.' --> '.mapcheck(lhs, m)
"       continue
"     end
"     echom m.'map <buffer><silent><unique>' lhs rhs
"   endfor
" endfor

" FIXED: prevent deleting char under cursor on partial keyseq: d<Space><Esc>
onoremap <silent><buffer><unique> <LocalLeader> <Nop>

let &cpo = s:save_cpo
unlet s:save_cpo
