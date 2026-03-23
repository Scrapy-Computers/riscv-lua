dofile "cpu.lua"
dofile "memory.lua"

local m = {}

function m.System(spec)
    local system= {
        memory = riscv_memory.Memory(spec.memorySize or 2048),
        cpu = riscv_cpu.CPU()
    }

    function system:load(address, data)
        self.memory:write(address, data)
    end

    function system:runTicks(ticks)
        for i = 1, ticks do
            self.cpu:tick(self.memory)
        end
    end

    return system
end

riscv_lua = m