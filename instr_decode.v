`ifndef RESET_STYLE
`define RESET_STYLE
`endif

module instr_decode
#(
`include "pic_params.v"
)(
input wire clk,
input wire rst,
input wire en,
input wire [PIC_INSTR_WIDTH-1:0] instruction,
output wire [ALU_INST_WIDTH-1:0] alu_instruction,
output wire [L2_NUM_FREG-1:0] alu_freg_num,
output wire [L2_DWIDTH-1:0] alu_bit_num,
output wire [DWIDTH-1:0] alu_literal_value,
output wire alu_dest_bit,
output reg [L2_PIC_INSTR_MEM_DEPTH-1:0] goto_addr,
output reg goto_enable
);

reg [INST_DEC_WIDTH-1:0] instruction_decode;
// change to clocked process to pipeline instruction decode

always @(posedge clk) begin
if (instruction_decode == GOTO) begin
goto_enable <= 1;
goto_addr <= instruction[8:0];
end else begin
goto_enable <= 0;
end
end

always @(instruction) begin
casez (instruction)
12'b0001_11??_????       : instruction_decode = ADDWF   ;
12'b0001_01??_????       : instruction_decode = ANDWF   ;
12'b0000_011?_????       : instruction_decode = CLRF    ;
12'b0000_0100_0000       : instruction_decode = CLRW    ;
12'b0010_01??_????       : instruction_decode = COMF    ;
12'b0000_11??_????       : instruction_decode = DECF    ;
12'b0010_11??_????       : instruction_decode = DECFSZ  ;
12'b0010_10??_????       : instruction_decode = INCF    ;
12'b0011_11??_????       : instruction_decode = INCFSZ  ;
12'b0001_00??_????       : instruction_decode = IORWF   ;
12'b0010_00??_????       : instruction_decode = MOVF    ;
12'b0000_001?_????       : instruction_decode = MOVWF   ;
12'b0000_0000_0000       : instruction_decode = NOP     ;
12'b0011_01??_????       : instruction_decode = RLF ;
12'b0011_00??_????       : instruction_decode = RRF ;
12'b0000_10??_????       : instruction_decode = SUBWF   ;
12'b0011_10??_????       : instruction_decode = SWAPF   ;
12'b0001_10??_????       : instruction_decode = XORWF   ;
12'b0100_????_????       : instruction_decode = BCF ;
12'b0101_????_????       : instruction_decode = BSF ;
12'b0110_????_????       : instruction_decode = BTFSC ;
12'b0111_????_????       : instruction_decode = BTFSS ;
12'b1110_????_????       : instruction_decode = ANDLW   ;
12'b1001_????_????       : instruction_decode = CALL ;
12'b0000_0000_0100       : instruction_decode = CLRWDT  ;
12'b101?_????_????       : instruction_decode = GOTO    ;
12'b1101_????_????       : instruction_decode = IORLW   ;
12'b1100_????_????       : instruction_decode = MOVLW   ;
12'b0000_0000_0010       : instruction_decode = OPTION  ;
12'b1000_????_????       : instruction_decode = RETLW   ;
12'b0000_0000_0011       : instruction_decode = SLEEP   ;
12'b0000_0000_0???       : instruction_decode = TRIS    ;
12'b1111_????_????       : instruction_decode = XORLW ;
default : begin
instruction_decode = NOP;
$error("unrecognized instruction: %x", instruction);
$stop;
end
endcase
end

assign  alu_instruction = instruction_decode[ALU_INST_WIDTH-1:0];
assign  alu_freg_num = instruction[L2_NUM_FREG-1:0]; // always bit [4:0] 
assign  alu_dest_bit = instruction[5]; // always bit [5]
assign  alu_bit_num = instruction[7:5]; // always in bits [7:5]
assign  alu_literal_value = instruction[7:0];

endmodule