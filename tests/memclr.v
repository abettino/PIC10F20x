
reg [L2_PIC_INSTR_MEM_DEPTH-1:0]   cur_addr;

initial begin
   we = 0;
   rst = 1;
   program_mode = 1;
   cur_addr = 0;
   @(posedge clk);
   write_addr(12'b1100_1010_1010, cur_addr); //movlw 0xaa
   cur_addr = cur_addr+1;
   write_addr(12'b0000_0011_0000, cur_addr); //movwf 0x10
   cur_addr = cur_addr+1;
   write_addr(12'b1100_1010_1011, cur_addr); //movlw 0xab
   cur_addr = cur_addr+1;
   write_addr(12'b0000_0011_0001, cur_addr); //movwf 0x11
   cur_addr = cur_addr+1;
   write_addr(12'b1100_0001_0010, cur_addr); //movlw 0x12
   cur_addr = cur_addr+1;
   write_addr(12'b0000_0010_0100, cur_addr); //movwf 0x4 (FSR)
   cur_addr = cur_addr+1;
   write_addr(12'b0000_0110_0000, cur_addr); //clrf
   cur_addr = cur_addr+1;
   write_addr(12'b0010_1010_0100, cur_addr); //incf 0x4 (FSR)
   cur_addr = cur_addr+1;
   write_addr(12'b0110_1000_0100, cur_addr); //btfsc fsr 4
   cur_addr = cur_addr+1;
   write_addr(12'b1010_0000_0110, cur_addr); //GOTO 0
   cur_addr = cur_addr+1;
   write_addr(12'b0000_0000_0000, cur_addr); //nop
   cur_addr = cur_addr+1;
   write_addr(12'b0000_0000_0000, cur_addr); //nop   
   program_mode = 0;
   @(posedge clk);
   rst = 0;
   @(posedge clk);
end