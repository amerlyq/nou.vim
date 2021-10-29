
" SEE: ⌇TU:nu
au! BufRead,BufNewFile {*.task,TASK} set ft=nou

au BufRead,BufNewFile {*.nou,NOU} set ft=nou

au BufRead,BufNewFile  20[0-9][0-9]-[0-1][0-9]-[0-3][0-9]*  if !did_filetype()|set ft=nou|en

" ALT: '\v^'. g:xtref.r_anchor .'$'
let s:shebang = '\v^[\u2307][\u2800-\u28FF]{2,4}$'
au BufRead  *  if !did_filetype() && getline(1) =~# s:shebang|set ft=nou|en
