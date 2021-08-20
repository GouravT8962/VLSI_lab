`timescale 1ns/1ps
module generic_testbench_multi_8085;
reg clk;
reg reset;
wire z,cy;
wire [7:0] ACC;
integer i,j;
processor_8085_multi p1(clk,reset,z,cy,ACC);

initial clk=1'b0;
always #5 clk=~clk;
initial reset=1'b0;

initial
begin

p1.pc=0;
#2;

for(j=0;j<1500;j=j+1) begin
$display("time:%d	,pc:%d	,ACC:%d,	B:%d,	C:%d,	D:%d,	E:%d,	H:%d,	L:%d, cy: %d,z: %d %d %d ",$time,p1.pc,ACC,p1.rf1_1.reg_file[0],p1.rf1_1.reg_file[1],p1.rf1_1.reg_file[2],p1.rf1_1.reg_file[3],p1.rf1_1.reg_file[4],p1.rf1_1.reg_file[5],cy,z,p1.mem1.mem_reg[139],p1.mem1.mem_reg[146]);
#10;
end
end
initial
begin
#15000 $stop;
end
endmodule
