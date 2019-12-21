filetype plugin on

exec "edit " . $EXAMPLES . "/tiny-tabs.c"
call AssertEq(b:tabs_vs_spaces, -2)

exec "edit " . $EXAMPLES . "/tiny-spaces.c"
call AssertEq(b:tabs_vs_spaces, 4)
