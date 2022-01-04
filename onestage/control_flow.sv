`timescale 1ns / 1ps
`include "instruction_type.sv"


parameter OP_BEQ = 3'b000;
parameter OP_BNE = 3'b001;
parameter OP_BLT = 3'b100;
parameter OP_BGE = 3'b101;
parameter OP_BLTU = 3'b110;
parameter OP_BGEU = 3'b111;

module control_flow(

    input CLK,
    input reset,
    input [31:0] bus,
    input [31:0] rs1, 
    input [31:0] rs2,
    output [31:0] pc_offset
    );
    
    reg[31:0] pc;
    J_Type j_ins;
    B_Type b_ins;
    
 assign pc_offset = pc; 
   
always_comb begin
    if (~reset) begin
        pc = 0;
    end
    pc = 0;
    j_ins = bus;
    case (j_ins.opcode)
    7'b1101111: begin
        pc = {j_ins.imm20, j_ins.imm10, j_ins.imm11, j_ins.imm8};    
     end
    endcase
    
    b_ins = bus;
    case (b_ins.funct3)
    
    OP_BEQ: begin 
        if (rs1 == rs2) begin
            pc = {b_ins.imm1, b_ins.imm7,b_ins.imm4, 1'b0};
        end    
    end
    
    OP_BNE: begin 
        if (rs1 != rs2) begin
         if (b_ins.imm1)
                pc = {20'b11111111111111111111, b_ins.imm1, b_ins.imm7, b_ins.imm4, 1'b0};
             else
                pc = {20'b00000000000000000000, b_ins.imm1, b_ins.imm7, b_ins.imm4, 1'b0};
        end    
    end
    
    OP_BLT: begin 
        if (rs1 < rs2) begin
            if (b_ins.imm1)
                pc = {20'b11111111111111111111, b_ins.imm1, b_ins.imm7, b_ins.imm4, 1'b0};
             else
                pc = {20'b00000000000000000000, b_ins.imm1, b_ins.imm7, b_ins.imm4, 1'b0};
        end    
    end
    
    OP_BGE: begin 
        if (rs1 > rs2) begin
            pc =  {b_ins.imm1, b_ins.imm7,b_ins.imm4, 1'b0};
        end    
    end
    
    OP_BLTU: begin 
        if (rs1 < rs2) begin
            pc =  {b_ins.imm1, b_ins.imm7,b_ins.imm4, 1'b0};
        end    
    end
    OP_BGEU: begin 
        if (rs1 > rs2) begin
            pc =   {b_ins.imm1, b_ins.imm7,b_ins.imm4, 1'b0};
        end    
    end
    
    endcase
end



endmodule
//j_ins[31:12]