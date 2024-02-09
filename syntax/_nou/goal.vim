""" Task Goal && Progress

" syn cluster nouTaskQ contains=NONE
syn cluster nouTextQ add=@nouTaskQ

hi! nouXts ctermfg=238 guifg=#384e45
syn match nouXts display excludenl containedin=@nouTaskQ contains=@NoSpell '[\u2800-\u28FF]\{2,4\}'

"" ATT: must be after nouNumber to override date
" DISABLED: too bright checkbox is distracting
" hi! nouTaskTodo ctermfg=15 guifg=#beeeee
hi! nouTaskTodo ctermfg=14 guifg=#586e75
syn cluster nouTaskQ add=nouTaskTodo
syn match nouTaskTodo display excludenl '\V[_]'

" MAYBE:ADD: inprogress/ongoing "[o]"

hi! nouTaskWait cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=169 guifg=#ef3f9f
syn cluster nouTaskQ add=nouTaskWait
syn match nouTaskWait display excludenl '\V[…]'

hi! nouTaskDone ctermfg=14 guifg=#586e75
syn cluster nouTaskQ add=nouTaskDone
syn match nouTaskDone display excludenl '\V[X]'
syn match nouTaskDone display excludenl '\v\[[\u2800-\u28FF]{2}\]'  " day
syn match nouTaskDone display excludenl '\v\[[\u2800-\u28FF]{4}\]'  " ts


" Overlap/Overlay/During
hi! nouTaskOverlap ctermfg=101 guifg=#958e68
syn cluster nouTaskQ add=nouTaskOverlap
syn match nouTaskOverlap display excludenl '\V[/]'


"" MAYBE:
" gui=reverse,bold
" hi! nouTaskDoneB ctermfg=14 guifg=#586e75
" syn match nouTaskDoneB display excludenl contained
"   \ containedin=nouTaskDone '[[\]]'


""" ALT: separate xts group
" " hi! nouTaskXts cterm=bold gui=bold ctermfg=14 guifg=#586e75
" hi! nouTaskXts ctermfg=14 guifg=#586e75
" syn cluster nouTaskQ add=nouTaskXts
" syn match nouTaskXts display excludenl '\v\[[\u2800-\u28FF]{4}\]'

hi! nouTaskFrame cterm=bold gui=bold ctermfg=14 guifg=#586e75
syn cluster nouTaskQ add=nouTaskFrame
syn match nouTaskFrame display excludenl '\[[∞◦‣%,#🔒🔑￪￬⟫≫^]\]'
syn match nouTaskFrame display excludenl '\v\[[∞◦‣%,#🔒🔑￪￬⟫≫*^][\u2800-\u28FF]{2,4}\]'
syn match nouTaskFrame display excludenl '\v\[[*][_%]?\]'

hi! nouTaskFeed cterm=bold gui=bold ctermfg=251 guifg=#c6c6c6
syn match nouTaskFeed display excludenl contained containedin=nouTaskFrame '[∞◦]'

hi! nouTaskPartial cterm=bold gui=bold ctermfg=32 guifg=#0087df
syn match nouTaskPartial display excludenl contained containedin=nouTaskFrame '%'

hi! nouTaskAggregate cterm=bold gui=bold ctermfg=62 guifg=#5f5fdf
syn match nouTaskAggregate display excludenl contained containedin=nouTaskFrame '\V*'

" hi! nouTaskNext cterm=bold gui=bold ctermfg=226 guifg=#d8d800
hi! nouTaskNext cterm=bold gui=bold ctermfg=251 guifg=#c6c6c6
syn match nouTaskNext display excludenl contained containedin=nouTaskFrame '‣'

" RENAME? nouTaskAmend
hi! nouTaskRephrase cterm=bold gui=bold ctermfg=148 guifg=#afdf00
syn match nouTaskRephrase display excludenl contained containedin=nouTaskFrame '#'

hi! nouTaskBlockedBy ctermfg=148 guifg=#afdf00
" OR: syn match nouTaskBlockedBy display excludenl contained containedin=nouTaskFrame '\V[🔒]'
syn match nouTaskBlockedBy display excludenl contained containedin=nouTaskFrame '🔒'

" ALT: unlocking, enabling, keytask, chainstart
hi! nouTaskUnlocking cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=172 guifg=#df8700
syn match nouTaskUnlocking display excludenl contained containedin=nouTaskFrame '🔑'

hi! nouTaskDelegated ctermfg=169 guifg=#ef3f9f
syn match nouTaskDelegated display excludenl contained containedin=nouTaskFrame '⟫'

