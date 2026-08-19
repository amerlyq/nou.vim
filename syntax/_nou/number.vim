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
syn match nouNumberDec display excludenl  '\v<%(0|[1-9]\d*)%(\.[0-9]+)?'
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


"" Numbers in URL
" WHY: to make it easier to visually compare column of urls to each other
" WHY: to visually find faster url in file matching to url tail in browser w/o copying

syn cluster nouDigits add=nouDigit0,nouDigit1,nouDigit2,nouDigit3,nouDigit4,nouDigit5,nouDigit6,nouDigit7,nouDigit8,nouDigit9


" ALT:BET? inof individual digits -- highlight whole triplets,
"   to simply have better boundaries to easier read long numbers
"   IDEA: #xyz, x - darkness, y - main color/hue, z - variance
" ALT: use only 4 colors -- for {0, 1-3, 4-6, 7-9}
syn match nouDigit0 display excludenl contained  '0'
syn match nouDigit1 display excludenl contained  '1'
syn match nouDigit2 display excludenl contained  '2'
syn match nouDigit3 display excludenl contained  '3'
syn match nouDigit4 display excludenl contained  '4'
syn match nouDigit5 display excludenl contained  '5'
syn match nouDigit6 display excludenl contained  '6'
syn match nouDigit7 display excludenl contained  '7'
syn match nouDigit8 display excludenl contained  '8'
syn match nouDigit9 display excludenl contained  '9'

hi! nouDigit0 guifg=#2aa198  " #6c71c4  " #555555
hi! nouDigit1 guifg=#dc322f  " #6cc184  " #870000
hi! nouDigit2 guifg=#859900  " #ccc184  " #00b700
hi! nouDigit3 guifg=#f27711  " #5271c4  " #af8700
hi! nouDigit4 guifg=#f7a3f7  " #df8700  " #2288cf
hi! nouDigit5 guifg=#7dbbf0  " #bc81c4  " #df0087
hi! nouDigit6 guifg=#b58900  " #bcb1b4  " #aaaaaa
hi! nouDigit7 guifg=#e9cf87  " #2c51c4  " #00cfcf
hi! nouDigit8 guifg=#5b9e84  " #6461c4  " #5f00cf
hi! nouDigit9 guifg=#f9a8b1  " #cc2124  " #9f0087
