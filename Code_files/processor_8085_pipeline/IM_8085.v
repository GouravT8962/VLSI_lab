module IM_8085(addr,data);
input [7:0] addr;
output [15:0] data;

reg [15:0] IM [255:0];
integer i;

initial
begin
for(i=0;i<256;i=i+1)
IM[i]=16'h2078;

$readmemh("tb12.txt",IM);

end

assign data=IM[addr];

endmodule
