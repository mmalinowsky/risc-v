`timescale 1ns / 1ps
`default_nettype none

`include "instruction_type.sv"

module imm_ext(
        input wire[31:0] instr,
        output wire[31:0] imm_ext_out
    );
    
    reg [31:0] imm_reg;
    assign imm_ext_out = imm_reg;
    
    always_comb begin
        case (instr[6:0])
            (IMMEDIATE | MEM_MISC): begin 
                I_Type i_type = instr;
                imm_reg <= {i_type.imm, 20*{1'b0}}; 
            end
            (JAL | BRANCH): imm_reg <= 1;
            (STORE_IMM): imm_reg <=1;
            
            default:
                imm_reg <= {32*{1'bx}};
                
        endcase
    end
endmodule
