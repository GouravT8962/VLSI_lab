module MEM_8085_multi(clk,addr,data,dataw,read,write);
input [7:0] addr;
input clk;
input [15:0] dataw;
input read,write;
output [15:0] data;

integer i;
reg [15:0] mem_reg [255:0];
assign data=read?mem_reg[addr]:8'hxx;

initial
begin
for(i=0;i<128;i=i+1)
mem_reg[i]=16'h2078;
$readmemh("tb12.txt",mem_reg);
for(i=128;i<256;i=i+1)
mem_reg[i]=(i-128)*10;
end

always @(posedge clk)
begin
if(write)
mem_reg[addr]<=dataw;
end
endmodule