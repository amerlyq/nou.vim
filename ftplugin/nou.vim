if exists("b:did_ftplugin")| finish |else| let b:did_ftplugin = 1 |endif
let b:undo_ftplugin = "setl ts< sw<"
call nou#opts#init()

" Line-format has no sense for widechar lines, being treated as one long word
setl autoindent nocindent indentexpr=
setl tabstop=2 shiftwidth=2 softtabstop=2
" setl comments=s:#,e:#,b:#,b::,b:~,:\|,
setl commentstring=#\ %s

setl foldmethod=indent
setl conceallevel=3

" EXPL:(commented) irritating cursor lags when moving in line
" setl concealcursor=nv
" EXPL:BUG: in insert with opened deoplete.vim menu -- wrong cursor position
" -- same as w/o conceal -- if text concealed is on the left of cursor
" setl concealcursor=i
setl concealcursor=""


""" Mappings
nnoremap <silent> <Plug>(nou-bar)   :<C-u>call nou#bar('',v:count,1)<CR>
nnoremap <silent> <Plug>(nou-bar_)  :<C-u>call nou#bar('_',v:count,1)<CR>
nnoremap <silent> <Plug>(nou-barX)  :<C-u>call nou#bar('X',v:count,1)<CR>
nnoremap <silent> <Plug>(nou-bar$)  :<C-u>call nou#bar('$',v:count,1)<CR>

let s:nou_mappings = [
  \ ['nx', '<LocalLeader><Space>', '<Plug>(nou-bar_)'],
  \ ['nx', '<LocalLeader><BS>', '<Plug>(nou-bar)'],
  \ ['nx', '<LocalLeader>x', '<Plug>(nou-barX)'],
  \ ['nx', '<LocalLeader>$', '<Plug>(nou-bar$)'],
  \]

if exists('s:nou_mappings')
  for [modes, lhs, rhs] in s:nou_mappings
    for m in split(modes, '\zs')
      if mapcheck(lhs, m) ==# '' && maparg(rhs, m) !=# '' && !hasmapto(rhs, m)
        exe m.'map <silent>' lhs rhs
      endif
    endfor
  endfor
endif
