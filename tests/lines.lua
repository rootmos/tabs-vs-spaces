local function lnext(st, N)
    while true do
        while #st.bufs > 0 do
            st.i = st.i + 1
            local c = st.bufs[#st.bufs]:byte(st.i)
            if c == nil then
                break
            elseif c == 10 then
                local bs = {}
                local n = #st.bufs
                for k = 1,n do
                    local b = st.bufs[k]
                    if k == 1 and k == n then
                        b = st.bufs[k]:sub(st.o,st.i-1)
                    elseif k == 1 then
                        b = st.bufs[k]:sub(st.o)
                    elseif k == n then
                        b = st.bufs[k]:sub(1,st.i-1)
                    end

                    table.insert(bs, b)
                end

                if st.i == #st.bufs[n] then
                    st.bufs = {}
                    st.i = 0
                else
                    st.bufs = {st.bufs[n]}
                    st.o = st.i + 1
                end

                return N+1, table.concat(bs)
            end
        end

        local b = st.f:read(16)
        if b == nil then
            break
        end
        table.insert(st.bufs, b)
        st.i = 0
    end
end

return function(f)
    return lnext, {
        bufs = {},
        i = 0,
        o = 1,
        f = f,
    }, 0
end
