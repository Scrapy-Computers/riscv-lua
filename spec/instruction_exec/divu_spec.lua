local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("divu")

describe("divu", function()
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

    it("10 / 2 = 5", function()
        cpu.registers[1] = 10
        cpu.registers[2] = 2
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(5, cpu.registers[1])
    end)

    it("0xFFFFFFFF / 2 = 0x7FFFFFFF", function()
        cpu.registers[1] = 0xFFFFFFFF -- 4,294,967,295
        cpu.registers[2] = 2
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x7FFFFFFF, cpu.registers[1])
    end)

    it("rounds down results", function()
        cpu.registers[1] = 9
        cpu.registers[2] = 2
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(4, cpu.registers[1])
    end)

    it("sets the quotient to 0xFFFFFFFF on division by zero", function()
        cpu.registers[1] = 1
        cpu.registers[2] = 0
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0xFFFFFFFF, cpu.registers[1])
    end)
end)
