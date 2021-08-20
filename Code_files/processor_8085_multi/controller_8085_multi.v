module controller_8085_multi(ALUop,clk,reset,z,cy,opcode,funct,pcwrite,T1write,T2write,Accwrite,irwrite,cywrite,zwrite,read,write,regwrite,cinsrc,pcsrc,Accsrc,memsrcA,memsrcD,RFsrca1,RFsrca2,RFsrcd2,T1src,alusrca,cysrc,alusrcb);
input clk;
input z,cy;
input reset;
input [4:0] opcode,funct;
output reg pcwrite,T1write,T2write,Accwrite,irwrite,cywrite,zwrite,read,write,regwrite,cinsrc,pcsrc,ALUop;
output reg [1:0] memsrcA,memsrcD,RFsrca1,RFsrca2,RFsrcd2,T1src,alusrca,cysrc,Accsrc;
output reg [2:0] alusrcb;

reg [4:0] state,next_state;
parameter S1=0,S19=1,S3=2,S6=3,S7=4,S10=5,S13=6,S15=7,S17=8,S22=9,S24=10,S25bar=11,S28=12,S28bar=21,S30=13,S32=14,S34=15,S37=16,S39=17,S41=18,S46=19,S50=20,HALT=22,S51=23,S52=24,S53=25,S54=26,S55=27;
always @(posedge clk)
begin
state<=next_state;
end

always @(*)
begin
case(state)

S1: begin

if(reset)
begin
next_state=S1;
pcwrite=1'b0;
end
else
begin
next_state=S19;
pcwrite=1'b1;
end

ALUop=1'b1;
pcsrc=1'b0;
memsrcA=2'b00;
memsrcD=2'bxx;
read=1'b1;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'b10;
alusrcb=3'b000;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b1;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;

end
S19: begin

