
" Line-format has no sense for widechar lines, being treated as one long word
setl autoindent nocindent indentexpr=
setl expandtab tabstop=2 shiftwidth=2 softtabstop=2
" TEMP:(experimental) using text indented by one ' ' on any outline level
"   + intuitive support for embedded text paragraphs
"   - lose ability to align mixed-indented text
setl noshiftround
setl comments=b:#,b:#%,bO:\|,:¦,:│  ",f:'''
setl commentstring=#\ %s

setl synmaxcol=240
setl nowrap
setl conceallevel=2  " NEED=2: nouSpoiler uses 'cchar'

fun! FoldExprIndentBlock(lnum)
  let ln = getline(a:lnum)
  " FIXME: should properly expand <Tab> e.g. indent(ln)
  let ns = match(ln, '\S')
  let empty = ns < 0
  " let lvl = (ns + 1) / shiftwidth()
  let lvl = ns / shiftwidth() + 1
  let nextnonempty = getline(a:lnum + 1) =~ '\S'
  " HACK:(ns+1) fold even top-level blocks
  return ( !empty ? lvl : nextnonempty ? '<1' : 1 )
  " return ( empty && nextnonempty ? '<1' : 1 )
  " return ( !empty ? indent(a:lnum) + 1 : nextnonempty ? '<1' : 1 )
endf
setl foldmethod=expr foldexpr=FoldExprIndentBlock(v:lnum)
" setl foldlevel=99 foldmethod=indent

" NOTE: don't use any of "nv" -- to show nouSpoiler on cursor
"   * ALSO:BAD: irritating 'lag' on cursor move in line
"   * BUG="i" in deoplete.vim -- wrong cursor/menu position
setl concealcursor=""

" TODO: wrap into ":au nou" group
if !exists('b:switch_custom_definitions')
  let b:switch_custom_definitions = []
endif
let b:switch_custom_definitions += nou#ext#switch#nou#groups
