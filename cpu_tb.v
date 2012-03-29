module cpu_tb;

reg clk;
reg rst;
initial begin
clk = 0;
forever #10 clk = ~clk;
end

initial begin
rst = 1;
repeat (10) @(posedge clk);
rst = 0;
end

cpu
cpu
(.clk(clk),
.rst(rst)
);


initial begin
repeat (500) @(posedge clk);
$stop;
end

initial
 begin
    $dumpfile("test.vcd");
    $dumpvars(0,cpu_tb);
 end

endmodule