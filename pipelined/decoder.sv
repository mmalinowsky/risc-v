`timescale 1ns / 1ps

`include "instruction_type.sv"
`include "defs.sv"

module decoder(
    input wire CLK,
    input wire rst,
    input wire [WORD_SIZE-1:0] INST,
    output wire r_sel,
    output wire i_sel,
    output wire j_sel,
    output wire s_sel,
    output wire[2:0] alu_op
    );
    
reg [6:0] opcode = INST[6:0];

assign r_sel = opcode == REGISTER_LOGIC ? 1 : 0;
assign i_sel = opcode == (IMMEDIATE | MEM_MISC) ? 1 : 0;
assign j_sel = opcode == (JAL | BRANCH) ? 1 : 0;
assign i_sel = opcode == (LUI | AUIPC) ? 1 : 0;
assign s_sel = opcode == (STORE_IMM) ? 1 : 0;

assign alu_op = INST[16:13];
    
 endmodule
