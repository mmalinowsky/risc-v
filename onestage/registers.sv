`timescale 1ns / 1ps

module registers(
    input CLK,
    input reset,
    
    input [4:0] rd,
    input [4:0] rs1,
    input [4:0] rs2,
    
    input wire reg_write,
    input [31:0] data_write,
    
    output [31:0] o1,o2,
    output [31:0] [31:0] debug_out
    );
    
    reg [31:0][31:0] register;
    //reg [4:0] s1, s2; 

assign o1 = (rs1 == 0) ? 0 : register[rs1];
assign o2 = (rs2 == 0) ? 0 : register[rs2];
assign debug_out = register;

always @(CLK,reset) begin
    if(~reset) begin
        register = 0;
    end;
    if (reg_write == 1)
        register[rd] = data_write;
    
end


    
endmodule
