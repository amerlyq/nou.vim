""" Groups (inline enumerations)

syn cluster nouArtifactQ add=@nouGroupQ
syn cluster nouGroupQ add=nouGroup1,nouGroup2,nouGroup3,nouGroup4

" FIXED(me=): path highlight must stop before trailing ')]'
"   ALT:BAD: hi "matchgroup=Comment" uses fixed colors instead of context ones

syn region nouGroup1 display oneline keepend excludenl contained transparent
  \ start='('ms=s+1 skip='\\)' end=')'me=e-1

syn region nouGroup2 display oneline keepend excludenl contained transparent
  \ start='\['ms=s+1 skip='\\\]' end='\]'me=e-1

syn region nouGroup3 display oneline keepend excludenl contained transparent
  \ start='{'ms=s+1 skip='\\}' end='}'me=e-1

syn region nouGroup4 display oneline keepend excludenl contained transparent
  \ start='<'ms=s+1 skip='\\>' end='>'me=e-1
