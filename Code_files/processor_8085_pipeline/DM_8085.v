module DM_8085(addr,datar,dataw,clk,read,write);
input [7:0] addr;
input clk,read,write;
input [15:0] dataw;
output [15:0] datar;

integer i;
reg [15:0] DM [255:0];

assign datar=(read)?DM[addr]:16'hxxxx;

initial
begin
for(i=0;i<256;i=i+1)
DM[i]=10*i;
end



always @(posedge clk)
begin
if(write)
DM[addr]<=dataw;
end

endmodule

