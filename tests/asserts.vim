function AssertEq(x, y)
  if a:x !=# a:y
    echom a:x . " !=# " . a:y
    echom ""
    cquit
  endif
endfunction

function AssertEqM(msg, x, y)
  if a:x !=# a:y
    echom a:msg . ": " . a:x . " !=# " . a:y
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
