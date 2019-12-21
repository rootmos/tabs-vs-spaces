filetype plugin on

exec "edit " . $EXAMPLES . "/tiny-tabs.c"
call AssertEq(b:tabs_vs_spaces, -abs(g:tabs_vs_spaces))

exec "edit " . $EXAMPLES . "/tiny-spaces.c"
call AssertEq(b:tabs_vs_spaces, 4)

exec "edit " . $TMP . "/new-file.c"
call AssertEq(b:tabs_vs_spaces, g:tabs_vs_spaces)
