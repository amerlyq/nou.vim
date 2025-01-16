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


"" Latin/abbrev※⡧⢈⢟⠢ SEE https://en.wikipedia.org/wiki/List_of_Latin_abbreviations
" af = after
" bc = because (∵ <<)
" bf/b4 = before
" bnf = back'n'forth
" bw = between
" iav = interactive[ly]
" iff = if and only if
" imm = immediate[ly]
" inat = in addition to
" inof = instead of
" iow = in other words
" mo = modus operandi (method/practices of operating)
" orse = otherwise
" no. = number
" sa = sensu amplo (=in relaxed/generous/ample sense)
" sl = sensu lato (=in wide/broad sense)
" ss = sensu stricto (=strictly speaking)
" tf/t4 = therefore (∴ >>)
" tiac = take into account
" vs = versus (agst[against])
" wrt = with regard to
"" ALSO: .(by|same|like|and).
let s:ops = 'vs as bw b4 tf t4 iff imm inof orse iow due cmp cvt aka how-to yday ifc tmpl iav'
exe 'syn match nouOperatorDot display excludenl contains=@Spell,@nouAccentQ'
  \ '/\v%(^|[[:punct:][:blank:]]@1<=)%(' .substitute(s:ops, ' ', '|', 'g'). ')%(\ze[[:punct:][:blank:]]|$)/'
