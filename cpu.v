`timescale 1 ns / 1 ps
`default_nettype none 

`ifndef RESET_STYLE
`define RESET_STYLE
`endif

module cpu
#(`include "pic_params.v")
(
input wire clk,
input wire rst,
output wire [DWIDTH*NUM_EXPOSED_REGS-1:0] exposed_reg_file
);


wire [PIC_INSTR_WIDTH-1:0] instruction;
wire [L2_PIC_INSTR_MEM_DEPTH-1:0] pc;
wire     q1,q2,q3,q4;

wire [L2_PIC_INSTR_MEM_DEPTH-1:0] goto_addr;
wire goto_enable;
wire status_carry, status_digit_carry, status_zero;
wire skip;
program_counter 
program_counter 
(
.clk(clk),
.rst(rst),
.pc(pc),
.q1(q1),
.q2(q2),
.q3(q3),
.q4(q4),
.goto_addr(goto_addr),
.goto_enable(goto_enable),
.skip(skip)
);


instr_mem
instr_mem
(
.clk(clk), 
.addr(pc),
.wdata(0),
.we(0),
.instruction(instruction)
);      

wire [ALU_INST_WIDTH-1:0] alu_instruction;
wire [L2_NUM_FREG-1:0] freg_num;
wire [L2_DWIDTH-1:0] alu_bit_num;
wire [DWIDTH-1:0] alu_literal_value;
wire alu_dest_bit;

wire [DWIDTH-1:0] dbus_o_s;
wire freg_wen;
wire [DWIDTH-1:0] dbus_i_s;



instr_decode
instr_decode
(
.clk(clk),
.rst(rst),
.instruction(instruction),
.en(q2),
.alu_instruction(alu_instruction),
.alu_freg_num(freg_num),
.alu_bit_num(alu_bit_num),
.alu_literal_value(alu_literal_value),
.alu_dest_bit(alu_dest_bit),
.goto_addr(goto_addr),
.goto_enable(goto_enable)
);

alu
alu
(
.clk(clk),
.rst(rst),
.alu_instruction(alu_instruction),
.bit_num(alu_bit_num),
.literal_value(alu_literal_value),
.dest_bit(alu_dest_bit),
.status_carry(status_carry),
.status_digit_carry(status_digit_carry),
.status_zero(status_zero),
.freg_o(dbus_o_s),
.freg_wen(freg_wen),
.freg_i(dbus_i_s),
.skip(skip)
);

reg_file
reg_file
(
.clk(clk),
.rst(rst),
.addr(freg_num), 
.data_bus_i(dbus_o_s),
.rden(q2),
.wren(freg_wen & q4),
.data_bus_o(dbus_i_s),
.exposed_reg_file(exposed_reg_file)
);

endmodule

`default_nettype wire