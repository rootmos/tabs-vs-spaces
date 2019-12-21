function AssertEq(x, y)
  if a:x !=# a:y
    echom a:x . " !=# " . a:y
    echom ""
    cquit
  endif
endfunction

function AssertLt(x, y)
  if a:x >= a:y
    echom a:x . " >= " . a:y
    echom ""
    cquit
  endif
endfunction
