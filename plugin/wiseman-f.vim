function! s:wiseman_f_map()
  let pos1 = getpos('.')[1:2]
  let pos2 = deepcopy(pos1)
  let pos2[1] -= 1
  let line = getline('.')
  let c = ''
  while 1
    call matchadd('FFF', printf('\%%%dl\%%>%dc.*\%%<%dc', pos2[0], pos2[1], pos2[1]+2))
    echohl Title | echo ":WiseMan: " . c | echohl None
    redraw
    call clearmatches()
    let k = getchar()
    let c = nr2char(k)
    if k == 13
      break
    elseif k == 2
      if pos2[1] > 0
        let pos2[1] -= 1
      endif
    elseif k == 6
      if pos2[1] < len(line)-1
        let pos2[1] += 1
      endif
    elseif k == 27
      return "\<c-c>"
    elseif k == 48
      let pos2[1] = 0
    elseif k == 94
      let pos2[1] = len(matchstr(line, '^\s*'))
    elseif k == 36
      let pos2[1] = col('$') - 2
    elseif k == 7
      let pos2 = deepcopy(pos1)
      let pos2[1] -= 1
    elseif k == "\<left>"
      if pos2[1] > 0
        let pos2[1] -= 1
      endif
    elseif k == "\<right>"
      if pos2[1] < len(line)
        let pos2[1] += 1
      endif
    elseif k != 0
      let pos = stridx(line, c, pos2[1]+1)
      if pos != -1
        let pos2[1] = pos
      endif
    endif
  endwhile
  call clearmatches()
  redraw | echo
  if pos1[1] > pos2[1]
    return (pos1[1] - pos2[1] - 1) . "h"
  else
    return (pos2[1] - pos1[1] + 2) . "l"
  endif
endfunction

highlight! default FFF guibg=red ctermbg=red

onoremap <expr> <plug>(wiseman-f) <SID>wiseman_f_map()
if !get(g:, 'wiseman_f_not_overwrites_standard_mappings', 0)
  omap ! <plug>(wiseman-f)
endif

" vim:set et:
