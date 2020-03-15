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

  let best_model_0 = -1
  let best_score_0 = -1
  for m in range(2, g:tabs_vs_spaces_max_indentation_level + 1)
    let e = 0
    for k in keys(c)
      if k % m != 0
        let e += c[k]
      endif
    endfor
    if (best_score_0 < 0) || (e <= best_score_0)
      let best_model_0 = m
      let best_score_0 = e
    endif
  endfor

  let best_model_1 = -1
  let best_score_1 = -1
  for m in range(2, g:tabs_vs_spaces_max_indentation_level + 1)
    let n = 0
    let s = 0
    while c->has_key(n)
      let s += c[n]
      let n += m
    endwhile
    if s >= best_score_1
      let best_model_1 = m
      let best_score_1 = s
    endif
  endfor

  if best_model_0 ==? best_model_1
    return best_model_1
  else
    let m = best_model_0 < best_model_1 ? best_model_0 : best_model_1
    let M = best_model_0 < best_model_1 ? best_model_1 : best_model_0
    if M % m ==? 0
      return M
    else
      return m
    endif
  endif
endfunction
