""" Tag

" THINK: hashtags -- directly attached to words - EXPL: @some #tag &link

" Multiple: #(tag1,tag2,tag3) OR:(can't 'ga') #tag1,#tag2 BAD? #tag1#tag2
" [_] IDEA:TRY: raibow hi! (yellow-orange-red-purple) for chained #hash1#hash2#hash3
"   NEED: "nextgroup=" and body \S => [^#[:space:]]
" ALSO:MAYBE:CHG: allow only single '#' before tags

" MAYBE:USE: for &ref-tag
" hi nouHashTag cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=62 guifg=#5f5fdf

syn cluster nouArtifactQ add=nouHashTag
hi nouHashTag cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=142 guifg=#afaf00
syn match nouHashTag display excludenl /\v%(^|[(\[{,;|[:space:]]@1<=)%([#]+\k\S{-})%([|;,}\])[:space:]]@1=|$)/


" OR:(standout): hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=130 guifg=#b86f00
" OR:(dark): hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=130 guifg=#af5f00
" OR:(bleak): hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=136 guifg=#af8700
" OR:(bright): hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=172 guifg=#df8700
" OR:(light): compromise
hi nouHashTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=136 guifg=#bf7f00
syn match nouHashTagPfx display excludenl contained containedin=nouHashTag '[#.]'

hi nouHashTagParam cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=101 guifg=#958e68
syn match nouHashTagParam display excludenl contained containedin=nouHashTag keepend ':[^:#[:blank:]]\+'

hi nouHashTagList cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=95 guifg=#8f6f5f
syn match nouHashTagList display excludenl contained containedin=nouHashTagParam ','

hi nouHashTagValue cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=58 guifg=#6f6842
syn match nouHashTagValue display excludenl contained containedin=nouHashTagParam '=[^=,]\+'


""" ProjectToken / UrlAlias
" e.g. <^JIRA-12345>
" [_] MAYBE:SEP: differentiate UrlAlias (dereferencable) and TagToken (fuzzymatch)
syn cluster nouArtifactQ add=nouPjTag
hi nouPjTag cterm=bold,reverse ctermbg=NONE gui=bold,reverse guibg=NONE ctermfg=62 guifg=#6c71c4
syn match nouPjTag display excludenl /\v%(^|[(\[{,;|[:blank:]]@1<=)%(\^\S{-1,})%([|;,}\])[:blank:]]@1=|$)/

" ALT: 59=#5f5f5f
hi nouPjPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=20 guifg=#1f2fcf
syn match nouPjPfx display excludenl contained containedin=nouPjTag '\V^'


""" Concepts
" [_] TRY:DEV: dereferencing by <g[> and <gf>
syn cluster nouArtifactQ add=nouConceptTag
hi nouConceptTagPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=30 guifg=#008787
syn match nouConceptTagPfx display excludenl contained '[&]'

hi nouConceptTag cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=36 guifg=#00af87
syn match nouConceptTag display excludenl contains=nouConceptTagPfx,nouConceptTagParam
  \ '\v%(^|[(\[{,;|[:space:]]@1<=)%([&]+\k\S{-})%([|;,}\])[:space:]]@1=|$)'

hi nouConceptTagParam cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=66 guifg=#5f8787
syn match nouConceptTagParam display excludenl contained ':[^:&[:blank:]]\+'
