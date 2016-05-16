function! s:wiseman_map(w)
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
    return (pos1[1] - pos2[1] - 1 - (a:w =~ '[fF]' ? 1 : 0)) . "h"
  else
    return (pos2[1] - pos1[1] + 2 - (a:w == '[tT]' ? 1 : 0)) . "l"
  endif
endfunction

highlight! default FFF guibg=red ctermbg=red

nnoremap <expr> <Plug>(wiseman-f) <SID>wiseman_map('f')
onoremap <expr> <Plug>(wiseman-f) <SID>wiseman_map('f')
xnoremap <expr> <Plug>(wiseman-f) <SID>wiseman_map('f')
nnoremap <expr> <Plug>(wiseman-F) <SID>wiseman_map('F')
onoremap <expr> <Plug>(wiseman-F) <SID>wiseman_map('F')
xnoremap <expr> <Plug>(wiseman-F) <SID>wiseman_map('F')
nnoremap <expr> <Plug>(wiseman-t) <SID>wiseman_map('t')
onoremap <expr> <Plug>(wiseman-t) <SID>wiseman_map('t')
xnoremap <expr> <Plug>(wiseman-t) <SID>wiseman_map('t')
nnoremap <expr> <Plug>(wiseman-T) <SID>wiseman_map('T')
onoremap <expr> <Plug>(wiseman-T) <SID>wiseman_map('T')
xnoremap <expr> <Plug>(wiseman-T) <SID>wiseman_map('T')

if !get(g:, 'wiseman_f_not_overwrites_standard_mappings', 0)
  nmap f <Plug>(wiseman-f)
  xmap f <Plug>(wiseman-f)
  omap f <Plug>(wiseman-f)
  nmap F <Plug>(wiseman-F)
  xmap F <Plug>(wiseman-F)
  omap F <Plug>(wiseman-F)
  nmap t <Plug>(wiseman-t)
  xmap t <Plug>(wiseman-t)
  omap t <Plug>(wiseman-t)
  nmap T <Plug>(wiseman-T)
  xmap T <Plug>(wiseman-T)
  omap T <Plug>(wiseman-T)
endif

" vim:set et:
