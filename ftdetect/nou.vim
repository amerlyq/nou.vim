" SEE: ⌇TU:nu
" Note: should not use augroup in ftdetect (see :help ftdetect)
autocmd BufRead,BufNewFile {*.nou,*.task,TASK,20[0-9][0-9]-[0-1][0-9]-[0-3][0-9]*} if !did_filetype()|set ft=nou|en

let s:shebang = '\v^[\u2307][\u2800-\u28FF]{2,4}$'
au BufRead  *  if !did_filetype() && getline(1) =~# s:shebang|set ft=nou|en
