dofile "instruction.lua"

local m = {}

function m.CPU()
    local cpu = {
        registers = {
            pc = 0
        },
        ecallHandler = function() end,
    }

    cpu.registers[0] = 0
    for i = 1, 31 do
        cpu.registers[i] = 0
    end

    function cpu:tick(memory)
        local instruction = riscv_instruction.Instruction(memory:readWord(self.registers.pc))
        instruction:exec(self, memory)
        self.registers.pc = self.registers.pc + 4
    end

    function cpu:writeReg(reg, value)
        self.registers[reg] = value & 0xFFFFFFFF
        self.registers[0] = 0
    end

    return cpu
end

riscv_cpu = m