""" Operators (= think about RDF / Semantic Web predicates)

syn cluster nouTermQ add=nouOperatorDot,nouOperatorDotH

" BUG: not higlighted as first arg to list e.g. … (.like. smth)
" MAYBE: reduce scope to /\s[.]\w+[.]\s/ == only match space-surrounded
hi def nouOperatorDot cterm=bold gui=bold ctermfg=74 guifg=#1fafdf
syn match nouOperatorDot display excludenl contains=@Spell,@nouAccentQ
  \ /\v%(^|[[:punct:][:blank:]]@1<=)[.][^[:blank:].]\S*[^[:blank:].][.]%(\ze[[:punct:][:blank:]]|$)/

" ALSO: .(by|same|like|and|agst[against]|because).
" bnf=back'n'forth
" iow=in other words
" iav=interactive[ly]
let s:ops = 'vs as bw b4 t4 iff imm inof orse iow due cmp cvt aka how-to yday ifc tmpl iav'
exe 'syn match nouOperatorDot display excludenl contains=@Spell,@nouAccentQ'
  \ '/\v%(^|[[:punct:][:blank:]]@1<=)%(' .substitute(s:ops, ' ', '|', 'g'). ')%(\ze[[:punct:][:blank:]]|$)/'

hi def nouOperatorDotH cterm=bold gui=bold ctermfg=81 guifg=#5fdfff
syn match nouOperatorDotH display excludenl contains=@Spell,@nouAccentQ
  \ /\v%(^|[[:punct:][:blank:]]@1<=)[.]{2}\zs[^[:blank:].]\S*[^[:blank:].]\ze[.]{2}%([[:punct:][:blank:]]|$)/
