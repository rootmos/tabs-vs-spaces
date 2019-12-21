let b:tabs_vs_spaces = 0

" negative values means prefer tabs over spaces
function TabsVsSpaces(preferred_tab_width)
  let fn = expand("%:p")
  let ts = TabScore(fn)
  let ss = SpaceScore(fn)

  if ts < ss || (ts == ss && a:preferred_tab_width >= 0)
    let t = GuessIndentationLevel(fn)
    let m = 1
    setlocal expandtab
  elseif ts > ss || (ts == ss && a:preferred_tab_width < 0)
    let t = abs(a:preferred_tab_width)
    let m = -1
    setlocal noexpandtab
  endif

  let &l:tabstop = t
  let &l:softtabstop = t
  let &l:shiftwidth = t

  let b:tabs_vs_spaces = m * t
endfunction
