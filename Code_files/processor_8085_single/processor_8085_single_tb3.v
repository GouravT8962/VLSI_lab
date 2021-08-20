`timescale 1ns/1ps
module processor_8085_single_tb3;
reg clk;

wire z,cy;
wire [7:0] ACC;

integer i,j;
processor_8085_single p1(clk,cy,z,ACC);

initial clk=1'b0;
always #5 clk=~clk;




initial
begin
for(i=1;i<=7;i=i+1)
p1.RF1.regfile_8085[i-1]=i;
end


initial
begin

p1.pc=0;
#2;

for(j=0;j<32;j=j+1) begin
$display(" %d %d %d ",p1.Accout,p1.pc,p1.Accsrc);
#10;
end
end
initial
begin
#600 $stop;
end
endmodule
