`timescale 1ns / 1ps

module ins_mem(
        input CLK,
        input reset,
        input [31:0] pc_offset,
        output [31:0] instruction,
        output [31:0] pc_out
    );
    
reg [7:0] memory [40:0];
reg  [31:0] pc;
reg  [31:0] current_ins;
reg  [31:0] pc_offset_reg;


assign instruction = current_ins;
assign pc_out = pc;

always_ff @(posedge CLK) begin
    pc_offset_reg = pc_offset;
    if(~reset) begin
        pc = 0;
        current_ins = {memory[0],memory[1],memory[2],memory[3]};
        $readmemb("test_prog.mem", memory);
     end
    else if(pc_offset_reg != 0)
        pc = pc + $signed(pc_offset_reg);
    else
        pc = pc + 4;   
        
     current_ins = {memory[pc],memory[pc+1],memory[pc+2],memory[pc+3]}; 
end
endmodule
