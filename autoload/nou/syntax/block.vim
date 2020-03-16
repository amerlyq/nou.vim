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

hi nouBlockXmarker cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=33 guifg=#2060e0

hi nouBlock ctermbg=NONE guibg=NONE ctermfg=NONE guifg=NONE

" THINK: contained containedin=@nouOutlineQ
" syn region nouBlock keepend excludenl fold
"   \ matchgroup=nouBlockXmarker
"   \ start='\v::\s*\n^\z(\s+)'
"   \ end='\v^%(\z1|$)@!'

" NOTE: use indent of first body line (after marker)
" keepend excludenl fold
syn region nouBlockExtrusion containedin=@nouOutlineQ extend
  \ matchgroup=nouBlockXmarker
  \ start='::\s*\n^\z(\s\+\)'
  \ end='\v^%(\z1|$)@!'

" syn region nouBlock
"       \ start="\(>\||\) *\n^\z( \+\)"
"       \ end="^\(\z1\|$\)\@!"
"       \ contains=NONE
"

" NOTE: use indent of same line as marker (continuation)
syn region nouBlockContinuation containedin=@nouOutlineQ extend
  \ matchgroup=nouBlockXmarker
  \ start='^\z(\s*\).*\zs||\s*$'
  \ end='\v^%(\z1\s|$)@!'


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
syn region nouBlockMarkdown display keepend excludenl transparent contained extend fold
  \ matchgroup=Special containedin=@nouOutlineQ
  \ start='\v`{3}' end='\v`{3}'


""" Blocks
" plain text/notes/lists -- multiline

" THINK: colorized list
" -- make diff colors for items (prepended by '*', etc) on same outline level
"   e.g. slightly different background -- like in web/excel tables
" ?? nested lists -- indistinguishable bounds between lists