hi! nouTaskDeferred ctermfg=27 guifg=#1f6fff
syn match nouTaskDeferred display excludenl contained containedin=nouTaskFrame '≫'

hi! nouTaskOverachieved cterm=bold gui=bold ctermfg=46 guifg=#00ff00
" hi! nouTaskOverachieved cterm=bold gui=bold ctermbg=NONE guibg=NONE ctermfg=20 guifg=#1f2fcf
syn match nouTaskOverachieved display excludenl contained containedin=nouTaskFrame '\V^'

" cterm=bold gui=bold
" hi! nouTaskBringFwd ctermfg=46 guifg=#00ff00
" hi! nouTaskBringFwd ctermfg=27 guifg=#1f6fff
hi! nouTaskBringFwd ctermfg=148 guifg=#bfcf00
syn match nouTaskBringFwd display excludenl contained containedin=nouTaskFrame '[￪,]'

hi! nouTaskPushBwd ctermfg=196 guifg=#ff0000
syn match nouTaskPushBwd display excludenl contained containedin=nouTaskFrame '￬'


hi! nouTaskNow cterm=bold gui=bold ctermfg=251 guifg=#c6c6c6
syn cluster nouTaskQ add=nouTaskNow
syn match nouTaskNow display excludenl '\V[•]'
syn match nouTaskNow display excludenl '\v\[•[\u2800-\u28FF]{2,4}\]'

hi! nouTaskMandatory cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=196 guifg=#ff0000
syn cluster nouTaskQ add=nouTaskMandatory
syn match nouTaskMandatory display excludenl '\V[!]'

hi! nouTaskToday cterm=bold ctermbg=NONE gui=bold guibg=NONE ctermfg=172 guifg=#df8700
syn cluster nouTaskQ add=nouTaskToday
syn match nouTaskToday display excludenl '\V[@]'

hi! nouTaskCancel ctermfg=88 guifg=#870000
syn cluster nouTaskQ add=nouTaskCancel
syn match nouTaskCancel display excludenl '\[[$✗]\]'
syn match nouTaskCancel display excludenl '\v\[[$✗][\u2800-\u28FF]{2,4}\]'

hi! nouTaskFailed ctermfg=196 guifg=#ff0000
syn match nouTaskFailed display excludenl contained containedin=nouTaskCancel '✗'

hi! nouTaskAlso ctermfg=22 guifg=#1f881f
syn cluster nouTaskQ add=nouTaskAlso
syn match nouTaskAlso display excludenl '\v\[[+✓][_%]?\]'
syn match nouTaskAlso display excludenl '\v\[[+✓][\u2800-\u28FF]{2,4}\]'
syn match nouTaskOverachieved display excludenl contained containedin=nouTaskAlso '\V✓'

hi! nouTaskPostpone ctermfg=62 guifg=#5f5fdf
syn cluster nouTaskQ add=nouTaskPostpone
syn match nouTaskPostpone display excludenl '\V[>]'
syn match nouTaskPostpone display excludenl '\v\[\>[\u2800-\u28FF]{2,4}\]'

hi! nouTaskDoneBefore ctermfg=94 guifg=#875f00
syn cluster nouTaskQ add=nouTaskDoneBefore
syn match nouTaskDoneBefore display excludenl '\V[<]'
syn match nouTaskDoneBefore display excludenl '\v\[⪡[\u2800-\u28FF]{2,4}\]'

" [_] FIXME: instead of "cluster" use nested items and universal "\V[\.]" task
hi! nouTaskLikely ctermfg=169 guifg=#ef3f9f
syn cluster nouTaskQ add=nouTaskLikely
syn match nouTaskLikely display excludenl '\V[~]'

hi! nouTaskUnlikely ctermfg=172 guifg=#df8700
syn cluster nouTaskQ add=nouTaskUnlikely
syn match nouTaskUnlikely display excludenl '\V[?]'



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" Progress
" HACK: different yellowish/rainbow color for incomplete tasks /[01-99%]/
for i in keys(g:nou.task.colors)
  exe 'hi! nouTaskProgress'.i .' '. g:nou.task.colors[i]
  exe 'syn cluster nouTaskQ add=nouTaskProgress'.i
  exe 'syn match nouTaskProgress'.i.' display excludenl contains=nouProgressTotal "\v\['.i.'\d%(\.\d+)?\%%(\ze/\d+)?\]"'
endfor

