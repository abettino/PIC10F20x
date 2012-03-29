`default_nettype none 
`ifndef RESET_STYLE
`define RESET_STYLE
`endif

module alu
#(
`include "pic_params.v"
)(
input wire clk,
input wire rst,
input wire [ALU_INST_WIDTH-1:0] alu_instruction,
input wire [L2_DWIDTH-1:0] bit_num,
input wire [DWIDTH-1:0] literal_value,
input wire dest_bit,
output reg status_carry,
output reg status_digit_carry,
output reg status_zero,
output reg [DWIDTH-1:0] freg_o, 
output reg freg_wen,
input wire [DWIDTH-1:0] freg_i, 
output reg skip
);

integer ii; 
reg [DWIDTH-1:0] w_reg;


always @(posedge clk) begin
case (alu_instruction)
ADDWF, ANDWF, COMF,
DECF, DECFSZ, INCF, 
INCFSZ, IORWF, RLF, SUBWF,
RRF, SWAPF, XORWF : freg_wen <= dest_bit;
BCF, BSF, CLRF, MOVWF : freg_wen <= 1; 
default : freg_wen <= 0; 
endcase
end

always @(posedge clk `RESET_STYLE) begin
if (rst) begin
status_carry <= 0;
status_digit_carry <= 0;
status_zero <= 0;
w_reg <= 0;
skip <= 0;
end else begin
skip <= 0;
case (alu_instruction)
ADDWF: begin // C DC Z
if (dest_bit) freg_o <= w_reg + freg_i;
else w_reg <= w_reg + freg_i;
if ((w_reg + freg_i) == 0) status_zero <= 1; 
end
BCF: begin //NONE
freg_o <= freg_i & ~(8'h01 << bit_num); 
end
BTFSC: begin //NONE
if (freg_i[bit_num] == 0)
skip <= 1;
end
BTFSS: begin //NONE
if (freg_i[bit_num] == 1)
skip <= 1;
end
ANDLW: begin // Z
w_reg <= w_reg & literal_value;
if ((w_reg & literal_value) == 0) status_zero <= 1;
else status_zero <= 0;
end 
BSF: begin // NONE
freg_o <= freg_i | (8'h01 << bit_num);
end
ANDWF: begin // Z
if (dest_bit) freg_o <= w_reg & freg_i;
else w_reg <= w_reg & freg_i;
if ((w_reg & freg_i) == 0) status_zero <= 1;
else status_zero <= 0;
end
CLRW: begin // Z
w_reg <= 0;
status_zero <= 1;
end
CLRF: begin // Z
freg_o <= 0;
status_zero <= 1;
end
COMF: begin // Z
if (dest_bit) freg_o <= ~freg_i;
else w_reg <= ~freg_i;
if (~freg_i == 0) status_zero <= 1;
else status_zero <= 0;
end
DECF, DECFSZ: begin // Z and None
if (dest_bit) freg_o <= freg_i - 1;
else w_reg <= freg_i - 1;
if ((freg_i - 1) == 0) begin
if (alu_instruction == DECF) status_zero <= 1;
else skip <= 1;
end else status_zero <= 0;
end
INCF, INCFSZ: begin // Z and None
if (dest_bit) freg_o <= freg_i + 1;
else w_reg <= freg_i + 1;
if ((freg_i + 1) == 0) begin
if (alu_instruction == INCF) status_zero <= 1;
else skip <= 1;
end else status_zero <= 0;
end
IORLW: begin // Z
w_reg <= w_reg | literal_value;
if ((w_reg | literal_value) == 0) status_zero <= 1;
else status_zero <= 0;
end
IORWF: begin // Z
if (dest_bit) freg_o <= w_reg | freg_i;
else w_reg <= w_reg | freg_i;
if ((w_reg | freg_i) == 0) status_zero <= 1;
else status_zero <= 0;
end
MOVLW: begin // NONE
w_reg <= literal_value;
end
MOVWF: begin //NONE
freg_o <= w_reg;
end
MOVF: begin //Z
if (!dest_bit) w_reg <= freg_i;
if (freg_i==0) status_zero <= 1;
else status_zero <= 0;
end
RLF: begin //C
status_carry <= freg_i[DWIDTH-1];
if (dest_bit) freg_o <= {freg_i[DWIDTH-2:0], status_carry};
else w_reg <= {freg_i[DWIDTH-2:0], status_carry};
end
SUBWF: begin //C DC Z
if (dest_bit) freg_o <= w_reg - freg_i;
else w_reg <= w_reg - freg_i;
if ((w_reg - freg_i) == 0) status_zero <= 1;
else status_zero <= 0;
end
RRF: begin // C
status_carry <= freg_i[0];
if (dest_bit) freg_o <= {status_carry, freg_i[DWIDTH-1:1]};
else w_reg <= {status_carry, freg_i[DWIDTH-1:1]};
end
SWAPF: begin //NONE
if (dest_bit) freg_o <= {freg_i[3:0],freg_i[7:4]};
else w_reg <= {freg_i[3:0],freg_i[7:4]};
end
XORWF: begin // Z
if (dest_bit) freg_o <= w_reg ^ freg_i;
else w_reg <= w_reg ^ freg_i;
if ((w_reg ^ freg_i) == 0) status_zero <= 1;
else status_zero <= 0;
end
XORLW: begin // Z
w_reg <= w_reg ^ literal_value;
if ((w_reg ^ literal_value) == 0) status_zero <= 1;
else status_zero <= 0;
end     
endcase
end
end 

endmodule
`default_nettype wire