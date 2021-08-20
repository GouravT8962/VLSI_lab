module controller_8085_single(opcode,funct,z,cy,pcwrite,regwrite,Accwrite,read,write,cywrite,zwrite,RFsrca2,cinsrc,zsrc,pcsrc,RFsrca1,alu2srca,alu2srcb,DMsrca,DMsrcd,cysrc,Accsrc,RFsrcd2);
input [4:0] opcode,funct;
input z,cy;
output reg regwrite,Accwrite,read,write,cywrite,zwrite,RFsrca2,cinsrc,zsrc;
output reg [1:0] RFsrca1,alu2srca,alu2srcb,DMsrca,DMsrcd,cysrc;
output reg [2:0] Accsrc,RFsrcd2;
output reg pcwrite=1'b1;
output reg [1:0] pcsrc=2'b00;
always @(*)
begin
if((opcode==5'b0)&&((funct==5'b0)||(funct==5'b00010))) //reg direct add/sub
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b00;
alu2srcb=2'b00;
cysrc=2'b00;
Accsrc=3'b000;
Accwrite=1'b1;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b0;
end

else if((opcode==5'b0)&&((funct==5'b1)||(funct==5'b00011))) //reg direct adc/sbb
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b00;
alu2srcb=2'b00;
cysrc=2'b00;
Accsrc=3'b000;
Accwrite=1'b1;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b1;
zsrc=1'b0;
end

else if((opcode==5'b1)&&((funct==5'b00100)||(funct==5'b00101))) //reg direct inr/dcr
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'b0;
regwrite=1'b1;
RFsrcd2=3'b101;
alu2srca=2'b01;
alu2srcb=2'b10;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b0;
end

else if((opcode==5'b0)&&((funct==5'b00110)||(funct==5'b00111)||(funct==5'b01000))) //reg direct ana/ora/xra
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b00;
alu2srcb=2'b00;
cysrc=2'b10;
Accsrc=3'b000;
Accwrite=1'b1;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b0;
end

else if((opcode==5'b0)&&(funct==5'b01001))//reg direct cmp
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b00;
alu2srcb=2'b00;
cysrc=2'b00;
Accsrc=3'b000;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b0;
end

else if((opcode==5'b00010)&&((funct==5'b0)||(funct==5'b00010))) //reg indirect add/sub
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'b11;
Accsrc=3'b100;
Accwrite=1'b1;
DMsrca=2'b00;
DMsrcd=2'bxx;
read=1'b1;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b1;
end

else if((opcode==5'b00010)&&((funct==5'b1)||(funct==5'b00011))) //reg indirect adc/sbb
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'b11;
Accsrc=3'b100;
Accwrite=1'b1;
DMsrca=2'b00;
DMsrcd=2'bxx;
read=1'b1;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b1;
zsrc=1'b1;
end

else if((opcode==5'b00010)&&((funct==5'b00110)||(funct==5'b00111)||(funct==5'b01000))) //reg indirect ana/ora/xra
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'b10;
Accsrc=3'b100;
Accwrite=1'b1;
DMsrca=2'b00;
DMsrcd=2'bxx;
read=1'b1;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b1;
end

else if((opcode==5'b00010)&&(funct==5'b01001))//reg indirect cmp
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'b11;
Accsrc=3'b100;
Accwrite=1'b0;
DMsrca=2'b00;
DMsrcd=2'bxx;
read=1'b1;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b1;
end

else if(opcode==5'b01101)//lda
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'b001;
Accwrite=1'b1;
DMsrca=2'b10;
DMsrcd=2'bxx;
read=1'b1;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b01110)//sta
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'b10;
DMsrcd=2'b00;
read=1'b0;
write=1'b1;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b01111)//jmp
begin
pcsrc=2'b01;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b10;
alu2srcb=2'b01;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b10000)//jnz
begin
pcsrc=z?2'b00:2'b01;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b10;
alu2srcb=2'b01;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b10001)//jnc
begin
pcsrc=cy?2'b00:2'b01;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b10;
alu2srcb=2'b01;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b10010)//call
begin
pcsrc=2'b01;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'b1;
regwrite=1'b1;
RFsrcd2=3'b100;
alu2srca=2'b10;
alu2srcb=2'b01;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if((opcode==5'b00100)&&(funct==5'b01010))//cma
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b00;
alu2srcb=2'b11;
cysrc=2'bxx;
Accsrc=3'b000;
Accwrite=1'b1;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if((opcode==5'b00100)&&((funct==5'b01011)||(funct==5'b01100)))//cmc/stc
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b11;
alu2srcb=2'b10;
cysrc=2'b01;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b1;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if((opcode==5'b00100)&&(funct==5'b01101))//ret
begin
pcsrc=2'b10;
pcwrite=1'b1;
RFsrca1=2'b10;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b10101)// movrr
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b01;
RFsrca2=1'b0;
regwrite=1'b1;
RFsrcd2=3'b001;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b10011)// mvi r,8
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'b0;
regwrite=1'b1;
RFsrcd2=3'b011;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b10110)// mov r,m
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b01;
RFsrca2=1'b0;
regwrite=1'b1;
RFsrcd2=3'b010;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'b00;
DMsrcd=2'bxx;
read=1'b1;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b10111)// mov m,r
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b01;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'b01;
DMsrcd=2'b01;
read=1'b0;
write=1'b1;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b10100)// mvi m,8
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'b00;
DMsrcd=2'b10;
read=1'b0;
write=1'b1;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b11000)// mov r,a
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'b0;
regwrite=1'b1;
RFsrcd2=3'b000;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b11001)// mov a,r
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'b010;
Accwrite=1'b1;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b11010)// mov a,m
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'b001;
Accwrite=1'b1;
DMsrca=2'b00;
DMsrcd=2'bxx;
read=1'b1;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b11011)//mov m,a
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'b00;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'b00;
DMsrcd=2'b00;
read=1'b0;
write=1'b1;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if(opcode==5'b11100)//mvi a,8
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'b011;
Accwrite=1'b1;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if((opcode==5'b00100)&&(funct==5'b01110))// hlt
begin
pcsrc=2'b00;
pcwrite=1'b0;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'b001;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if((opcode==5'b00100)&&(funct==5'b01111))//nop
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'b001;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

else if((opcode==5'b00101)||(opcode==5'b00111))// adi,sui
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b00;
alu2srcb=2'b01;
cysrc=2'b00;
Accsrc=3'b000;
Accwrite=1'b1;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b0;
end

else if((opcode==5'b00110)||(opcode==5'b01000))// aci,sbi
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b00;
alu2srcb=2'b01;
cysrc=2'b00;
Accsrc=3'b000;
Accwrite=1'b1;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b1;
zsrc=1'bx;
end

else if((opcode==5'b01001)||(opcode==5'b01010)||(opcode==5'b01011))// ani,ori,xri
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b00;
alu2srcb=2'b01;
cysrc=2'b10;
Accsrc=3'b000;
Accwrite=1'b1;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b0;
end

else if(opcode==5'b01100)// cpi
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'b00;
alu2srcb=2'b01;
cysrc=2'b00;
Accsrc=3'b000;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b1;
zwrite=1'b1;
cinsrc=1'b0;
zsrc=1'b0;
end

else
begin
pcsrc=2'b00;
pcwrite=1'b1;
RFsrca1=2'bxx;
RFsrca2=1'bx;
regwrite=1'b0;
RFsrcd2=3'bxxx;
alu2srca=2'bxx;
alu2srcb=2'bxx;
cysrc=2'bxx;
Accsrc=3'bxxx;
Accwrite=1'b0;
DMsrca=2'bxx;
DMsrcd=2'bxx;
read=1'b0;
write=1'b0;
cywrite=1'b0;
zwrite=1'b0;
cinsrc=1'b0;
zsrc=1'bx;
end

end











endmodule


















