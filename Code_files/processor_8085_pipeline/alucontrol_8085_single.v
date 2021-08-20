module alucontrol_8085_single(opcode,funct,op);
input [4:0] opcode,funct;
output reg [2:0] op;

always @(*)
begin
if((((opcode==5'b0)||(opcode==5'b1)||(opcode==5'b00010)||(opcode==5'b00011))&&((funct==5'b0)||(funct==5'b1)||(funct==5'b00100)))||((opcode==5'b00101)||(opcode==5'b00110)||(opcode==5'b01111)||(opcode==5'b10000)||(opcode==5'b10001)||(opcode==5'b10010)))//ADD
op=3'b000;
else if((((opcode==5'b0)||(opcode==5'b1)||(opcode==5'b00010)||(opcode==5'b00011))&&((funct==5'b00010)||(funct==5'b00011)||(funct==5'b00101)||(funct==5'b01001)))||((opcode==5'b00111)||(opcode==5'b01000)||(opcode==5'b01100)))//sub
op=3'b001;
else if((((opcode==5'b0)||(opcode==5'b1)||(opcode==5'b00010)||(opcode==5'b00011))&&((funct==5'b00110)))||(opcode==5'b01001))//and
op=3'b010;
else if((((opcode==5'b0)||(opcode==5'b1)||(opcode==5'b00010)||(opcode==5'b00011))&&((funct==5'b00111)))||((opcode==5'b00100)&&(funct==5'b01100))||(opcode==5'b01010))//or
op=3'b011;
else if((((opcode==5'b0)||(opcode==5'b1)||(opcode==5'b00010)||(opcode==5'b00011))&&((funct==5'b01000)))||((opcode==5'b00100)&&((funct==5'b01010)||(funct==5'b01011)))||(opcode==5'b01011))//or
op=3'b100;
else
op=3'bxxx;
end

endmodule

