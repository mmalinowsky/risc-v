`timescale 1ns / 1ps

`include "defs.sv"
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


module alu
(
    input wire CLK,
    input wire rst,
    input wire [2:0] alu_op,
    input wire [WORD_SIZE-1:0] r1,
    input wire [WORD_SIZE-1:0] r2,
    output wire [WORD_SIZE-1:0] alu_out
);
    reg [WORD_SIZE-1:0] rd;
 
    reg [WORD_SIZE-1:0] diff;
    reg sign;
    assign alu_out = rd;


    
    always_comb begin
        if (~rst) 
        begin
            rd = 0;
        end
        case(alu_op)
        
            OP_ADD : begin
                //if (r_ins.funct7 == 7'b0000000) begin
                    rd = r1 + r2;
                //end else begin
                    //rd = r1 + (~r2) + 1;
                //end
            end
            

             OP_SLT : begin
                //1 to rd if r1 < r2
                sign = r1[31] - r2[31];
                if(sign == 1) begin                    
                    rd = 1;
                 end else begin
                    diff = r1 - r2;
                    rd = sign == 0 ? diff < 0 ? 1 : 0 : 0;
                  end
            end
            
            OP_SLTU : begin
                rd = r1 < r2 ? 1 : 0;
            end
            
            OP_SLL : begin
                rd = r1 << (5'b11111 & r2);
            end
            
            OP_SRL : begin
                rd = (5'b11111 & r2) >>  r1;
            end
            
            OP_XOR : begin
                rd = r1 ^ r2;
            end
            
            OP_OR : begin
                rd = r1 | r2;
            end
            
            OP_AND : begin
                rd = r1 & r2;
            end
            
            default: rd = 0;
        endcase
    end
endmodule

