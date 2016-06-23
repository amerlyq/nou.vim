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
