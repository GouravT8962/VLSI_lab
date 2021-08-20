module ACC_8085 (clk,in,out,en);
input [7:0] in;
input clk;
input en;
output reg [7:0] out=8'b0;

always @(posedge clk)
begin
if(en)
out<=in;
end

endmodule
