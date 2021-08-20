`timescale 1ns/1ps
module processor_8085_pipeline_tb2;
reg clk;

wire z,cy;

integer i,j;
processor_8085_pipeline p1(clk,cy,z);

initial clk=1'b0;
always #5 clk=~clk;




initial
begin
for(i=1;i<=7;i=i+1)
p1.RF1.regfile_8085[i-1]=8'h0;
end


initial
begin

p1.pc=0;
#2;

for(j=0;j<100;j=j+1) begin
$display(" %d %d %d %d ",p1.Accout,p1.pc,p1.RF1.regfile_8085[1],p1.stall_jump);
#10;
end
end
initial
begin
#700 $stop;
end
endmodule