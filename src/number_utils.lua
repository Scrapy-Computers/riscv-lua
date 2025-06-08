local mod = {}

function mod.i32ToI64(x)
    local sign = x & 0x80000000
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFF00000000
    end
end

function mod.i21ToI64(x)
    local sign = x & 0x100000
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFE00000
    end
end

function mod.i16ToI64(x)
    local sign = x & 0x8000
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFFF0000
    end
end

function mod.i13ToI64(x)
    local sign = x & 0x1000
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFFFE000
    end
end

function mod.i12ToI64(x)
    local sign = x & 0x800
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFFFF000
    end
end

function mod.i8ToI64(x)
    local sign = x & 0x80
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFFFFF00
    end
end

function mod.parseSignedIntFrom12Bits(x)
    local sign = x & 0x800
    local number = x & 0x7FF
    if sign == 0 then
        return number
    else
        return -((~number & 0x7FF) + 1)
    end
end

function mod.intDiv(a, b)
    if a >= 0 then
        return (a - a % b) / b
    end

    return (a + a % b) / b
end

-- This function does a % b, but handles negative numbers the way it works in C,
-- with the sign of quotient matching the sign of dividend:
--     -10 % 3 = -1 (Lua would return 2)
--     10 % -3 = 1 (Lua would return -2)
--     -10 % -3 = -1 (matches Lua result)
function mod.mod(a, b)
    if a < 0 and b > 0 then
        return -(-a % b)
    end

    if a >= 0 and b < 0 then
        return a % -b
    end

    return a % b
end

return mod
