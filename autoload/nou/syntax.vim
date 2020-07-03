""" Syntax helpers
" TODO:MOVE: all regexes in registry hive

" ATTENTION: don't use '/', avoid its escaping inside [..] range
fun! s:p(_, ...)
  let q = get(a:,1,'/')
  return q.'\v'.escape(a:_,q).q
endf
fun! s:ps(_)
  return '['.a:_.'[:blank:]]'
endf
fun! s:pb(_, ...)
  return s:p('%(^|'.s:ps(get(a:,1,'')).'@1<=)%('.a:_.')', get(a:,2,'/'))
endf
fun! s:pe(_, ...)
  return s:p('%('.a:_.')%('.s:ps(get(a:,1,'')).'@1=|$)', get(a:,2,'/'))
endf
fun! s:pbe(_, ...)
  return s:p('%(^|'.s:ps(get(a:,1,'')).'@1<=)%('.a:_.')%('.s:ps(get(a:,2,get(a:,1,''))).'@1=|$)', get(a:,3,'/'))
endf

fun! nou#syntax#_indent(i)
  " CHECK: if &ts used from current buffer or from script file
  let ind = '%(\t| {'.&ts.'}'.(g:nou.widesp ? "|\u3000" : '').')'
  let p = '^'
  if g:nou.deflvl > 0| let p .= '%('.ind.'{'.g:nou.deflvl.'})' |en
  if g:nou.cyclic > 0| let p .= '%('.ind.'{'.len(g:nou.outline.colors).'}){-}' |en
  let p .= '%('.ind .'{'. a:i .'})' . '\ze\S'
  return p
endf

fun! nou#syntax#_highlight(nm, c, ...)
  if a:c =~ '^#\x\+$'| let c = 'guifg='.a:c |else| let c = a:c |en
  " TODO: if =~ '\w\+' -> hi def link
  " CHECK: if used 'def link' -- can't change colors on fly w/o vim restart
  " BAD: don't work user override like with 'def link'
  exe 'hi! '. a:nm .' '. c .(a:0<1?'': ' '.a:1)
endf

fun! nou#syntax#outline(i)
  let nm = 'nouOutline'.a:i
  " THINK: don't use 'keepend/excludenl/oneline' to allow wrap multiline 'url'
  "   -- BUG: irritating EOF highlighting when typing opening accent
  " ENH:USE: ALL ALLBUT,{gr} TOP TOP,{gr} CONTAINED CONTAINED,{gr}
  exe 'syn cluster nouOutlineQ add='.nm
  exe 'syn region '.nm.' display keepend excludenl'
    \.' contains=@nouTextQ,@nouDelimQ,@nouDecisionQ'
    \.' start='.s:p(nou#syntax#_indent(a:i))
    \.' skip='.s:p('%('. g:nou.outline.wrapby .')$')
    \.' end='.s:p('$')
  call nou#syntax#_highlight(nm, g:nou.outline.colors[a:i])
endf

fun! nou#syntax#decision(i)
  let nm = 'nouDecision'.a:i
  let [s, c] = g:nou.decision.colors[a:i]
  exe 'syn cluster nouDecisionQ add='.nm.'m,'.nm.'u'
  exe 'syn region '.nm.'m display oneline keepend transparent'
    \.' excludenl matchgroup='.nm
    \.' start='.s:p('^\s*\zs\z('.s.')%(\d+)?\s@1=')
    \.' end='.s:p('\s\z1$').' end='.s:p('$')
  " FIXME: continue alternated highlight over g:nou.outline.wrapby
  exe 'syn region '.nm.'u display oneline keepend'
    \.' excludenl matchgroup='.nm
    \.' contains=@nouTextQ'
    \.' start='.s:p('^\s*\zs\z('.s.')%(\d+)?'.g:nou.decision.symbol.'\s')
    \.' end='.s:p('\s\z1$').' end='.s:p('$')
  call nou#syntax#_highlight(nm, c, 'gui=bold')
  call nou#syntax#_highlight(nm.'u', c, 'gui=italic')
endf

fun! nou#syntax#accent(k)
  let nm = 'nouAccent'.a:k
  let [s, c] = g:nou.accent.colors[a:k]
  let S = '[^[:blank:]'.s.']'
  exe 'syn cluster nouAccentQ add='.nm
  " concealends
  exe 'syn region '.nm.' display oneline keepend'
    \.' excludenl matchgroup=nouConceal contains=@Spell,@nouAccentQ'
    \.' start='.s:pb(s.'\ze'.S, '[:punct:]')
    \.' end='.s:pe(S.'\zs'.s, '[:punct:]')
  if c !~# '='| let c = 'cterm='.c.' gui='.c |en
  " BAD: everywhere-notches can mix italic of Comment with its own color, but
  "   accents -- can't MAYBE check hi! priority order -- must be different ?
  " ! NOTE(args) => italic -- treated as function but with overridden color
  " USE:TEMP: call matchadd('TAccent', '"[^"]\+"', -1) for all overlay accents to mix color and type
  let c = 'ctermfg=254 guifg=#e4e4e4 '.c
  call nou#syntax#_highlight(nm, '', c)
endf

fun! nou#syntax#term(k)
  let nm = 'nouTerm'.a:k
  let [b, e, c] = g:nou.term.colors[a:k]
  exe 'syn cluster nouTermQ add='.nm
  " TRY: always keep matchgroup syms the same color despite accents modifying colors inside them
  " BAD: but must support '("aaa")' and '"aaa",' BUT: prevent hi~ in "|--> f(p->buf)"
  exe 'syn region '.nm.' display oneline keepend '
    \.' excludenl matchgroup='.l:nm.' contains=@Spell,@nouAccentQ'
    \.' start='.s:pb(b.'\ze[^[:blank:]'.b.']', '[:punct:]')
    \.' skip='.s:p('\\\|')
    \.' end='.s:pe('[^[:blank:]'.e.']\zs'.e, '[:punct:]')
  if c !~# '='| let c = 'cterm='.c.' gui='.c |en
  let c = 'ctermfg=1 guifg=#ff0000 '.c
  call nou#syntax#_highlight(nm, '', c)
endf

fun! nou#syntax#art_delim(r)
  let nm = 'nouArtifactDelim'
  exe 'syn cluster nouArtifactQ add='.nm
  exe 'syn match '.nm.' display excludenl'
    \.' '.s:pbe(a:r)
  exe 'hi link '.nm.'  Special'
endf

fun! nou#syntax#header(i)
  let nm = 'nouHeader'.a:i
  let c = g:nou.header.colors[a:i]
  let s = repeat(g:nou.header.symbol,
    \ g:nou.header.ascending ? a:i + 1 : len(g:nou.header.colors) - a:i)
  exe 'syn cluster nouHeaderQ add='.nm
  " NOTE: if used '\zs' in '^\s*\zs\z(' -- will be rematched to outline
  exe 'syn region '.nm.' display oneline keepend excludenl concealends'
    \.' matchgroup=nouConceal contains=NONE'
    \.' start='.s:pb('\z('.s.')\s')
    \.' end='.s:pe('\s\z1').' end='.s:p('$')
  call nou#syntax#_highlight(nm, c, 'gui=bold,inverse')
endf

fun! nou#syntax#delimit(i)
  let nm = 'nouDelimit'.a:i
  let [s, c] = g:nou.delimit.colors[a:i]
  exe 'syn cluster nouDelimQ add='.nm
  exe 'syn match '.nm.' display excludenl contains=NONE '
    \.s:p('(^|\s)\zs['.s.']{5,}\ze(\s|$)')
  " ALT:(pseudo-random) color =~ charcode % 16
  call nou#syntax#_highlight(nm, c)
endf

fun! nou#syntax#embed_load(ft)
  let nm = 'nouEmbedQ_'.a:ft
  let main_syntax = get(b:, 'current_syntax', '')
  " EXPL: remove all previously embedded syntax groups (sole method)
  " syntax clear | let &syntax = main_syntax
  if a:ft ==# ''| return |en
  " EXPL: load even syntax files with single-time loading guards
  if exists('b:current_syntax')| unlet b:current_syntax |en
  " BUG: embedded syntax expects start-of-line '^' -- but there placed '\d:\d:'
  try|exe 'syn include @'.nm.' syntax/'.a:ft.'.vim'      |catch/E403\|E484/|endtry
  try|exe 'syn include @'.nm.' after/syntax/'.a:ft.'.vim'|catch/E403\|E484/|endtry
  let b:current_syntax = main_syntax
  if empty(b:current_syntax)| unlet b:current_syntax |en
endf

fun! nou#syntax#embedded(ft)
  let nm = 'nouEmbed_'.a:ft
  let [b, e] = g:nou.embed[a:ft]
  let brgx = '\v%(^|\s)\zs'.b.'\s'

  " PERF: enable only if syntax is present in file
  " FAIL: must reload file when new syntax is added for the first time
  " MAYBE: check pattern for any inserted/pasted text ?
  " BUG: nouNumber starts overriding nouTask
  if !search(brgx,'nw') | return | en

  exe 'syn cluster nouEmbedQ add='.nm
  exe 'syn region '.nm.' display excludenl extend'
    \.' matchgroup=nouComment contains=@nouEmbedQ_'.a:ft
    \.' start='.s:p(brgx)
    \.' end='.s:p('\s'.e.'\ze%(\s|$)').' end='.s:p('\\@1<!$')
  call nou#syntax#embed_load(a:ft)
  " call nou#syntax#_highlight(nm, '#990000')
endf

fun! nou#syntax#regex()
  let nm = 'nouRegex'
  let s = '[[:blank:]/]'
  let S = '[^[:blank:]/]'
  " DEV: syntax hi! for class, number, range, special
  " DEV: delimiter (reuse from path)
  exe 'syn cluster nouArtifactQ add='.nm
  exe 'syn cluster '.nm.'Q contains='.nm.'C,'.nm.'N,'.nm.'R,'.nm.'S'
  " NOTE:(limitation) instead of first/last ' ' use '\s' or '\ '
  exe 'syn region '.nm.' display oneline keepend excludenl'
    \.' contains=@'.nm.'Q'
    \.' matchgroup='.nm.'D'
    \.' start='.s:pbe('/\ze%([^/]|\\@1<=/)+/', ',', ',', '~')
    \.' end='.s:pe('\S\zs/', ',', '~')
    " \.' skip='.s:p('\\\s', '~')

  exe 'syn match '.nm.'C display excludenl contained '.s:p('\\\a|:\a+:')
  exe 'syn match '.nm.'N display excludenl contained '.s:p('\\?[+*{,}]')
  exe 'syn match '.nm.'R display excludenl contained '.s:p('\\?[-[\]]')
  exe 'syn match '.nm.'S display excludenl contained '.s:p('\\?[()%]|\\z\S')

  let bg = ' ctermfg=23 guibg=#002060 '
  exe 'hi '.nm.'   ctermfg=224 guifg=#ffd7d7'.bg.'cterm=italic gui=italic'
  exe 'hi '.nm.'D  ctermfg=1   guifg=#dc322f'.bg.'cterm=bold gui=bold'
  exe 'hi '.nm.'N  ctermfg=9   guifg=#cb4b16'.bg
  exe 'hi '.nm.'S  ctermfg=6   guifg=#2aa198'.bg
  exe 'hi '.nm.'C  ctermfg=40  guifg=#00d700'.bg
  exe 'hi '.nm.'R  ctermfg=69  guifg=#5f87ff'.bg
endf

fun! nou#syntax#artf_ext()
  let nm = 'nouArtifactExt'
  exe 'syn cluster nouArtifactQ add='.nm
  exe 'syn match '.nm.' display excludenl'
    \.' '.s:pbe('[*%]?[._][[:alnum:]~#][[:alnum:]._~#]*', '(\[{,;|', '[:punct:]')
  let B = ' cterm=bold ctermbg=NONE gui=bold guibg=NONE '
  exe join(['hi', nm, B, 'ctermfg=177 guifg=#df87ff'])
endf

fun! nou#syntax#artf_hashtag()
  let nm = 'nouArtifactHashTag'
  exe 'syn cluster nouArtifactQ add='.nm
  " [_] IDEA:TRY: raibow hi! (yellow-orange-red-purple) for chained #hash1#hash2#hash3
  " ALSO:MAYBE:CHG: allow only single '#' before tags
  exe 'syn match '.nm.' display excludenl'
    \.' '.s:pbe('#+\k\S{-}', '(\[{,;|', '|;,}\])')
  let B = ' cterm=bold ctermbg=NONE gui=bold guibg=NONE '
  exe join(['hi', nm, B, 'ctermfg=142 guifg=#afaf00'])
  " exe join(['hi', nm, B, 'ctermfg=62 guifg=#5f5fdf'])
endf

fun! nou#syntax#artf_addressing()
  let nm = 'nouArtifactAddressing'
  exe 'syn cluster nouArtifactQ add='.nm
  exe 'syn match '.nm.' display excludenl'
    \.' '.s:pbe('\@\a\S{-}', '(\[{,;|', '|;,}\])')
  let B = ' cterm=bold,italic ctermbg=NONE gui=bold,italic guibg=NONE '
  exe join(['hi', nm, B, 'ctermfg=80 guifg=#5fdfdf'])
endf

fun! nou#syntax#artf_contact()
  let nm = 'nouArtifactContact'
  exe 'syn cluster nouArtifactQ add='.nm
  let lst = 'irc|skype|mail'
  exe 'syn match '.nm.' display excludenl'
    \.' '.s:pbe('('.lst.'):#+\w\S{-}', '(\[{,;|', '|;,}\])')
  let B = ' cterm=bold ctermbg=NONE gui=bold guibg=NONE '
  exe join(['hi', nm, B, 'ctermfg=28 guifg=#005f5f'])
endf

" FIXME: nested function inside @nouSpoilerQ
fun! nou#syntax#artf_function()
  let nm = 'nouArtifactFunction'
  exe 'syn cluster nouArtifactQ add='.nm
  exe 'syn region '.nm.' display oneline excludenl extend'
    \.' excludenl matchgroup='.nm.'H'
    \.' contains='.nm
    \.' start='.s:p('\k+\(')
    \.' end='.s:p('\)')
    " \.' end='.s:p('\ze\{\+')
    " \.' skip='.s:p('\\\s', '~')
  let B = ' cterm=underline ctermbg=NONE gui=underline,italic guibg=NONE '
  exe join(['hi', nm.'H', B, 'ctermfg=33 guifg=#3087ff'])
  exe join(['hi', nm, B, 'ctermfg=10 guifg=#688e95'])
endf
