""" Infix / Mood / Emoji

syn cluster nouArtifactQ add=@nouArtifactEmojiQ
" SEE: https://emojipedia.org/red-heart/
" VIZ: green=💚 yellow=💛 orange=🧡 brown=🤎 purple=💜 blue=💙 white=🤍♡ black=🖤♥ spark=💖 broken=💔 two=💕 glow=💗 jap=心
" IDEA: prio-emoji: "↥↑⮬⤉⤒⮭￪🔝🢙🮸⮉" | "⮎↪↓⮮⮯￬🮷⮋" | "￩𐇙￫⮩⮫⮊⭮⥁➺➲➛⌁⇴⇝↝→🔜"
syn cluster nouArtifactEmojiQ add=nouEmojiRed
hi nouEmojiRed cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=196 guifg=#ff0000
syn match nouEmojiRed display excludenl '[✗♡♥🤍🖤💛💜🔝‼😠]'

syn cluster nouArtifactEmojiQ add=nouEmojiGreen
hi nouEmojiGreen cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=40 guifg=#00ff00
syn match nouEmojiGreen display excludenl '[✓➺⊞➕☺]'

" #1060ff #6060ff #87afff #87dfff
syn cluster nouArtifactEmojiQ add=nouEmojiBlue
hi nouEmojiBlue cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=117 guifg=#87dfff
syn match nouEmojiBlue display excludenl '[↯⁃😄]'

" SPLIT: rename "syn match" to "nouInfix" and "hi link" to nouEmoji colors
" nouInfix(source/intent) {{{
syn cluster nouArtifactEmojiQ add=nouEmojiOrange
hi nouEmojiOrange cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=172 guifg=#df8700
syn match nouEmojiOrange display excludenl '[⋆⇴🔜⁇☹]'

syn cluster nouArtifactEmojiQ add=nouEmojiGray
hi nouEmojiGray cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=242 guifg=#707070
syn match nouEmojiGray display excludenl '[↻📲📩↓🔚終]'

syn cluster nouArtifactEmojiQ add=nouEmojiPurple
hi nouEmojiPurple cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=61 guifg=#5f5faf
syn match nouEmojiPurple display excludenl '[ᚹ]'

syn cluster nouArtifactEmojiQ add=nouEmojiPink
hi nouEmojiPink cterm=NONE ctermbg=NONE gui=NONE guibg=NONE ctermfg=161 guifg=#df1f5f
syn match nouEmojiPink display excludenl '[≈▶➥±]'
" }}}
