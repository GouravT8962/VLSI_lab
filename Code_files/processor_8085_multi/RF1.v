module RF1(a1,a2,d1,d2,clk,regwrite);
input clk;
input [2:0] a1,a2;
input [7:0] d2;
input regwrite;
output [7:0] d1;

reg [7:0] reg_file [7:0];
integer i;
initial
begin
for(i=1;i<8;i=i+1)
reg_file[i-1]=8'b0;
end


assign d1=reg_file[a1];

always @(posedge clk)
begin
if(regwrite)
reg_file[a2]<=d2;
end
endmodule
