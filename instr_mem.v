module instr_mem
#(
`include "pic_params.v"
)(
input wire clk,
input wire [L2_PIC_INSTR_MEM_DEPTH-1:0] addr,
input wire [PIC_INSTR_WIDTH-1:0] wdata,
input wire we, //provide mechansism for writing program mem
output reg [PIC_INSTR_WIDTH-1:0] instruction
);

reg [PIC_INSTR_WIDTH-1:0] mem[0:PIC_INSTR_MEM_DEPTH-1];
always @(posedge clk) begin
if (we) mem[addr] <= wdata;
instruction <= mem[addr];
end

integer mem_cnt=0;
task loadmem(input [11:0] data);
begin
mem[mem_cnt] = data;
mem_cnt = mem_cnt + 1;
end
endtask

initial begin
loadmem(12'b1100_1010_1010); //movlw 0xaa
loadmem(12'b0000_0011_0000); //movwf 0x10
loadmem(12'b1100_1010_1011); //movlw 0xab
loadmem(12'b0000_0011_0001); //movwf 0x11
loadmem(12'b1100_0001_0010); //movlw 0x12
loadmem(12'b0000_0010_0100); //movwf 0x4 (FSR)
loadmem(12'b0000_0110_0000); //clrf
loadmem(12'b0010_1010_0100); //incf 0x4 (FSR)
loadmem(12'b0110_1000_0100); //btfsc fsr 4
loadmem(12'b1010_0000_0110); //GOTO 0
loadmem(12'b0000_0000_0000); //nop
loadmem(12'b0000_0000_0000); //nop
end

endmodule