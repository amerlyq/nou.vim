" SEE: ⌇TU:nu
" Note: should not use augroup in ftdetect (see :help ftdetect)

" BAD: *.task overrides my ft despite having xtref at the top
au! BufRead,BufNewFile *.task set ft=nou

autocmd BufRead,BufNewFile {*.nou,TASK,20[0-9][0-9]-[0-1][0-9]-[0-3][0-9]*} if !did_filetype()|set ft=nou|en

" TODO: or first non-empty line should match [date]
let s:shebang = '\v^[\u2307][\u2800-\u28FF]{2,4}$'
au BufRead  *  if !did_filetype() && getline(1) =~# s:shebang|set ft=nou|en
