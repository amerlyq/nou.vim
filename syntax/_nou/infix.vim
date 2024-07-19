""" Infix / Mood / Emoji

syn cluster nouArtifactQ add=@nouArtifactEmojiQ
" SEE: https://emojipedia.org/red-heart/
" VIZ: green=💚 yellow=💛 orange=🧡 brown=🤎 purple=💜 blue=💙 white=🤍♡ black=🖤♥ spark=💖 broken=💔 two=💕 glow=💗 jap=心
" IDEA: prio-emoji: "↥↑⮬⤉⤒⮭￪🔝🢙🮸⮉" | "⮎↪↓⮮⮯￬🮷⮋" | "￩𐇙￫⮩⮫⮊⭮⥁➺➲➛⌁⇴⇝↝→🔜"
syn cluster nouArtifactEmojiQ add=nouEmojiRed
hi nouEmojiRed ctermfg=196 guifg=#ff0000
syn match nouEmojiRed display excludenl '[✗♡♥🤍🖤💛💜🔝‼😠🍰]'

syn cluster nouArtifactEmojiQ add=nouEmojiGreen
hi nouEmojiGreen ctermfg=40 guifg=#00ff00
syn match nouEmojiGreen display excludenl '[✓➺⊞➕☺👟]'

" #6060ff #87afff #87dfff
syn cluster nouArtifactEmojiQ add=nouEmojiCyan
hi nouEmojiCyan ctermfg=117 guifg=#87dfff
syn match nouEmojiCyan display excludenl '[⁃😄💎]'

syn cluster nouArtifactEmojiQ add=nouEmojiBlue
hi nouEmojiBlue ctermfg=117 guifg=#1060ff
syn match nouEmojiBlue display excludenl '[↯]'

" SPLIT: rename "syn match" to "nouInfix" and "hi link" to nouEmoji colors
" nouInfix(source/intent) {{{
syn cluster nouArtifactEmojiQ add=nouEmojiOrange
hi nouEmojiOrange ctermfg=172 guifg=#df8700
syn match nouEmojiOrange display excludenl '[⋆⇴🔜⁇☹🌠]'

syn cluster nouArtifactEmojiQ add=nouEmojiGray
hi nouEmojiGray ctermfg=242 guifg=#707070
syn match nouEmojiGray display excludenl '[↻📲📩↓🔚終🌵]'

syn cluster nouArtifactEmojiQ add=nouEmojiPurple
hi nouEmojiPurple ctermfg=61 guifg=#5f5faf
syn match nouEmojiPurple display excludenl '[ᚹ⋄☘]'

syn cluster nouArtifactEmojiQ add=nouEmojiPink
hi nouEmojiPink ctermfg=161 guifg=#df1f5f
syn match nouEmojiPink display excludenl '[≈▶➥±⚠]'

syn cluster nouArtifactEmojiQ add=nouEmojiGold
hi nouEmojiGold ctermfg=101 guifg=#958e68
syn match nouEmojiGold display excludenl '[⫽]'

" }}}
