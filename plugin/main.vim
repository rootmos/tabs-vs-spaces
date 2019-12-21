" negative values means prefer tabs over spaces
function TabsVsSpaces(preferred_tab_width)
  let fn = expand("%:p")
  let ts = TabScore(fn)
  let ss = SpaceScore(fn)
  let t = abs(a:preferred_tab_width)

  let &l:tabstop = t
  let &l:softtabstop = t
  let &l:shiftwidth = t

  if ts < ss || (ts == ss && a:preferred_tab_width >= 0)
    setlocal expandtab
  elseif ts > ss || (ts == ss && a:preferred_tab_width < 0)
    setlocal noexpandtab
  endif
endfunction
