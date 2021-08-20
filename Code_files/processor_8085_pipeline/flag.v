module flag(in,out,clk,en);
input in,clk,en;
output reg out=1'b0;

always @(posedge clk)
begin
if(en)
out<=in;
end
endmodule



