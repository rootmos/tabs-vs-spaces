local M = {}

local C = require(.....".char")

function M.inspect(f)
	local lines = 0
	local tabs, spaces, mixed, empty = {}, {}, 0, 0

	local st, t, s = 0, 0, 0
	for _, c in C.stream(f) do
		if st == 0 then
			if c == 32 then
				s = s + 1
			elseif c == 9 then
				t = t + 1
			else
				st = 1
			end
		end

		if st == 1 then
			if c == 10 then
				if s > 0 and t == 0 then
					spaces[s] = (spaces[s] or 0) + 1
				elseif s == 0 and t > 0 then
					tabs[s] = (tabs[s] or 0) + 1
				elseif s > 0 and t > 0 then
					mixed = mixed + 1
				else
					empty = empty + 1
				end
				lines = lines + 1
				st, t, s = 0, 0, 0
			end
		end
	end

	return {
		lines = lines,
		tabs = tabs,
		spaces = spaces,
		mixed = mixed,
		empty = empty,
	}
end

return M
