`timescale 1ns/1ps
module processor_8085_multi_tb1;
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

p1.pc=0;
#2;
for(j=0;j<100;j=j+1) begin
$display($time," %d %d %d %d %4h %d",p1.Accout,p1.contr.state,p1.pc,p1.aluout,p1.IRout,p1.Accwrite);
#10;
end
end
initial
begin
#1000 $stop;
end
endmodule
