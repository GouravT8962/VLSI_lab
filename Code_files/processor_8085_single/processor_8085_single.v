module processor_8085_single(clk1,cy,z,ACC);
input clk1;
output cy,z;
output [7:0] ACC;

reg [7:0] pc;
wire [7:0] pc_next;

wire pcwrite,regwrite,Accwrite,read,write,cywrite,zwrite,RFsrca2,cinsrc,zsrc;
wire [1:0] pcsrc,RFsrca1,alu2srca,alu2srcb,DMsrca,DMsrcd,cysrc;
wire [2:0] Accsrc,RFsrcd2;



wire [7:0] alu1out,alu2out,alu3out;
wire [15:0] IM_d;
wire [2:0] RF_a1,RF_a2;
wire [7:0] RF_d1,RF_d2,RF_d3;
wire [7:0] alu2_a,alu2_b;
wire z2,cy2,z3,cy3,cin;
wire [2:0] op;
wire [7:0] Accin,Accout;
wire [7:0] DM_a;
wire [15:0] DM_dr,DM_dw;
wire cy_in,z_in;
wire locked,clk;
 
assign ACC=Accout;
assign pc_next=(pcsrc==2'b00)?(alu1out):
               (pcsrc==2'b01)?(alu2out):
					(pcsrc==2'b10)?(RF_d1):8'hxx;

assign RF_a1=(RFsrca1==2'b00)?IM_d[10:8]:
             (RFsrca1==2'b01)?IM_d[2:0]:
				 (RFsrca1==2'b10)?3'b110:3'bxxx;

assign RF_a2=(RFsrca2)?3'b110:IM_d[10:8];

assign Accin=(Accsrc==3'b000)?alu2out:
             (Accsrc==3'b001)?DM_dr[7:0]:
				 (Accsrc==3'b010)?RF_d1:
				 (Accsrc==3'b011)?IM_d[7:0]:
				 (Accsrc==3'b100)?alu3out:8'hxx;

assign alu2_a=(alu2srca==2'b00)?Accout:
              (alu2srca==2'b01)?RF_d1:
				  (alu2srca==2'b10)?alu1out:
				  (alu2srca==2'b11)?{7'b0,cy}:8'hxx;

assign alu2_b=(alu2srcb==2'b00)?RF_d1:
              (alu2srcb==2'b01)?IM_d[7:0]:
				  (alu2srcb==2'b10)?8'b1:
				  (alu2srcb==2'b11)?8'hFF:8'hxx;

assign RF_d2=(RFsrcd2==3'b000)?Accout:
             (RFsrcd2==3'b001)?RF_d1:
				 (RFsrcd2==3'b010)?DM_dr[7:0]:
				 (RFsrcd2==3'b011)?IM_d[7:0]:
				 (RFsrcd2==3'b100)?alu1out:
				 (RFsrcd2==3'b101)?alu2out:8'hxx;

assign DM_a=(DMsrca==2'b00)?RF_d1:
            (DMsrca==2'b01)?RF_d3:
				(DMsrca==2'b10)?IM_d[7:0]:8'hxx;

assign DM_dw=(DMsrcd==2'b00)?{8'b0,Accout}:
             (DMsrcd==2'b01)?{8'b0,RF_d1}:
				 (DMsrcd==2'b10)?{8'b0,IM_d[7:0]}:16'hxxxx;


assign cy_in=(cysrc==2'b00)?cy2:
             (cysrc==2'b01)?alu2out[0]:
				 (cysrc==2'b10)?1'b0:
				 (cysrc==2'b11)?cy3:1'bx;

assign cin=(cinsrc)?cy:1'b0;

assign z_in=(zsrc)?z3:z2;


IM_8085 IM1(pc,IM_d);

adder_8085 alu1(pc,8'b1,alu1out);

ALU_8085 alu2(alu2_a,alu2_b,cin,op,z2,cy2,alu2out);

ALU_8085 alu3(Accout,DM_dr[7:0],cin,op,z3,cy3,alu3out);

DM_8085 DM1(DM_a,DM_dr,DM_dw,clk,read,write);

RF_8085_single RF1(RF_a1,RF_a2,IM_d[10:8],RF_d1,RF_d2,RF_d3,clk,regwrite);

ACC_8085 ACC1(clk,Accin,Accout,Accwrite);

flag cy_flag(cy_in,cy,clk,cywrite);

flag z_flag(z_in,z,clk,zwrite);

alucontrol_8085_single alucontr(IM_d[15:11],IM_d[7:3],op);

controller_8085_single contr_single(IM_d[15:11],IM_d[7:3],z,cy,pcwrite,regwrite,Accwrite,read,write,cywrite,zwrite,RFsrca2,cinsrc,zsrc,pcsrc,RFsrca1,alu2srca,alu2srcb,DMsrca,DMsrcd,cysrc,Accsrc,RFsrcd2);

pll_8085 pll(1'b0,clk1,clk,locked);

always @(posedge clk)
begin
if(pcwrite)
pc<=pc_next;
end
endmodule
