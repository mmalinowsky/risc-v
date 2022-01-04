`timescale 1ns / 1ps

`include "instruction_type.sv"

parameter OP_ADDI   = 3'b000;
parameter OP_SLTI    = 3'b010;
parameter OP_SLTIU    = 3'b011;
parameter OP_XORI    = 3'b100;
parameter OP_ORI    = 3'b110;
parameter OP_ANDI    = 3'b111;

parameter OP_LB    = 3'b000;
parameter OP_LH    = 3'b001;
parameter OP_LW    = 3'b010;
parameter OP_LBU    = 3'b100;
parameter OP_LHU    = 3'b101;

module immediate #(parameter XLEN=32)
(
    input CLK,
    input reset,
    input [31:0] bus,
    input [XLEN-1:0] rs1_in,
    output [2:0] pattern_out,
    output [XLEN-1:0] imm_out,
    output [XLEN-1:0] addr_out
);
    
    reg [XLEN-1:0] rd;
    reg [XLEN-1:0] rs1;
    reg [XLEN-1:0] addr;
    reg [2:0] pattern;
    I_Type i_ins;
    assign imm_out = rd;
    assign addr_out = addr;
    assign pattern_out = pattern;
    //assign rs1 = rs1_in;
    
always @(CLK, reset) begin
   if (~reset) 
        begin
            rd = 0;
        end
    i_ins = bus;
    rs1 = rs1_in;
    if (i_ins.opcode == LUI)
            rd = {i_ins[31:12], 12'b00000000000};
     else if (i_ins.opcode == AUIPC)
            rd = {i_ins[31:12], 12'b00000000000};
    else if (i_ins.opcode == MEM_MISC) begin
        case (i_ins.funct3) 
            OP_LB : begin
                rd = i_ins.rd;
                addr = i_ins.rs1 + i_ins.imm;
                pattern = 3'b001;
            end
        endcase
    end else begin
    case (i_ins.funct3)
    
        OP_ADDI : begin
            rd = rs1 + i_ins.imm;
        end
        
        OP_SLTI : begin
            if (rs1[31] == i_ins.imm[11])
                rd = rs1 < i_ins.imm ? 1 : 0;
            else
                rd = rs1[31] == 1 ? 1 : 0; 
        end
        
        OP_SLTIU : begin
            rd = rs1 < i_ins.imm ? 1 : 0;
        end
        
        OP_XORI: begin
            rd = rs1 ^ i_ins.imm;
        end
        
        OP_ORI: begin
            rd = rs1 | i_ins.imm;
        end
        
        OP_ANDI: begin
            rd = rs1 & i_ins.imm;
        end
        
        
        
        default: rd = 0;
    endcase
    end
end
    
endmodule
