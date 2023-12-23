""" Artifacts

" ATT: define before accents, to suppress conflicts with |..|
hi! nouTableDelim cterm=bold ctermfg=172 gui=bold guifg=#d78700
syn cluster nouArtifactQ add=nouTableDelim
syn match nouTableDelim display excludenl '|'


"" ATT: placed before nouObjectPfx to override @Name.Surname
syn cluster nouArtifactQ add=nouArtifactAddressing
hi nouArtifactAddressing cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=80 guifg=#5fdfdf
syn match nouArtifactAddressing display excludenl
  \ '\v%(^|[(\[{,;|[:space:]]@1<=)%([@]+\k{-1,}%(\.\k{-1,})?%(\@[a-z.]+)?)%([|;,}\])[:space:]]@1=|$)'
hi nouArtifactAddrName cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=75 guifg=#67afff
syn match nouArtifactAddrName display excludenl contained containedin=nouArtifactAddressing /\v\@%(\k{-}\.|\u\u@1=)?/


"" user group OR role like <%dev>
syn cluster nouArtifactQ add=nouArtifactRole
hi nouArtifactRole cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=172 guifg=#df8700
syn match nouArtifactRole display excludenl /\v%(^|[(\[{,;|[:blank:]]@1<=)%(\%\a\k{-})%([|;,}\])[:blank:]]@1=|$)/


" ATT: define after artf_hashtag() to override #1 hashtag
" ALT: subgroups :: *Index{Hash,Dot,No,Braces,...}
" TRY: diff color :: nextgroup=nouPathBody
" BET? isolate by space :: \%(^\|[[:punct:][:blank:]]\@1<=\)...
" ALT: *Numero  '№'  BAD: incomplete font support -- and blades with next number
syn cluster nouArtifactQ add=nouArtifactIndex,nouArtifactAltMod,nouArtifactCount
hi nouArtifactIndex cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=172 guifg=#df8700
syn match nouArtifactIndex display excludenl '\v%([#]\d+>|\(\d+\))'
hi nouArtifactAltMod cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=142 guifg=#df4fbf
syn match nouArtifactAltMod display excludenl '\v%([%]\d+>|\{\d+\})'
hi nouArtifactCount cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE ctermfg=172 guifg=#df8700
syn match nouArtifactCount display excludenl '\v<x\d+>'



""" Objects :: comments, url, path

syn cluster nouGenericQ add=nouComment
hi def link nouComment Comment
syn region nouComment display oneline keepend excludenl
  \ start='\v%(^|\s\zs)\z([#]{1,4})\s' end='\v\s\z1%(\ze\s|$)' end='$'
syn match nouComment display excludenl '\v%(^|\s)\zs//\ze\s'

" NOTE: developer's documentation comments
syn cluster nouGenericQ add=nouCommentDevDoc
hi nouCommentDevDoc cterm=NONE gui=NONE ctermbg=8 guibg=#002430 ctermfg=242 guifg=#707070
syn region nouCommentDevDoc display oneline keepend
  \ start='^#%' start='\s\zs#%' excludenl end='$'

" NOTE: hi! dot-prefix of "obj.sub.key=val" and "obj.func()"
" ORNG: ctermfg=224 guifg=#cb4b16 YELW: ctermfg=121 guifg=#b58900 BLUE: ctermfg=33 guifg=#2060e0
" NICE: #c56b1f | #8f4f1f
syn cluster nouGenericQ add=nouObjectPfx
hi nouObjectPfx cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=224 guifg=#8f4f1f
syn match nouObjectPfx display excludenl
  \ '\v%(^|[[:punct:][:blank:]]@1<=)%(\k+[.])+\ze\k'


" EXPL: https, ftp, news, file
" THINK: diff color urls -- don't do 'contains=@nouArtifactG'
" TRY: different color for heading and '[/?=]' in url
hi! nouArtifactUrl cterm=underline ctermfg=62 gui=underline guifg=#6c71c4
syn cluster nouArtifactQ add=nouArtifactUrl
syn match nouArtifactUrl display excludenl
  \ '\v<%(\w{3,}://|www\.|%(mailto|javascript):)\S*'
" OR:(exclude trailing): \S{-}\ze%([[:blank:],)]|$)

" File-like urls override for direct download (.pdf, .md, .doc, ...)
hi! nouArtifactUrlFile cterm=underline ctermfg=27 gui=underline guifg=#005fff
syn cluster nouArtifactQ add=nouArtifactUrlFile
syn match nouArtifactUrlFile display excludenl
  \ '\v<%(\w{3,}://)\S{-}\.%(x?html?|php)@!\a{2,4}\ze%([[:blank:],)]|$)'

" " BUG: breaks '<' decision
" hi! nouPunct ctermfg=1 guifg=#ff0000
" syn cluster nouArtifactQ add=nouPunct
" syn match nouPunct display excludenl '[<>]'

" BAD: ignored after task marker [X] !~ \A+ or after any other 'decision'
"  => E.G. even '\v^%(\s{4})@<=\k+' isn't working
hi! nouArtifactVar cterm=bold ctermfg=9 gui=bold guifg=#df5f00
syn cluster nouArtifactQ add=nouArtifactVar
syn match nouArtifactVar display excludenl contains=nouArtifactVarPfx
  \ '\v%([$]\w+>|[$]\{\w+\}|[$]\(\w+\))'

hi nouArtifactVarPfx cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=9 guifg=#8f3f00
syn match nouArtifactVarPfx display excludenl contained '[$]'
