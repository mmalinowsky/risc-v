`timescale 1ns / 1ps

`include "instruction_type.sv"

module decoder(
    input CLK,
    input reset,
    input [31:0] bus,
    output  [31:0] r_out,
    output  [31:0] i_out,
    output [31:0] j_out,
    output [31:0] s_out,
    output [4:0] rs1,
    output [4:0] rs2
    );
    
wire [6:0] opcode = bus[6:0];
reg [4:0] rs1_sel;
reg [4:0] rs2_sel;

R_Type r_reg = 0;
I_Type i_reg = 0;

J_Type j_reg = 0;
U_Type u_type = 0;
S_Type s_reg = 0;
always_comb begin
    r_reg = 0;
    i_reg = 0;
    j_reg = 0;
    s_reg = 0;
    case(opcode)

        REGISTER_LOGIC: begin
            r_reg = bus;
            rs1_sel = r_reg.rs1;
            rs2_sel = r_reg.rs2; 
        end
        
        IMMEDIATE | MEM_MISC : begin
            i_reg = bus;
            rs1_sel = i_reg.rs1;
        end
        
        JAL : begin
            j_reg = bus;
        end
        
        BRANCH : begin
            B_Type b_type = bus;
            rs1_sel = b_type.rs1;
            rs2_sel = b_type.rs2; 
            j_reg = bus;
        end
        LUI | AUIPC : begin
            u_type = bus;
            rs1_sel = u_type.rd;
            i_reg = bus; 
        end
        STORE_IMM : begin
            s_reg = bus;
            rs2_sel = s_reg.rs2;
        end
        default: begin
            i_reg = 0;
            r_reg = 0;
            j_reg = 0;
            u_type = 0;
            s_reg = 0;
        end
    endcase
end

assign r_out = r_reg;
assign i_out = i_reg;
assign j_out = j_reg;
assign s_out = s_reg;
assign rs1 = rs1_sel;
assign rs2 = rs2_sel;
endmodule
