local M = {}

local function mk(p)
    return function(x)
        if type(x) == "number" and math.type(x) == "integer" then
            return p(x)
        end

        local t = true
        x:gsub(".", function(c)
            if t then
                t = p(c:byte())
            end
        end)
        return t
    end
end

M.is_printable = mk(function(b) return 32 <= b and b <= 126 end)
M.is_upper = mk(function(b) return 65 <= b and b <= 90 end)
M.is_lower = mk(function(b) return 97 <= b and b <= 122 end)
M.is_letter = mk(function(b) return (65 <= b and b <= 90) or (97 <= b and b <= 122) end)
M.is_digit = mk(function(b) return 48 <= b and b <= 57 end)
M.is_alphanum = mk(function(b) return (48 <= b and b <= 57) or (65 <= b and b <= 90) or (97 <= b and b <= 122) end)
M.is_whitespace = mk(function(b) return b == 32 or b == 9 end)

local function snext(s, i)
    i = i + 1
    local c = s:byte(i)
    if c == nil then
        return nil
    else
        return i, c
    end
end

local function fnext(st, o)
    o = o + 1
    if st.i >= #st.buf then
        st.buf = st.file:read(st.bufsize)
        st.i = 0
        if st.buf == nil then
            return nil
        end
    end
    st.i = st.i + 1
    return o, st.buf:byte(st.i)
end

function M.stream(x, bufsize)
    if type(x) == "string" then
        return snext, x, 0
    else
        return fnext, {buf={}, file=x, i=0, bufsize=bufsize or 4096}, 0
    end
end

function M.bytes(s)
    local t = {}
    s:gsub(".", function(c) table.insert(t, c:byte()) end)
    return t
end

return M