if((opcode==5'b00100)&&(funct==5'b01110))// halt
next_state=HALT;
else if((opcode==5'b00100)&&(funct==5'b01111))// nop
next_state=S1;
else if(opcode==5'b10000)// jnz
next_state=S28;
else if(opcode==5'b10001)// jnc
next_state=S28bar;
else if((opcode==5'b00100)&&(funct==5'b01010))// cma
next_state=S30;
else if((opcode==5'b00100)&&((funct==5'b01011)||(funct==5'b01100))) // cmc/stc
next_state=S32;
else if((opcode==5'b00100)&&(funct==5'b01101))// ret
next_state=S34;
else if(opcode==5'b10101)//movrr
next_state=S37;
else if(opcode==5'b10011)// mvir
next_state=S39;
else if(opcode==5'b10100)// mvim
next_state=S50;
else if(opcode==5'b10010)// call
next_state=S25bar;
else if((opcode==5'b10110)||(opcode==5'b10111))// movrm/movmr
next_state=S41;
else if(opcode==5'b01111)// jmp
next_state=S24;
else if(opcode==5'b01110)// sta
next_state=S17;
else if(opcode==5'b01101)// lda
next_state=S15;
else if(opcode==5'b00000)//reg_direct without inr/dcr
next_state=S3;
else if((opcode==5'b00010)||(opcode==5'b00011))// reg indirect total
next_state=S10;
else if(opcode==5'b00001)// reg direct inr/dcr only
next_state=S6;
else if((opcode==5'b00101)||(opcode==5'b00110)||(opcode==5'b00111)||(opcode==5'b01000)||(opcode==5'b01001)||(opcode==5'b01010)||(opcode==5'b01011)||(opcode==5'b01100))// immediate
next_state=S13;
else if(opcode==5'b11000)// movra
next_state=S51;
else if(opcode==5'b11001)// movar
next_state=S52;
else if(opcode==5'b11010)// movam
next_state=S53;
else if(opcode==5'b11011)// movma
next_state=S54;
else if(opcode==5'b11100)// mvia
next_state=S55;
else 
next_state=S1;


ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'b00;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'b00;
T1write=1'b1;
T2write=1'b1;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;

end

S3:begin

next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'b00;
alusrca=2'b01;
alusrcb=3'b001;
cysrc=(((opcode==5'b00000)||(opcode==5'b00010))&&((funct==5'b00110)||(funct==5'b00111)||(funct==5'b01000)))?2'b01:2'b00;//ANA,ORA,XRA cy reset to 0
cywrite=1'b1;
zwrite=1'b1;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=~(((opcode==5'b00000)||(opcode==5'b00010))&&(funct==5'b01001));// cmp
cinsrc=(((opcode==5'b00000)||(opcode==5'b00010))&&((funct==5'b00001)||(funct==5'b00011)));//ADC/SBB

end

S6:begin
if(opcode==5'b00001) //RD_I/D
next_state=S7;
else if(opcode==5'b00011)//RI_I/D
next_state=S22;
else
next_state=5'bxxxxx;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'b10;
T1write=1'b1;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'b00;
alusrcb=3'b000;
cysrc=2'b00;
cywrite=1'b0;
zwrite=1'b1;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S7:begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'b00;
regwrite=1'b1;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'b00;
Accwrite=1'b0;
cinsrc=1'b0;
end

S10:begin
if(opcode==5'b00011)//RI_I/D
next_state=S6;
else if(opcode==5'b10110)//Movrm
next_state=S7;
else if(opcode==5'b00010)// reg indirect without inr/dcr
next_state=S3;
else
next_state=5'bxxxxx;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'b01;
memsrcD=2'bxx;
read=1'b1;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'b01;
T1write=1'b1;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S13:begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'b00;
alusrca=2'b01;
alusrcb=3'b010;
cysrc=((opcode==5'b01001)||(opcode==5'b01010)||(opcode==5'b01011))?2'b01:2'b00;//ani/ori/xri
cywrite=1'b1;
zwrite=1'b1;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=~((opcode==5'b01100));//cpi
cinsrc=((opcode==5'b00110)||(opcode==5'b01000));// aci/sbi

end

S15: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'b11;
memsrcD=2'bxx;
read=1'b1;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'b01;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b1;
cinsrc=1'b0;
end

S17: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'b11;
memsrcD=2'b01;
read=1'b0;
write=1'b1;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S22: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'b10;
memsrcD=2'b00;
read=1'b0;
write=1'b1;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S24: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b1;
pcsrc=1'b0;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'b10;
alusrcb=3'b011;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S25bar: begin
next_state=S24;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'b10;
regwrite=1'b1;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'b10;
Accwrite=1'b0;
cinsrc=1'b0;
end

S28: begin
next_state=S1;

ALUop=1'b0;
pcwrite=~z;
pcsrc=1'b0;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'b10;
alusrcb=3'b011;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S28bar: begin
next_state=S1;

ALUop=1'b0;
pcwrite=~cy;
pcsrc=1'b0;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'b10;
alusrcb=3'b011;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S30: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'b00;
alusrca=2'b01;
alusrcb=3'b100;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b1;
cinsrc=1'b0;
end

S32: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'b11;
alusrcb=3'b000;
cysrc=2'b11;
cywrite=1'b1;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S34: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b1;
pcsrc=1'b1;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'b10;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S37: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'b01;
regwrite=1'b1;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'b00;
Accwrite=1'b0;
cinsrc=1'b0;
end

S39: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'b00;
regwrite=1'b1;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'b01;
Accwrite=1'b0;
cinsrc=1'b0;
end

S41: begin
if(opcode==5'b10110)// movrm
next_state=S10;
else if(opcode==5'b10111)// movmr
next_state=S46;
else
next_state=5'bxxxxx;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'b01;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'b00;
T1write=1'b1;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S46: begin
next_state=S22;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'b00;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b1;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S50: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'b01;
memsrcD=2'b10;
read=1'b0;
write=1'b1;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

HALT: begin
if(reset)
next_state=S1;
else
next_state=HALT;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'b00;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'b00;
Accwrite=1'b0;
cinsrc=1'b0;
end
S51: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'b00;
regwrite=1'b1;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'b11;
Accwrite=1'b0;
cinsrc=1'b0;
end

S52: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'b00;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'b10;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b1;
cinsrc=1'b0;
end

S53: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'b01;
memsrcD=2'bxx;
read=1'b1;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'b01;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b1;
cinsrc=1'b0;

end

S54: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'b01;
memsrcD=2'b11;
read=1'b0;
write=1'b1;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'bxx;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b0;
cinsrc=1'b0;
end

S55: begin
next_state=S1;

ALUop=1'b0;
pcwrite=1'b0;
pcsrc=1'bx;
memsrcA=2'bxx;
memsrcD=2'bxx;
read=1'b0;
write=1'b0;
RFsrca1=2'bxx;
RFsrca2=2'bxx;
regwrite=1'b0;
T1src=2'bxx;
T1write=1'b0;
T2write=1'b0;
Accsrc=2'b11;
alusrca=2'bxx;
alusrcb=3'bxxx;
cysrc=2'bxx;
cywrite=1'b0;
zwrite=1'b0;
irwrite=1'b0;
RFsrcd2=2'bxx;
Accwrite=1'b1;
cinsrc=1'b0;
end
default: begin
next_state=S1;
end
endcase
end

endmodule
