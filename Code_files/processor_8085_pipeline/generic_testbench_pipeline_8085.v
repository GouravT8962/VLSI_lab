`timescale 1ns/1ps
module generic_testbench_pipeline_8085;
reg clk;
reg reset;
wire z,cy;
wire [7:0] ACC;
integer i,j;
processor_8085_pipeline p1(clk,cy,z,ACC);

initial clk=1'b0;
always #5 clk=~clk;
initial reset=1'b0;

initial
begin

p1.pc=0;
#2;

for(j=0;j<500;j=j+1) begin
$display("time:%d	,pc:%d	,ACC:%d,	B:%d,	C:%d,	D:%d,	E:%d,	H:%d,	L:%d cy: %d, z: %d %d %d %h %h %h %h ",$time,p1.pc,ACC,p1.RF1.regfile_8085[0],p1.RF1.regfile_8085[1],p1.RF1.regfile_8085[2],p1.RF1.regfile_8085[3],p1.RF1.regfile_8085[4],p1.RF1.regfile_8085[5],cy,z,p1.DM1.DM[11],p1.DM1.DM[18],p1.lookup[0],p1.lookup[1],p1.lookup[2],p1.lookup[3]);
#10;
end
end
initial
begin
#5000 $stop;
end
endmodule