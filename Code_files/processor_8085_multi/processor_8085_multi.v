module processor_8085_multi(clk,reset,z,cy,ACC);
input clk;
input reset;
output z,cy;
output [7:0] ACC;
reg [7:0] pc=0;
wire [7:0] pc_next;

wire pcwrite,T1write,T2write,Accwrite,IRwrite,cywrite,zwrite,read,write,cinsrc,regwrite,pcsrc,ALUop;
wire [1:0] memsrcA,memsrcD,RFsrca1,RFsrca2,RFsrcd2,T1src,alusrca,cysrc,Accsrc;
wire [2:0] alusrcb,op;
wire [7:0] addr;
wire [7:0] T1out,T2out,Accout,T1in;
wire [7:0] Accin;
wire [15:0] dataw;
wire [15:0] IRin,IRout;
wire [7:0] aluout;
wire [2:0] RF_a1,RF_a2;
wire [7:0] RF_d1,RF_d2;
wire [7:0] alu_a,alu_b;
wire cyout,zout,cin,z1,cy1,cyin;

assign ACC=Accout;
assign z=zout;
assign cy=cyout;


assign addr=(memsrcA==2'b00)?pc:
            (memsrcA==2'b01)?T1out:
				(memsrcA==2'b10)?T2out:
				(memsrcA==2'b11)?IRout[7:0]:8'hxx;
				
assign dataw=(memsrcD==2'b00)?{8'b0,T1out}:
            (memsrcD==2'b01)?{8'b0,Accout}:
				(memsrcD==2'b10)?{8'b0,IRout[7:0]}:
				(memsrcD==2'b11)?{8'b0,Accout}:16'hxxxx;

assign RF_a1=(RFsrca1==2'b00)?IRout[10:8]:
            (RFsrca1==2'b01)?IRout[2:0]:
				(RFsrca1==2'b10)?3'b110:3'bxxx; //call

assign RF_a2=(RFsrca2==2'b00)?IRout[10:8]:
            (RFsrca2==2'b01)?IRout[2:0]:
				(RFsrca2==2'b10)?3'b110:3'bxxx; //call

assign RF_d2=(RFsrcd2==2'b00)?T1out:
            (RFsrcd2==2'b01)?IRout[7:0]:
				(RFsrcd2==2'b10)?pc:
				(RFsrcd2==2'b11)?Accout:8'hxx;

assign Accin=(Accsrc==2'b00)?aluout:
             (Accsrc==2'b01)?IRin[7:0]:
				 (Accsrc==2'b10)?RF_d1:
				 (Accsrc==2'b11)?IRout[7:0]:8'hxx;

assign T1in=(T1src==2'b00)?RF_d1:
            (T1src==2'b01)?IRin[7:0]:
				(T1src==2'b10)?aluout:8'hxx;

assign alu_a=(alusrca==2'b00)?T1out:
            (alusrca==2'b01)?Accout:
				(alusrca==2'b10)?pc:
				(alusrca==2'b11)?{7'b0,cyout}:8'hxx;

assign alu_b=(alusrcb==3'b000)?8'b1:
            (alusrcb==3'b001)?T1out:
				(alusrcb==3'b010)?IRout[7:0]:
				(alusrcb==3'b011)?IRout[7:0]:
            (alusrcb==3'b100)?8'b11111111:8'hxx;

assign cin=(cinsrc)?cyout:1'b0;

assign cyin=(cysrc==2'b00)?cy1:
            (cysrc==2'b01)?1'b0:
				(cysrc==2'b11)?aluout[0]:1'bx;

assign pc_next=(pcsrc)?RF_d1:aluout;



MEM_8085_multi mem1(clk,addr,IRin,dataw,read,write);

RF1 rf1_1 (RF_a1,RF_a2,RF_d1,RF_d2,clk,regwrite);

flag cy2 (cyin,cyout,clk,cywrite);

flag z2 (z1,zout,clk,zwrite);

ALU_8085 alu1(alu_a,alu_b,cin,op,z1,cy1,aluout);

temp T1(T1in,T1out,clk,T1write);
temp T2(RF_d1,T2out,clk,T2write);
temp Acc(Accin,Accout,clk,Accwrite);
ir IR(IRin,IRout,clk,IRwrite);

alu_control_8085_multi ac1 (IRout[15:11],IRout[7:3],ALUop,op);

controller_8085_multi contr(ALUop,clk,reset,zout,cyout,IRout[15:11],IRout[7:3],pcwrite,T1write,T2write,Accwrite,IRwrite,cywrite,zwrite,read,write,regwrite,cinsrc,pcsrc,Accsrc,memsrcA,memsrcD,RFsrca1,RFsrca2,RFsrcd2,T1src,alusrca,cysrc,alusrcb);
always @(posedge clk)
begin
if(pcwrite)
pc<=pc_next;
end

endmodule