hi def link nouTaskProgressDone nouTaskDone
syn cluster nouTaskQ add=nouTaskProgressDone
syn match nouTaskProgressDone display excludenl contains=nouProgressTotal "\v\[XX\%%(\ze/\d+)?\]"

" IDEA: use Total suffix for all tasks to specify allocated/spent/expected resources
"   e.g. [⡟⣌⢅⠰/214] [X/214] [+/2h/214] [_/4h] [$/2h]
hi! nouProgressTotal ctermfg=14 guifg=#586e75
syn match nouProgressTotal display excludenl contained '/\d\+'

syn cluster nouGenericQ add=nouTask
hi! nouTask ctermfg=14 guifg=#586e75
syn match nouTask display excludenl contains=@nouTaskQ
  \ '\v%(\d{4}-\d\d-\d\d )?\[%(X|[^[:alnum:]]|[\u2800-\u28FF]{2,4}|\d\d%(\.\d+)?\%%(/\d+)?)\]'


"{{{ NOTE: progress highlight e.g. "[1/8]"
" TRY:DEV: convert ratio to percent and highlight the same as above 5..95%
"   FAIL:NEED conditional hi! (?Idris dependent types?)
" MAYBE:BET: add "progress" cluster globally insted of limiting into nouTaskQ
syn cluster nouTaskQ add=nouProgressRatio
exe 'hi! nouProgressRatio '. g:nou.task.colors[8]
syn match nouProgressRatio display excludenl contains=@nouProgressRatioQ '\v\[%(\d+[:/+\\])?\d+%(\.\d+)?[/⁄]\d+\]'

"" WARN: must be above "nouProgressRatioF" for [1/1] to highlight as "finished"
exe 'hi! nouProgressRatio1 '. g:nou.task.colors[1]
syn cluster nouProgressRatioQ add=nouProgressRatio1
syn match nouProgressRatio1 display excludenl contained '\D1\D\d\+\D'

hi! nouProgressRatioF ctermfg=14 guifg=#586e75
syn cluster nouProgressRatioQ add=nouProgressRatioF
syn match nouProgressRatioF display excludenl contained '\v\D(\d+%(\.\d+)?)[/⁄]\1\D'

exe 'hi! nouProgressRatio0 '. g:nou.task.colors[7]
syn cluster nouProgressRatioQ add=nouProgressRatio0
syn match nouProgressRatio0 display excludenl contained '\D0\+\D\d\+\D'
"}}}

"{{{ NOTE: spent time progress e.g. "[1h30m/4h|6h]" OR "[-/-]"
" [_] ENH: make it more arbitrary i.e. support anything in shape of delimiters "[…/…|…]"
syn cluster nouTaskQ add=nouProgressTime
exe 'hi! nouProgressTime '. g:nou.task.colors[8]
syn match nouProgressTime display excludenl contains=@nouProgressTimeQ,nouTimeSpan,nouTableDelim
  \ '\v\[%(-|<%(\d+[wdhms]){1,2}%(\+%(\d+[wdhms]){1,2})*>)[/⁄]%(-|<%(\d+[wdhms]){1,2}%(\|%(\d+[wdhms]){1,2})?>)\]'

hi! nouProgressTimePart ctermfg=14 guifg=#586e75
syn cluster nouProgressTimeQ add=nouProgressTimePart
syn match nouProgressTimePart display excludenl contained contains=nouTimeSpan,nouTableDelim
  \ '\v\D%(\w+\+)?(<%(\d+[wdhms]){1,2}>)[/⁄]\1%(\|%(\d+[wdhms]){1,2})?\D'

exe 'hi! nouProgressTimePlan '. g:nou.task.colors[7]
syn cluster nouProgressTimeQ add=nouProgressTimePlan
syn match nouProgressTimePlan display excludenl contained contains=nouTimeSpan,nouTableDelim
  \ '\v\D-\D<%(\d+[wdhms]){1,2}>\D'

exe 'hi! nouProgressTimeLog '. g:nou.task.colors[1]
syn cluster nouProgressTimeQ add=nouProgressTimeLog
syn match nouProgressTimeLog display excludenl contained contains=nouTimeSpan
  \ '\v\D<%(\d+[wdhms]){1,2}>\D-\D'

" OR: [9]
exe 'hi! nouProgressTimeTodo '. g:nou.task.colors[0]
syn cluster nouProgressTimeQ add=nouProgressTimeTodo
syn match nouProgressTimeTodo display excludenl contained '\D-\D-\D'
"}}}
