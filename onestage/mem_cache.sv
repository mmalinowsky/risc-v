`timescale 1ns / 1ps

module mem_cache(
        input CLK,
        input reset,
        input [31:0] sel,
        input [31:0] data_write,
        input [2:0] pattern,
        output [31:0] data_out
    );

reg [32:0][10:0] cache;
assign data_out = cache[sel];


always_comb begin
    
    if (sel > 0) begin
        case(pattern)
            3'b001 : cache[sel] = (data_write & 32'b00000000000000000000000011111111);
            3'b010 : cache[sel] = data_write;
            default:
                cache[sel] = data_write;
        endcase
    end
    

end    
    
    
endmodule
