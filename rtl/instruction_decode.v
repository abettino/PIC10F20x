module #(INSTRUCTION_WIDTH=12) instruction_decode
(
input wire clk,
input wire rst,
input wire [INSTRUCTION_WIDTH-1:0] instruction,
output wire [DECODE_INSTRUCTION_WIDTH-1:0] instruction_decode
);

endmodule   
   