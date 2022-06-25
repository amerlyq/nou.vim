if &cp||exists('g:loaded_nou')|finish|else|let g:loaded_nou=1|endif

" FAIL:(:h startup): loads nested folders {:runtime! plugin/**/*.vim}
" runtime plugin/nou/plug-switch.nou
" ALT:HACK: implicitly load lazy file on demand
if !exists('g:switch_custom_definitions')
  let g:switch_custom_definitions = []
endif
let g:switch_custom_definitions += nou#ext#switch#xts#groups
