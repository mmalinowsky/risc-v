`timescale 1ns / 1ps
`default_nettype none

`include "defs.sv"

module core(
        input wire CLK,
        input wire rst,
        input wire[31:0] INST,
        input wire[31:0] MEM_DATA_IN,
        output wire[31:0] INST_ADDR,
        output wire[31:0] MEM_ADDR,
        output wire[31:0] MEM_DATA,
        output wire MEM_WE
    );
    reg [WORD_SIZE-1:0] PC_F;
    reg [WORD_SIZE-1:0] pc_d;
    
    reg r_sel;
    reg i_sel;
    reg j_sel;
    reg s_sel;
    wire [2:0] alu_op;
    reg [WORD_SIZE-1:0] INST_D;

    decoder decoder_1(.INST(INST_D), .*);
    
    wire [WORD_SIZE-1:0] write_data;
    wire [ADDR_LEN-1:0] r1_sel;
    wire [ADDR_LEN-1:0] r2_sel;
    wire [ADDR_LEN-1:0] rd_sel;
    wire write_en;
    reg [WORD_SIZE-1:0] r1,r2;
    reg [WORD_SIZE-1:0] pc_plus_d;
    register_file register_file1(.*);
    
    reg [WORD_SIZE-1:0] r1_e, r2_e;
    wire [WORD_SIZE-1:0] imm_ext_out;
    reg [WORD_SIZE-1:0] imm_ext_out_e;
    reg [WORD_SIZE-1:0] pc_plus_e;
    imm_ext imm_ext_1(.instr(INST[31:7]), .imm_ext_out(imm_ext_out));
    
    wire [WORD_SIZE-1:0] pc_target_e;
    reg [WORD_SIZE-1:0] pc_e;
    assign pc_target_e = imm_ext_out_e + pc_plus_e;
    wire [1:0]alu_src_a;
    wire [1:0] alu_src_b;
    wire [WORD_SIZE-1:0] src_a;
    wire [WORD_SIZE-1:0] src_b;
    alu_mux alu_mux_1(.rs1(r1_e), .result_w(alu_out_m), .alu_result_m(alu_out_m), .sel(alu_src_a), .out(src_a));
    alu_mux2 alu_mux_2(.imm(imm_ext_out), .rs2(r2_e), .sel(alu_src_b), .out(src_b));
    
    reg [WORD_SIZE-1:0] alu_out;
    alu alu1(.r1(src_a), .r2(src_b), .*);
    
    reg [WORD_SIZE-1:0] alu_out_m;
    reg [WORD_SIZE-1:0] write_data_m;
    reg mem_we_m;
    
    reg [WORD_SIZE-1:0] r1_reg;
    reg [WORD_SIZE-1:0] r2_reg;
    
    assign INST_ADDR = PC_F;
    
    always @(posedge CLK) begin
        
        INST_D <= INST;
        r1_reg <= r1;
        r2_reg <= r2;
        
    end
    
    always @(posedge CLK) begin
        r1_e <= r1;
        r2_e <= r2;
        
        imm_ext_out_e <= imm_ext_out;
        pc_plus_e <= pc_plus_d;
    end
    
    assign MEM_ADDR = alu_out_m;
    assign MEM_DATA = write_data_m;
    assign MEM_WE = mem_we_m;
    
    reg reg_write_w;
    reg [1:0] src_sel_w;
    
    reg [WORD_SIZE-1:0] reg_data_w;
    reg [WORD_SIZE-1:0] pc_plus_w;
    reg [WORD_SIZE-1:0] read_data_w;
    reg [WORD_SIZE-1:0] result_w;
    write_mux write_mux1(.*);
    
    always @(posedge CLK) begin
        alu_out_m <= alu_out;
        write_data_m <= src_b;
        read_data_w <= MEM_DATA_IN;
        
    end
endmodule
