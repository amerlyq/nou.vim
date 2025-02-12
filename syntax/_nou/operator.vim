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
" af/a4 = after  IDEA:(syntax combi): a4yyday="after the day before yesterday"
" bc = because (∵ <<)
" bf/b4 = before
" bnf = back'n'forth
" bw = between
" hwr/hwer = however
" iav = interactive[ly]
" iff = if and only if
" imm = immediate[ly]
" inat = in addition to
" inof = instead of
" iow = in other words
" ivt = invariant
" mo = modus operandi (method/practices of operating)
" no. = number
" orse = otherwise
" sa = sensu amplo (=in relaxed/generous/ample sense)
" sl = sensu lato (=in wide/broad sense)
" ss = sensu stricto (=strictly speaking)
" tba = to be available/accessible
" tf/t4 = therefore (∴ >>)
" tiac = take into account
" vs = versus (agst[against])
" wrt = with regard to
"" ALSO: .(by|same|like|and).
let s:ops = 'aka as b4 bnf bw cmp cvt due how-to hwr iav ifc iff imm inof iow orse t4 tf tmpl vs yday'
exe 'syn match nouOperatorDot display excludenl contains=@Spell,@nouAccentQ'
  \ '/\v%(^|[[:punct:][:blank:]]@1<=)%(' .substitute(s:ops, ' ', '|', 'g'). ')%(\ze[[:punct:][:blank:]]|$)/'
