""" Tag
syn cluster nouArtifactQ add=nouHashTag,nouConceptTag

" THINK: hashtags -- directly attached to words - EXPL: @some #tag &link

" Multiple: #(tag1,tag2,tag3) OR:(can't 'ga') #tag1,#tag2 BAD? #tag1#tag2
" [_] IDEA:TRY: raibow hi! (yellow-orange-red-purple) for chained #hash1#hash2#hash3
"   NEED: "nextgroup=" and body \S => [^#[:space:]]
" ALSO:MAYBE:CHG: allow only single '#' before tags

" MAYBE:USE: for &ref-tag
" hi nouHashTag cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=62 guifg=#5f5fdf

hi nouHashTag cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=142 guifg=#afaf00
syn match nouHashTag display excludenl contains=nouHashTagPfx,nouHashTagParam
  \ /\v%(^|[(\[{,;|[:space:]]@1<=)%([#]+\k\S{-})%([|;,}\])[:space:]]@1=|$)/


" OR:(standout): hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=130 guifg=#b86f00
" OR:(dark): hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=130 guifg=#af5f00
" OR:(bleak): hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=136 guifg=#af8700
" OR:(bright): hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=172 guifg=#df8700
" OR:(light): compromise
hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=136 guifg=#bf7f00
syn match nouHashTagPfx display excludenl contained '[#.]'

hi nouHashTagParam cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=101 guifg=#958e68
syn match nouHashTagParam display excludenl contained ':[^:#[:blank:]]\+'

hi nouHashTagList cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=95 guifg=#8f6f5f
syn match nouHashTagList display excludenl contained containedin=nouHashTagParam ','


""" Concepts
" [_] TRY:DEV: dereferencing by <g[> and <gf>
hi nouConceptTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=30 guifg=#008787
syn match nouConceptTagPfx display excludenl contained '[&]'

hi nouConceptTag cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=36 guifg=#00af87
syn match nouConceptTag display excludenl contains=nouConceptTagPfx,nouConceptTagParam
  \ /\v%(^|[(\[{,;|[:space:]]@1<=)%([&]+\k\S{-})%([|;,}\])[:space:]]@1=|$)/

hi nouConceptTagParam cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=66 guifg=#5f8787
syn match nouConceptTagParam display excludenl contained ':[^:&[:blank:]]\+'
