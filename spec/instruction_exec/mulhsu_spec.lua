local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("mulhsu")

describe("mulhsu", function()
    local cpu
    local instructionData

    before_each(function()
        cpu = CPU.new()
        instructionData = {
            opcode = opcode,
            funct3 = funct3,
            funct7 = funct7,
        }
    end)

    it("2 * 2 = 4", function()
        cpu.registers[1] = 2
        cpu.registers[2] = 2
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0, cpu.registers[1])
    end)

    it("-1,431,655,766 * 2,863,311,530 = -4,099,276,461,778,781,980", function()
        cpu.registers[1] = 0xAAAAAAAA -- -1,431,655,766
        cpu.registers[2] = 0xAAAAAAAA -- 2,863,311,530
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        -- -4,099,276,461,778,781,980 = 0xC71C71C6_E38E38E4
        assert.are.equal(0xC71C71C6, cpu.registers[1])
    end)
end)
