`timescale 1ns/1ps
module processor_8085_pipeline_tb4;
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

for(j=0;j<180;j=j+1) begin
$display($time ," %d %d %d %h %h %d ",p1.Accout,p1.pc,p1.stall_jump,p1.lookup[0],p1.lookup[1],p1.ID_EX_lookupindex);
#10;
end
end
initial
begin
#1800 $stop;
end
endmodule