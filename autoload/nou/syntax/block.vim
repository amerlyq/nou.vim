""" Block
" NOTE: use different markers

"" DEV:
  " In VIM, is there any way to define syn region for template angle brackets without clashing with less than sign? - vim ⌇⡞⡮⡴⡜
  "   https://html.developreference.com/article/23759785/In+VIM%2C+is+there+any+way+to+define+syn+region+for+template+angle+brackets+without+clashing+with+less+than+sign%3F

" SEE: Syntax · google/re2 Wiki ⌇⡞⡮⡴⡧
"     https://github.com/google/re2/wiki/Syntax

" syn region nouBlock display keepend excludenl transparent contained extend fold
"   \ matchgroup=Special containedin=@nouOutlineQ
"   \ start='\v`{3}' end='\v`{3}'

" BUG: can't override single-word sentences as '^\s+clear::'
" ALT:("extend"): can be used to extend native outline color for whole block
"   BET: use it together with single trailing '\'
"     + it will be better than appending or prepending each line
"   WARN: w/o "extend" block contained inside outline is cropped to oneline
" FIXME: allow BlockRegions for top-level
" THINK:USE: transparent contains=NONE

" REF: Backreference for syntax region - Vi and Vim Stack Exchange ⌇⡞⡮⡴⠱
"   https://vi.stackexchange.com/questions/15391/backreference-for-syntax-region
" EXPL: end at any non-empty line that does not start with the saved indent group

hi nouBlockXmarker cterm=bold   gui=bold   ctermfg=33 guifg=#2060e0
hi nouBlockXformat cterm=italic gui=italic ctermfg=10 guifg=#586e75
hi nouBlockPlainText ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE

hi def link nouBlockAligned nouBlockPlainText
hi def link nouBlockIndented nouBlockPlainText
hi def link nouBlockContained nouBlockPlainText


syn match nouBlockXmarker display excludenl contained
  \ nextgroup=nouBlockXformat '[[:punct:]]\+'
syn match nouBlockXformat display excludenl contained
  \ nextgroup=nouBlockPlainText  '[[:alnum:]]\+'


" [_] CHECK: by using "excludenl" we don't need complex end=... expr with newline
"   i.e. check hi won't flicker and next headline after block won't lose hi


" THINK: contained containedin=@nouOutlineQ
" NOTE: use indent of first body line (after marker)
syn region nouBlockAligned keepend excludenl fold extend
  \ containedin=@nouOutlineQ
  \ matchgroup=nouBlockXmarker
  \ start='##\ze\s*\n\z(\s\+\)'
  \ end='\v\ze\n%(\s*$|\z1)@!'


" THINK:CHG:ENH:ADD: allow text on the same line as starting marker
"   || Text block,  ## Text block,  >> Text block,
"      continues       continues       continues
"   MAYBE:ALSO: in this case use color of first line instead of plain white
" NOTE: use indent of same line as marker (continuation)
syn region nouBlockIndented keepend excludenl fold extend
  \ containedin=@nouOutlineQ
  \ matchgroup=nouBlockXmarker
  \ start='^\z(\s*\).*\zs||\ze\s*$'
  \ end='\v\ze\n%(\s*$|\z1\s)@!'


" [_] BUG: trailing ":" conflicts with block marker "NICE: ::"
" TODO: for default "::" use lang from b:nou.blocksyntax = '..' OR reading from above in this file
" NOTE: use first matching indent between marker line and first body line (floating)
syn region nouBlockContained keepend excludenl fold extend
  \ containedin=@nouOutlineQ
  \ matchgroup=nouBlockXmarker
  \ start='^\z(\s*\).*\zs::\ze\s*\n\z(\s*\)'
  \ end='\v\ze\n%(\s*$|\z1\s|\z2)@!'


" TODO: lazy loading for any grepped filetypes (no need to pre-determine them in opts.vim)
" TRY: combine with nouBlockContained and use conditional nextgroup= to match filetype name
" ALT: use different highlight for filetype \ contains=nouBlockXmarker
"   BAD: nextgroup matches multiple times
syn region nouBlockSyntax_nou keepend excludenl fold extend
  \ contains=@nouTextQ containedin=@nouOutlineQ
  \ matchgroup=nouBlockXmarker
  \ start='^\z(\s*\).*\zs::\w\+\ze\s*\n\z(\s*\)'
  \ end='\v\ze\n%(\s*$|\z1\s|\z2)@!'


" HACK: embedded plain syntax e.g. (vim) or (gdb)
" CHECK: use ((vim)) as marker anywhere in line, not only in beginning
" MAYBE:USE: different standout colors for different langs groups (e.g. GREN for gdb)
hi nouLineSyntax_nou ctermbg=18 guibg=#061d2a cterm=italic gui=italic
hi nouLineXmarker ctermbg=18 guibg=#061d2a
  \ cterm=bold,reverse gui=bold,reverse  ctermfg=33 guifg=#2060e0

" BAD: "((vim))" in the middle of line is too different from "(vim)" in the beginning
"   MAYBE: conceal brackets or make fg=bg to hide symbol itself
"   BET? use square brackets ⦅⦃⦗｢⟦⟨⟪⟮⟬⌈⌊⦇⦉❨❪❴❬❮❰❲⦑⧼  vim ⦆⦄⦘｣⟧⟩⟫⟯⟭⌉⌋⦈⦊❩❫❵❭❯❱❳⦒⧽
"     e.g.  ⦃vim⦄ ⦅vim⦆ ⦇vim⦈ ⦉vim⦊ ⧼vim⧽
"   [⡞⣳⢪⣑] TEMP:USE: unicode braces everywhere and ascii ones only at linebeg
syn region nouLineSyntax_nou keepend excludenl extend
  \ containedin=@nouOutlineQ
  \ matchgroup=nouLineXmarker
  \ start='^\s*\zs(\w\+)'
  \ start='⦅\l\+⦆'
  \ end='$'


" THINK: concealends -> replace by some unusual unicode chars
"   -- MAYBE: completely hidden? for nice joining multiline
"   ``` some
"   text ```
"   BUT we lose nice block emphasis
"   some ```
"   nteee
"   ```
"   CHECK:(option?) compare two possible styles. Document both ways and their merits.
" BUG: conflicting/tearing syntax on up/down motion for text after closing ```
"   -- seems problem in transparent+containedin
" BUG: w/o 'matchgroup': closing '```' is concealed transparent rules of accent
"   -- Moreover -- we can't make something like oneline block (``` ... ```)
" BAD:(fold) don't work with 'fdm=indent'
" BUG:(display): when scroling from bottom -- last found closing ``` is treated as beginning
syn region nouBlockMarkdown keepend excludenl transparent fold extend
  \ matchgroup=Special containedin=@nouOutlineQ
  \ start='\v`{3}' end='\v`{3}'


""" Blocks
" plain text/notes/lists -- multiline

" THINK: colorized list
" -- make diff colors for items (prepended by '*', etc) on same outline level
"   e.g. slightly different background -- like in web/excel tables
" ?? nested lists -- indistinguishable bounds between lists
