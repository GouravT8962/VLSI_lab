module RF_8085_single(a1,a2,a3,d1,d2,d3,clk,regwrite);
input [2:0] a1,a2,a3;
input [7:0] d2;
output [7:0] d1,d3;
input clk;
input regwrite;
integer i;

reg [7:0] regfile_8085 [7:0];

assign d1=regfile_8085[a1];
assign d3=regfile_8085[a3];

initial
begin
for(i=0;i<8;i=i+1)
regfile_8085[i]=8'h0;
end

always @(posedge clk)
begin
if(regwrite)
regfile_8085[a2]<=d2;
end
endmodule
