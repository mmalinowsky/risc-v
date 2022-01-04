`timescale 1ns / 1ps
`ifndef _INSTRUCTION_TYPE_SV_
`define _INSTRUCTION_TYPE_SV_

enum bit[6:0] {
    LUI     = 7'b0110111,
    AUIPC   = 7'b0010111,
    JAL     = 7'b1101111,
    JALR    = 7'b1100111,
    BRANCH  = 7'b1100011,
    MEM_MISC     = 7'b0000011,
    STORE_IMM = 7'b0100011,
    IMMEDIATE   = 7'b0010011,
    REGISTER_LOGIC = 7'b0110011
    
} opcode;


typedef struct packed  {
    bit [11:0] imm;
    bit [4:0] rs1;
    bit [2:0] funct3;
    bit [4:0] rd;
    bit [6:0] opcode;
} I_Type;

typedef struct packed  {
    bit [6:0] funct7;
    bit [4:0] rs2;
    bit [4:0] rs1;
    bit [2:0] funct3;
    bit [4:0] rd;
    bit [6:0] opcode;
} R_Type;

typedef struct packed  {
    bit [6:0] imm2;
    bit [4:0] rs2;
    bit [4:0] rs1;
    bit [2:0] funct3;
    bit [4:0] imm1;
    bit [6:0] opcode;
} S_Type;


typedef struct packed  {
    bit [19:0] imm;
    bit [4:0] rd;
    bit [6:0] opcode;
} U_Type;

typedef struct packed  {
    bit imm1;
    bit [5:0] imm7;
    bit [4:0] rs2;
    bit [4:0] rs1;
    bit [2:0] funct3;
    bit [3:0] imm4;
    bit imm11;
    bit [6:0] opcode;
} B_Type;

typedef struct packed  {
    bit imm20;
    bit [9:0] imm10;
    bit imm11;
    bit [7:0] imm8;
    bit [4:0] rd;
    bit [6:0] opcode;
} J_Type;

module instruction_type(
    input wire [6:0] op_code
    );
endmodule
`endif