`timescale 1ns/1ps
module processor_8085_multi_tb5;
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
for(i=1;i<=6;i=i+1)
p1.rf1_1.reg_file[i-1]=i;
end


initial
begin

#2;
for(j=0;j<300;j=j+1) begin
$display($time," %d %d %d %d",p1.rf1_1.reg_file[0],p1.rf1_1.reg_file[2],p1.Accout,p1.pc);
#10;
end
end
initial
begin
#3000 $stop;
end
endmodule