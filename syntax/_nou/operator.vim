""" Operators (= think about RDF / Semantic Web predicates)

syn cluster nouTermQ add=nouOperatorDot,nouOperatorDotH

" BUG: not higlighted as first arg to list e.g. … (.like. smth)
" MAYBE: reduce scope to /\s[.]\w+[.]\s/ == only match space-surrounded
hi def nouOperatorDot cterm=bold gui=bold ctermfg=74 guifg=#1fafdf
syn match nouOperatorDot display excludenl contains=@Spell,@nouAccentQ
  \ /\v%(^|[[:punct:][:blank:]]@1<=)[.][^[:blank:].]\S*[^[:blank:].][.]%(\ze[[:punct:][:blank:]]|$)/

hi def nouOperatorDotH cterm=bold gui=bold ctermfg=81 guifg=#5fdfff
syn match nouOperatorDotH display excludenl contains=@Spell,@nouAccentQ
  \ /\v%(^|[[:punct:][:blank:]]@1<=)[.]{2}\zs[^[:blank:].]\S*[^[:blank:].]\ze[.]{2}%([[:punct:][:blank:]]|$)/


" VIZ:SRC: Latin/abbrev ※⡧⢵⣘⠨
let s:ops = 'aka as b4 bnf bw cmp cvt due ef[ie]-y evg evels how-to hwr iav ifc iff imm inof iow orse rec t4 tf tbato tmpl vs yday'
exe 'syn match nouOperatorDot display excludenl contains=@Spell,@nouAccentQ'
  \ '/\v%(^|[[:punct:][:blank:]]@1<=)%(' .substitute(s:ops, ' ', '|', 'g'). ')%(\ze[[:punct:][:blank:]]|$)/'
