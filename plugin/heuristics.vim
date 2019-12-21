function TabScore(fn)
  let ls = readfile(a:fn)
  let c = 0
  for l in ls
    if l[0] ==? "\t"
      let c += 1
    endif
  endfor
  return c
endfunction

function SpaceScore(fn)
  let ls = readfile(a:fn)
  let c = 0
  for l in ls
    if l[0] ==? " "
      let c += 1
    endif
  endfor
  return c
endfunction
