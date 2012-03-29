`ifndef RESET_STYLE
`define RESET_STYLE
`endif

module reg_file
  #(
`include "pic_params.v"
    )(
      input wire clk,
      input wire rst,
      input wire [L2_NUM_FREG-1:0] addr, 
      input wire [DWIDTH-1:0] data_bus_i,
      input wire rden,
      input wire wren,
      output reg [DWIDTH-1:0] data_bus_o,
      output wire [DWIDTH*NUM_EXPOSED_REGS-1:0] exposed_reg_file
      );

   genvar                                       ii;
   reg [DWIDTH-1:0]                             fregs [0:NUM_FREGS-1];
   wire [L2_NUM_FREG-1:0]                       FSR = fregs[FSR_REG_ADDR];

   generate for (ii=0; ii<NUM_EXPOSED_REGS; ii=ii+1) begin : OUTPUT_REGS
      assign exposed_reg_file[(ii+1)*DWIDTH-1 -: DWIDTH] = fregs[16+ii]; // start at 16
   end endgenerate


   always @(posedge clk `RESET_STYLE) begin
      if (rst) begin
         fregs[FSR_REG_ADDR] <= 0;
         data_bus_o <= 0;
      end else begin
         // indirect addressing
         if (addr == INDF_REG_ADDR) begin 
            if (rden) data_bus_o <= fregs[FSR];
            if (wren) fregs[FSR] <= data_bus_i;
         end else begin //direct addressing
            if (rden) data_bus_o <= fregs[addr];
            if (wren) fregs[addr] <= data_bus_i;
         end
      end
   end

endmodule