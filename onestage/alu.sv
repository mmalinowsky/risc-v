`timescale 1ns / 1ps

`include "instruction_type.sv"

parameter OP_ADD    = 3'b000;
parameter OP_SLL    = 3'b001;
parameter OP_SLT    = 3'b010;
parameter OP_SLTU   = 3'b011;
parameter OP_XOR    = 3'b100;
parameter OP_SRL    = 3'b101;
parameter OP_SRA    = 3'b101;
parameter OP_OR     = 3'b110;
parameter OP_AND    = 3'b111;

parameter WordSize = 32;

module alu #(parameter XLEN=32)
(
    input CLK,
    input reset,
    input [XLEN-1:0] bus,
    input [XLEN-1:0] rs1_in,
    input [XLEN-1:0] rs2_in,
    output [XLEN-1:0] alu_out
);
    reg [XLEN-1:0] rd;
    reg [XLEN-1:0] rs1;
    reg [XLEN-1:0] rs2;
    reg [31:0] diff;
    reg sign;
    assign alu_out = rd;
    assign rs1 = rs1_in;
    assign rs2 = rs2_in;
    //reg [31:0][WordSize-1:0] register;
    //reg [31:0] register_value
    R_Type r_ins;
    
    always_comb begin
        if (~reset) 
        begin
            rd = 0;
        end
        r_ins = bus;
        case(r_ins.funct3)
        
            OP_ADD : begin
                if (r_ins.funct7 == 7'b0000000) begin
                    rd = rs1 + rs2;
                end else begin
                    rd = rs1 + (~rs2) + 1;
                end
            end
            

             OP_SLT : begin
                //1 to rd if rs1 < rs2
                sign = rs1[31] - rs2[31];
                if(sign == 1) begin                    
                    rd = 1;
                 end else begin
                    diff = rs1 - rs2;
                    rd = sign == 0 ? diff < 0 ? 1 : 0 : 0;
                  end
            end
            
            OP_SLTU : begin
                rd = rs1 < rs2 ? 1 : 0;
            end
            
            OP_SLL : begin
                rd = rs1 << (5'b11111 & rs2);
            end
            
            OP_SRL : begin
                rd = (5'b11111 & rs2) >>  rs1;
            end
            
            OP_XOR : begin
                rd = rs1 ^ rs2;
            end
            
            OP_OR : begin
                rd = rs1 | rs2;
            end
            
            OP_AND : begin
                rd = rs1 & rs2;
            end
            
            default: rd = 0;
        endcase
    end
endmodule


