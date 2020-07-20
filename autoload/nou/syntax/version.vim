""" Version
syn cluster nouArtifactQ add=nouVersion


" ALT: syn match nouVersion display excludenl /\v%(^|[(\[{,;|[:blank:]]@1<=)%([!]\S{-1,})%([|;,}\])[:blank:]]@1=|$)/
" hi def link nouVersion nouKeyvalXkey
hi nouVersion cterm=bold,italic,underline gui=bold,italic,underline ctermbg=NONE guibg=NONE ctermfg=64  guifg=#5f8700
syn region nouVersion display oneline keepend excludenl
  \ matchgroup=nouVersionPfx
  \ contains=nouVersionCmp
  \ start='\%(^\|[[:punct:][:blank:]]\@1<=\)[!]\ze[[:alpha:]]'
  \ end='\ze,\s'
  \ end='\ze,$'
  \ end='\ze[[:blank:]]'
  \ end='$'


" LIKE(*bold*): ctermfg=240 guifg=#586e75
" LIKE(./path): hi nouVersionPfx cterm=bold,italic,underline gui=bold,italic,underline ctermbg=9   guibg=#073642 ctermfg=79  guifg=#5fd7af
" LIKE(func()): hi nouVersionPfx cterm=bold,italic,underline gui=bold,italic,underline ctermbg=NONE guibg=NONE ctermfg=33 guifg=#3087ff
" OLD: hi nouVersionPfx cterm=bold,italic,underline gui=bold,italic,underline ctermbg=NONE guibg=NONE ctermfg=79  guifg=#5fd7af
" hi nouVersionPfx cterm=bold,italic gui=bold,italic ctermbg=NONE guibg=NONE ctermfg=79  guifg=#5fd7af
hi nouVersionPfx cterm=bold,italic,underline gui=bold,italic,underline ctermbg=NONE guibg=NONE ctermfg=34  guifg=#005f00


" NOTE:(~>): https://thoughtbot.com/blog/rubys-pessimistic-operator
" hi def link nouVersionCmp nouKeyvalXkey
" hi def link nouVersionCmp nouPathXdelim
" hi nouVersionCmp cterm=italic gui=italic,underline ctermbg=NONE guibg=NONE ctermfg=34  guifg=#00af00
hi nouVersionCmp cterm=italic,underline gui=italic,underline ctermbg=NONE guibg=NONE ctermfg=142  guifg=#afbf00
syn match nouVersionCmp display excludenl contained nextgroup=nouVersionValue '[<>=!~‥]\{1,2}'


" hi def link nouVersionValue nouKeyval
hi nouVersionValue cterm=italic,underline ctermbg=NONE gui=italic,underline guibg=NONE ctermfg=10 guifg=#688e95
syn match nouVersionValue display excludenl contained '[^<>=!~‥]\+'
