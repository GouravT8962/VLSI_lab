module ALU_8085(a,b,cin,op,z,cy,out);
input [7:0] a,b;
input [2:0] op;
input cin;
output z;
output reg cy=1'b0;
output reg [7:0] out=8'b0;
reg cybar=0;
assign z=~|out;
always @(*)
begin
case(op)
3'b000: begin//add
{cy,out}=a+b+cin;
cybar=0;
end
3'b001: begin//sub
{cybar,out}=a-b-cin;
cy=cybar;
end
3'b010: begin//and
out=a&b;
cy=0;
cybar=0;
end
3'b011: begin//OR
out=a|b;
cy=0;
cybar=0;
end
3'b100: begin//XOR
out=a^b;
cy=0;
cybar=0;
end
default: begin
out=8'hxx;
cy=0;
cybar=0;
end

endcase
end

endmodule



