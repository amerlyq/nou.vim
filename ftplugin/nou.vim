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
setl comments=b:#,bO:\|,b:¦,b:│  ",f:'''
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
xnoremap <Plug>(nou-date) "=strftime('%Y-%m-%d')<CR>P
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


" TEMP:TRY:
nnoremap <silent> <Plug>(nou-state-subtask) :call nou#vsel_apply(0,{x->nou#util#replace('state','+',x)})<CR>
xnoremap <silent> <Plug>(nou-state-subtask) :<C-u>call nou#vsel_apply(1,{x->nou#util#replace('state','+',x)})<CR>

let s:nou_mappings = [
  \ ['nx', 'gf', '<Plug>(nou-path-open)'],
  \ ['nx', '<LocalLeader>n', '<Plug>(nou-task-next)'],
  \ ['nx', '<LocalLeader>i', '<Plug>(nou-date)'],
  \ ['n', '<LocalLeader>I', '<Plug>(nou-datew)'],
  \ ['n',  '<LocalLeader>L', '<Plug>(nou-spdx-header)'],
  \ ['nx', '<LocalLeader>+', '<Plug>(nou-state-subtask)'],
  \]


" Range-wise modifiers
for i in range(1,9)
  exe 'nnoremap <silent> <Plug>(nou-barX'.i.')'
    \.' :<C-u>call nou#bar("X'.i.'",'.i.',0)<CR>'
  let s:nou_mappings += [['n', '<LocalLeader>'.i, '<Plug>(nou-barX'.i.')']]
endfor
for s in ['', 'D', '_', 'D_', 'D$', '$', 'X', 'DX', 'T', 'B', 'DB'] | for m in ['n', 'x']
  exe m.'noremap <silent> <Plug>(nou-bar'.s.')'
      \" :<C-u>call nou#bar('".s."',v:count,".(m==#'x').")<CR>"
endfor | endfor

" [_] BET:TRY: <LocalLeader> = <Space>  OR:BET? [Xtref] = <Space>
let s:nou_mappings += [
  \ ['nx', '<LocalLeader><BS>', '<Plug>(nou-bar)'],
  \ ['nx', '<LocalLeader><Space>', '<Plug>(nou-bar_)'],
  \ ['nx', '<LocalLeader>d', '<Plug>(nou-barD)'],
  \ ['nx', '<LocalLeader>D', '<Plug>(nou-barD_)'],
  \ ['nx', '<LocalLeader>$', '<Plug>(nou-barD$)'],
  \ ['nx', '<LocalLeader>#', '<Plug>(nou-bar$)'],
  \ ['nx', '<LocalLeader>x', '<Plug>(nou-barDX)'],
  \ ['nx', '<LocalLeader>X', '<Plug>(nou-barX)'],
  \ ['nx', '<LocalLeader>t', '<Plug>(nou-barT)'],
  \ ['nx', '<LocalLeader>b', '<Plug>(nou-barB)'],
  \ ['nx', '<LocalLeader>B', '<Plug>(nou-barDB)'],
  \]


if exists('s:nou_mappings')
  for [modes, lhs, rhs] in s:nou_mappings
    for m in split(modes, '\zs')
      if mapcheck(lhs, m) ==# '' && maparg(rhs, m) !=# '' && !hasmapto(rhs, m)
        exe m.'map <buffer><silent><unique>' lhs rhs
      endif
    endfor
  endfor
endif

runtime ftplugin/textobj/nou.vim
