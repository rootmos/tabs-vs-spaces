function TabScore(ls)
  let c = 0
  for l in a:ls
    if l[0] ==? "\t"
      let c += 1
    endif
  endfor
  return c
endfunction

function SpaceScore(ls)
  let c = 0
  for l in a:ls
    if l[0] ==? " "
      let c += 1
    endif
  endfor
  return c
endfunction

let g:tabs_vs_spaces_max_indentation_level = 12

function GuessIndentationLevel(ls)
  let c = {}
  for l in a:ls
    let lc = 0
    for i in range(strlen(l))
      if l[i] ==? " "
        let lc += 1
      else
        break
      endif
    endfor

    if c->has_key(lc)
      let c[lc] += 1
    else
      let c[lc] = 1
    endif

  endfor

  let best_model = 0
  let best_score = 0
  for m in range(1, g:tabs_vs_spaces_max_indentation_level + 1)
    let e = 0
    for k in keys(c)
      if k % m != 0
        let e += 1
      endif
    endfor
    if e <= best_score
      let best_model = m
      let best_score = e
    endif
  endfor

  return best_model
endfunction
