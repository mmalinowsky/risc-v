`timescale 1ns / 1ps
`include "instruction_type.sv"


module core #(parameter XLEN=32)
    (
    input CLK,
    input reset,
    //input [XLEN-1:0] bus,
    //output [10:0][XLEN-1:0] debug,
    //output [31:0][XLEN-1:0] reg_debug
    input uart_rx,
    output uart_tx,
    output led_1,
    output led_2,
    input key_1
    );
    
    wire [31:0] alu_rd_out, imm_out;
    wire [31:0] r_out;
    wire [31:0] i_out;
    wire [31:0] j_out;
    wire [31:0] s_out;
    
    wire [4:0] rd_sel;
    wire [4:0] rs1_sel;
    wire [4:0] rs2_sel;
    wire [4:0] lsu_reg_sel;
    wire reg_write;
    wire mem_write;
    wire [2:0] imm_pattern;
    wire[31:0] reg_data_write;
    wire [31:0] pc_offset;
    wire [31:0] pc_out;
    wire [31:0] rs1_out, rs2_out;
    wire [31:0] addr;
    wire [31:0] imm_addr;
    wire [31:0] lsu_addr;
    wire [31:0] mem_value;
    wire [31:0] instruction;
 
    wire[31:0][31:0] reg_debug;
    wire inner_clk;
wire [7:0] uart_rx_data_o;
wire uart_rx_done;
wire uart_write_en;

parameter DLY_CNT = 32'd50000000;
parameter HALF_DLY_CNT = 32'd25000000;

(*mark_debug = "true"*)reg r_led;
(*mark_debug = "true"*)reg [31:0]count;
reg clk_reg;

always @(posedge CLK or negedge reset)
begin
	if(!reset)
		begin
			count <= 32'd0;
		end
	else if(count == DLY_CNT)
		begin
			count <= 32'd0;
		end
	else
		begin
			count <= count+32'd1;
		end
end

always@(posedge CLK or negedge reset)
begin
	if(!reset)
		begin
			clk_reg <= 1'b0;
		end
	else if(count < HALF_DLY_CNT)
		begin
			clk_reg <= 1'b1;
		end
	else
		begin
			clk_reg <= 1'b0;
		end
end

assign inner_clk = clk_reg;

    ins_mem ins_mem0(.CLK(inner_clk), .reset(reset),
        .instruction(instruction), .pc_offset(pc_offset), .pc_out(pc_out));
    
    registers registers0( .CLK(inner_clk), .reset(reset),
                        .rd(rd_sel), .rs1(rs1_sel), 
                        .rs2(rs2_sel),
                        .reg_write(reg_write),
                        .data_write(reg_data_write),
                        .o1(rs1_out),
                        .o2(rs2_out),
                        .debug_out(reg_debug)
                        );
    
    decoder decoder0( .CLK(inner_clk), .reset(reset), .bus(instruction), .r_out(r_out), .i_out(i_out), .j_out(j_out), .s_out(s_out), .rs1(rs1_sel), .rs2(rs2_sel));
    immediate immediate0( .CLK(inner_clk), .reset(reset), .bus(i_out), .rs1_in(rs1_out), .pattern_out(imm_pattern), .imm_out(imm_out), .addr_out(imm_addr));
    alu alu0( .CLK(inner_clk), .reset(reset), .bus(r_out), .rs1_in(rs1_out), .rs2_in(rs2_out), .alu_out(alu_rd_out));
    control_flow control_flow0(.CLK(inner_clk), .reset(reset), .bus(j_out), .rs1(rs1_out), .rs2(rs2_out), .pc_offset(pc_offset));
    mem_cache mem_cache0(.CLK(inner_clk), .reset(reset), .sel(addr), .data_write(imm_out), .data_out(mem_value), .pattern(imm_pattern));
    lsu lsu0( .CLK(inner_clk), .reset(reset), .ins(instruction), .addr_out(lsu_addr));
    
    assign reg_write = (r_out | i_out) ? 1 : 0;
    assign reg_data_write = r_out ? alu_rd_out : instruction[7:0] == MEM_MISC ? mem_value : instruction[7:0] == STORE_IMM ? rs2_out : imm_out;
    //assign reg_data_write = r_out ? alu_rd_out : imm_out;
    assign rd_sel = instruction[11:7];
    assign addr = instruction[7:0] == MEM_MISC ? imm_addr : lsu_addr;
    assign led_1 = (imm_out[0] == 1'b1) ? 1'b1 : 1'b0;
    assign led_2 = (alu_rd_out[0] ==  1'b1) ? 1'b1 : 1'b0;
    /*
    assign debug[0] = imm_out;
    assign debug[1] = alu_rd_out;
    assign debug[2] = rs1_out;
    assign debug[3] = rs2_out;
    assign debug[4] = pc_offset;
    assign debug[5] = pc_out;
    assign debug[6] = reg_data_write;
    assign debug[7] = rd_sel;
    assign debug[8] = reg_write;
    assign debug[9] = rs1_sel;
    assign debug[10] = rs2_sel;
    */
endmodule