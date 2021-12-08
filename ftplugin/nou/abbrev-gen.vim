
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
  let y = (v:char == ' ') && (trim(pfx) ==# a:sym)
  return y ? a:rpl : a:sym
endfunction
" ALT: inoreab <buffer> . <C-r>=<sid>lead_correct('.', '•')<CR>
" FAIL: inoreab <buffer><expr> \<Space>\<Space>.\<Space> "  • "
" [_] FAIL: enlarges first dot in "^   ..."
" FAIL: abbrevs insert into beg of line "I.<Esc>"
inoreab <buffer><expr> . <sid>lead_correct('.', '•')
