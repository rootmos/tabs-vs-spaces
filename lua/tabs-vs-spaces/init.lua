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
					tabs[t] = (tabs[t] or 0) + 1
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
		tab_score = M.tab_score,
		spaces_score = M.spaces_score,
		decide = M.decide,
	}
end

local function mk_score(t)
	local I, Q = nil, 0
	for i, _ in pairs(t) do
		local q = 0
		for s, n in pairs(t) do
			if s % i == 0 then
				q = q + n
			end
		end
		if q > Q then
			Q = q
			I = i
		end
	end
	return I, Q
end

function M.tab_score(st)
	return mk_score(st.tabs)
end

function M.spaces_score(st)
	return mk_score(st.spaces)
end

function M.decide(st, default)
	local t, tq = st:tab_score()
	local s, sq = st:spaces_score()
	if tq == 0 and sq == 0 then
		return default
	elseif tq > sq then
		return -t
	elseif sq > tq then
		return s
	else
		if default or 0 >= 0 then
			return s
		else
			return -t
		end
	end
end

return M
