`ifndef RESET_STYLE
`define RESET_STYLE
`endif

module program_counter #(
`include "pic_params.v" 
) (
input wire clk,
input wire rst,
output reg [L2_PIC_INSTR_MEM_DEPTH-1:0] pc,
output reg q1,
output reg q2,
output reg q3,
output reg q4,
input wire [L2_PIC_INSTR_MEM_DEPTH-1:0] goto_addr,
input wire goto_enable,
input wire skip
);


   always @(posedge clk `RESET_STYLE) begin
      if (rst) begin
         pc <= 0;
         {q1, q2, q3, q4} <= {4'b1000};
      end else begin
         {q1, q2, q3, q4} <= {q4, q1, q2, q3};
         if (q4) begin 
            if (goto_enable) pc <= goto_addr;
            else if (skip) pc <= pc + 2;
            else pc <= pc + 1;
         end
      end
   end

endmodule