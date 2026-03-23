local m = {}

function m.Memory(size)
    local memory = {
        _bytes = {},
        _size = size,
    }

    function memory:size()
        return self._size
    end

    function memory:_checkAddress(address)
        if address < 0 or address >= self._size then
            error("Memory address out of bounds: " .. address)
        end
    end

    function memory:read(address, length)
        local result = ""
        for i = 0, length - 1 do
            result = result .. string.char(self:readByte(address + i))
        end
        return result
    end

    function memory:write(address, data)
        for i = 0, #data - 1 do
            self:writeByte(address + i, string.byte(data, i + 1))
        end
    end

    function memory:readByte(address)
        self:_checkAddress(address)
        return self._bytes[address] or 0
    end

    function memory:writeByte(address, value)
        self:_checkAddress(address)
        self._bytes[address] = value & 0xFF
    end

    function memory:readHalfWord(address)
        local low = self:readByte(address)
        local high = self:readByte(address + 1)
        return bit.lshift(high, 8) | low
    end

    function memory:writeHalfWord(address, value)
        self:writeByte(address, value & 0xFF)
        self:writeByte(address + 1, bit.rshift(value, 8) & 0xFF)
    end

    function memory:readWord(address)
        local low = self:readHalfWord(address)
        local high = self:readHalfWord(address + 2)
        return bit.lshift(high, 16) | low
    end

    function memory:writeWord(address, value)
        self:writeHalfWord(address, value & 0xFFFF)
        self:writeHalfWord(address + 2, bit.rshfit(value, 16) & 0xFFFF)
    end

    return memory
end

riscv_memory = m