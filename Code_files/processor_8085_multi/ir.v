module ir(in,out,clk,en);
input [15:0] in;
input clk,en;
output reg [15:0] out;

always @(posedge clk)
begin
if(en)
out<=in;
end
endmodule