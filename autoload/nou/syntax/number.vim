""" Numbers
syn cluster nouArtifactQ add=@nouNumberQ


"" Hex data elements
syn cluster nouNumberXdataQ add=nouNumberXmin,nouNumberXmax
  \,nouNumberXlow,nouNumberXpri,nouNumberXhgh
  \,nouNumberXodd,nouNumberXprf

syn match nouNumberXodd display excludenl contained  '\x'
syn match nouNumberXhgh display excludenl contained  '\x\x'
syn match nouNumberXlow display excludenl contained  '[0-1]\x'
syn match nouNumberXpri display excludenl contained  '[2-7]\x'
syn match nouNumberXmax display excludenl contained  '[fF][fF]'
syn match nouNumberXmin display excludenl contained  '00'
" FIXME: hi! unpaired digit at beginning
" syn match nouNumberXodd display excludenl contained  '\v\x\ze%(\x\x)+'

hi! nouNumberXmin ctermfg=250 guifg=#bbbbbb
hi! nouNumberXmax ctermfg=131 guifg=#993333
hi! nouNumberXlow ctermfg=28  guifg=#008800
hi! nouNumberXpri ctermfg=137 guifg=#aa8822
hi! nouNumberXhgh ctermfg=69  guifg=#2288cf
hi! nouNumberXodd ctermfg=196 guifg=#ff0000 gui=bold


"" Systems
syn cluster nouNumberQ add=nouNumberHex,nouNumberBin
  \,nouNumberOct,nouNumberDec,nouNumberXdata,nouNumberXaddr

" TODO: allow '-/+' before numbers BUT: skip spans like 0x..-0x..
syn match nouNumberDec display excludenl  '\v<(0|[1-9]\d*)>'
" syn match nouNumberFPU display excludenl   '\<\d\+\(\.\d*\)\=\(e[-+]\=\d*\)\=\>'
syn match nouNumberOct display excludenl  '\v<(0\o+o?|\o+o)>'
syn match nouNumberBin display excludenl  '\v<(0b[01]+|[01]+b)>'
syn match nouNumberHex display excludenl  '\v<(0x\x{,7}|\d\x{,6}h)>'
" ATT: any hex-only 8+ letter words are hex numbers
"   http://www.nsftools.com/tips/HexWords.htm
" BAD: conflicts
"   long decimal numbers 1234567890
"   compact dates e.g. 20170628
" BUG: /\v<\x+>/ wrongly detects hex word border
syn match nouNumberXdata display excludenl contains=@nouNumberXdataQ
  \ '\v%(^|\W)\zs%(0x)?\x{8,}h?:@!\ze%(\W|$)'

hi! nouNumber ctermfg=39 guifg=#00afff
hi def link nouNumberBin  nouNumber
hi def link nouNumberHex  nouNumber
hi def link nouNumberOct  nouNumber
hi def link nouNumberDec  nouNumber
hi def link nouNumberXdata  nouNumberXodd


"" Hex address category
syn cluster nouNumberXaddrQ add=nouNumberXprf,nouNumberXnil,nouNumberXsfx

syn match nouNumberXnil display excludenl contained  '0'
syn match nouNumberXsfx display excludenl contained  ':'
"" ATT: must be after all pieces to override partial matches
syn match nouNumberXprf display excludenl contained  '0x\|h'

hi! nouNumberXnil ctermfg=102 guifg=#878787
hi! nouNumberXsfx ctermfg=208 guifg=#ff8700
hi def link nouNumberXprf Comment

syn match nouNumberXaddr display excludenl contains=@nouNumberXaddrQ
  \ '\v%(^|\W)\zs%(0x)?\x{8,}:\ze%(\s|$)'
hi def link nouNumberXaddr  nouNumber
