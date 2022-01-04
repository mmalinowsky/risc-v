`timescale 1ns / 1ps
`default_nettype none

include "defs.sv";

module register_file(
        input wire CLK,
        input wire rst,
        input wire [ADDR_LEN-1:0] r1_sel,
        input wire [ADDR_LEN-1:0] r2_sel,
        input wire [ADDR_LEN-1:0] rd_sel,
        input wire write_en,
        input wire[WORD_SIZE-1:0] write_data,
        output reg [WORD_SIZE-1:0] r1,r2
    );
    
    reg [WORD_SIZE-1:0][31:0] register;
    
    assign r1 = register[r1_sel];
    assign r2 = register[r2_sel];
    
    always_ff @(posedge CLK) begin
        if(~rst) begin
            register <= 0;
        end
        if(write_en) begin
            register[rd_sel] <= write_data;     
        end
    
    end
endmodule
