"" NOTE: loop on <CR> DEP: 'AndrewRadev/switch.vim'
"" IDEA: store addressing into file by @/todo/ctl and load back
"    $ grep -hEro '\@[[:upper:]]\w+(\.\w+)?' SU > addressings
"    FAIL:NEED: show autocomplete lists with suggestions
"    FIXME: rename old @/todo/log/201X/ entries '@<taskname>' -> '@ <taskname>'
" ----
" \   switch#Words(['one', 'two'])
" \   switch#NormalizedCase(['one', 'two']),
" \   switch#NormalizedCaseWords(['five', 'six']),

"" VIZ: artifacts
let nou#ext#switch#nou#groups =
  \[ ['^%', '^%%', '^%%%', '^%%%%', '^%%%%%']
  \, map(split('_@!', '\zs'), '"[".v:val."]"')
  \, map(split('+X…', '\zs'), '"[".v:val."]"')
  \, map(split('0123456789', '\zs'), '"[".v:val."0%]"')
  \, split('↻⋆↯💜', '\zs')
  \, split('~▶✓✗', '\zs')
  \, split('⚆◔◑◕🔚', '\zs')
  \, split('￬￪', '\zs')
  \, ['MAIL', '📩']
  \, ['CALL', '📲']
  \, split('0m 5m 10m 20m 30m 40m 50m')
  \, {'\v<(\d)h30m>': '\1.5h', '\v<(\d).5h>': '\1h30m'}
  \, map(split('me A add'), '"<".v:val.">"')
  \, map(split('W U env'), '"<".v:val.">"')
  \, map(split('next home sleep'), '"<".v:val.">"')
  \, map(split('eat tea coffee flax'), '"#body:".v:val')
  \, map(split('comics fantasy RSS'), '"#leisure:".v:val')
  \, map(split('tracking planning overview timesheet'), '"#taskmgmt:".v:val')
  \]
