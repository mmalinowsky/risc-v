`timescale 1ns / 1ps

/*
parameter OP_LB    = 3'b000;
parameter OP_LH    = 3'b001;
parameter OP_LW    = 3'b010;
parameter OP_LBU    = 3'b100;
parameter OP_LHU    = 3'b101;

parameter OP_SB    = 3'b000;
parameter OP_SH    = 3'b001;
parameter OP_SW    = 3'b010;
*/
// .ins(bus), .addr_out(addr), .reg_sel(lsu_reg_sel)
module lsu(
        input CLK,
        input reset,
        input [31:0] ins,
        output [31:0] addr_out
    );

reg [31:0] addr;
S_Type s_type = 0;
assign addr_out = addr;
always_comb begin
s_type = ins;
case (s_type.funct3)
    default : begin 
        addr = s_type.rs1 + {s_type.imm2 + s_type.imm1};
    end
endcase    

end    

endmodule
