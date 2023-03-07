" negative values means prefer tabs over spaces
function TabsVsSpaces(preferred_tab_width)
  let ls = getline(1, '$')
  let ts = TabScore(ls)
  let ss = SpaceScore(ls)

  let t = abs(a:preferred_tab_width)
  if ts < ss || (ts == ss && a:preferred_tab_width >= 0)
    if ls != ['']
      let t = GuessIndentationLevel(ls)
      if t > g:tabs_vs_spaces_max_indentation_level
        let t = 0
      endif
    endif
    let m = 1
    setlocal expandtab
  elseif ts > ss || (ts == ss && a:preferred_tab_width < 0)
    let m = -1
    setlocal noexpandtab
  endif

  if t > 0
    let &l:tabstop = t
    let &l:softtabstop = t
    let &l:shiftwidth = t
    let b:tabs_vs_spaces = m * t
  endif
endfunction
