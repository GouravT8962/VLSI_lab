module temp(in,out,clk,en);
input [7:0] in;
input clk,en;
output reg [7:0] out=0;

always @(posedge clk)
begin
if(en)
out<=in;
end
endmodule
