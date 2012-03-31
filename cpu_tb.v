`timescale 1ns/1ps
module cpu_tb #( 
`include "pic_params.v"
                 ) ;

   reg clk;
   reg rst;
   wire [DWIDTH*NUM_EXPOSED_REGS-1:0] exposed_reg_file;

   wire [DWIDTH-1:0]                   ereg0;
   wire [DWIDTH-1:0]                   ereg1;
   wire [DWIDTH-1:0]                   ereg2;
   wire [DWIDTH-1:0]                   ereg3;
   wire [DWIDTH-1:0]                   ereg4;
   wire [DWIDTH-1:0]                   ereg5;
   wire [DWIDTH-1:0]                   ereg6;
   wire [DWIDTH-1:0]                   ereg7;
   wire [DWIDTH-1:0]                   ereg8;
   wire [DWIDTH-1:0]                   ereg9;
   wire [DWIDTH-1:0]                   ereg10;
   wire [DWIDTH-1:0]                   ereg11;
   wire [DWIDTH-1:0]                   ereg12;
   wire [DWIDTH-1:0]                   ereg13;
   wire [DWIDTH-1:0]                   ereg14;
   wire [DWIDTH-1:0]                   ereg15;

   reg                                 we;
   reg [L2_PIC_INSTR_MEM_DEPTH-1:0]    waddr;
   reg [PIC_INSTR_WIDTH-1:0]           wdata;
   reg                                 program_mode;
     
assign {ereg15,ereg14,ereg13,ereg12,ereg11,ereg10,
        ereg9,ereg8,ereg7,ereg6,ereg5,
        ereg4,ereg3,ereg2,ereg1,ereg0} = exposed_reg_file;

initial begin
   clk = 0;
   forever #10 clk = ~clk;
end


task write_addr(  input  [PIC_INSTR_WIDTH-1:0]          data,
                  input  [L2_PIC_INSTR_MEM_DEPTH-1:0]   addr);
   begin
      @(posedge clk);
      we = 1;
      waddr = addr;
      wdata = data;
      @(posedge clk);
      we = 0;
   end
endtask

`include "tests/memclr.v"

cpu
cpu
(
 .clk                (clk),
 .rst                (rst),
 .waddr              (waddr),
 .we                 (we),
 .wdata              (wdata),
 .program_mode       (program_mode),
 .exposed_reg_file   (exposed_reg_file)
);


initial begin
   repeat (500) @(posedge clk);
   $stop;
end

initial begin
   $dumpfile("test.vcd");
   $dumpvars(0,cpu_tb);
end

endmodule