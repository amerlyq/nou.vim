" DEP:NEED: |kana/vim-textobj-user|

if exists('g:loaded_textobj_nou')| finish |endif
let g:loaded_textobj_nou = 1

let s:save_cpo = &cpo
set cpo&vim

" BAD: no way to enumerate all functions w/o codedupl or breaking lazy-loading
let s:keys =
  \[['line', 'L']
  \,['lead', 'i', 'I']
  \,['date', 'd', 'D']
  \,['goal', 's', 'S']
  \,['time', 't', 'T']
  \,['dura', 'e', 'E']
  \,['assoc','a', 'A']
  \,['mood', 'm', 'M']
  \,['tags', '#', '*']
  \,['text', 'b', 'B']
  \]

" BAD: no lazy-loading for spec-generation NEED: query if vim-textobj-user is present
fun! s:gen_textobj_spec(km)
  let spec = {}
  for x in a:km
    let [k, i, a] = [x[0], get(x,1,''), get(x,2,'')]
    let spec[k] = {}
    if len(i)
      let spec[k]['select-i'] = '<LocalLeader>'.i
      let spec[k]['select-i-function'] = 'nou#util#textobj_'.k.'_i'
    endif
    if len(a)
      let spec[k]['select-a'] = '<LocalLeader>'.a
      let spec[k]['select-a-function'] = 'nou#util#textobj_'.k.'_a'
    endif
  endfor
  return spec
endf

" HACK: define .nou text objects only if required dependency exists
try|call textobj#user#plugin('nou', s:gen_textobj_spec(s:keys))
catch /E117: Unknown function: textobj#user#plugin/|endtry

let &cpo = s:save_cpo
unlet s:save_cpo
