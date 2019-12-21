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

" strict tests
call AssertEq(TabScore($EXAMPLES . "/tiny-tabs.c"), 1)
call AssertEq(TabScore($EXAMPLES . "/tiny-spaces.c"), 0)
call AssertEq(SpaceScore($EXAMPLES . "/tiny-tabs.c"), 0)
call AssertEq(SpaceScore($EXAMPLES . "/tiny-spaces.c"), 1)

" lenient comparison tests
call AssertLt(SpaceScore($EXAMPLES . "/tiny-tabs.c"), TabScore($EXAMPLES . "/tiny-tabs.c"))
call AssertLt(TabScore($EXAMPLES . "/tiny-spaces.c"), SpaceScore($EXAMPLES . "/tiny-spaces.c"))