" strict tests
let tt = readfile($EXAMPLES . "/tiny-tabs.c")
let ts = readfile($EXAMPLES . "/tiny-spaces.c")
let tf = readfile($EXAMPLES . "/pipeline.tf")

let rw = readfile($EXAMPLES . "/real-world.c")

call AssertEq(TabScore([]), 0)
call AssertEq(SpaceScore([]), 0)

call AssertEq(TabScore(tt), 1)
call AssertEq(TabScore(ts), 0)
call AssertEq(SpaceScore(tt), 0)
call AssertEq(SpaceScore(ts), 1)

call AssertLt(g:tabs_vs_spaces_max_indentation_level, GuessIndentationLevel([]))
call AssertEqM("GuessIndentationLevel(ts)", GuessIndentationLevel(ts), 4)
call AssertEqM("GuessIndentationLevel(tf)", GuessIndentationLevel(tf), 2)
call AssertEqM("GuessIndentationLevel(rw)", GuessIndentationLevel(rw), 4)

" lenient comparison tests
call AssertLt(SpaceScore(tt), TabScore(tt))
call AssertLt(TabScore(ts), SpaceScore(ts))
