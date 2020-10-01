""" Xtref

" NOTE:※⡟⡵⠪⡆ added xtref hi suppression
"   NICE: prevents from "italic,bold,underline" affecting xtrefs
hi def xtrefAnchor ctermfg=24 guifg=#005f87 cterm=NONE gui=NONE
exe 'syn match xtrefAnchor display excludenl containedin=ALL /\v'.nou#util#Rxtpin.'/'

hi def xtrefRefer ctermfg=35 guifg=#00af5f cterm=NONE gui=NONE
exe 'syn match xtrefRefer display excludenl containedin=ALL contains=xtrefReferPfx /\v'.nou#util#Rxtref.'/'

hi def xtrefReferPfx ctermfg=41 guifg=#3fcf5f cterm=NONE gui=NONE
exe 'syn match xtrefReferPfx display excludenl contained /\v'.strcharpart(nou#util#Rxtref, 0, 1).'/'
