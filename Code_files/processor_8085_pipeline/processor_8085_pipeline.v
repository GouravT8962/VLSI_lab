module processor_8085_pipeline(clk,cy,z,ACC);
input clk;
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


wire [3:0] Acc_select,RF_d1_select,RF_d3_select;
wire [7:0] Acc_new;
wire [7:0] RF_d1_new,RF_d3_new;
wire cin_alu3;
wire cin_new;
wire [2:0] cin_select;
wire cy_new,z_new;
wire [2:0] cy_select,z_select;
wire stall_load;
wire stall_indirect;
wire stall_jump;

reg [15:0] IF_ID_IM_d=16'h0;
reg [7:0] IF_ID_alu1out=8'h0,IF_ID_pc=8'b0; //IF_ID reg

reg [15:0] ID_EX_IM_d=16'h0;
reg [7:0] ID_EX_Accout=8'h0,ID_EX_alu1out=8'h0,ID_EX_RF_d1=8'h0,ID_EX_RF_d3=8'h0,ID_EX_pc=8'b0;//ID_EX reg

reg [15:0] EX_MEM_IM_d=16'h0;
reg [7:0] EX_MEM_Accout=8'h0,EX_MEM_alu1out=8'h0,EX_MEM_alu2out=8'h0,EX_MEM_RF_d1=8'h0,EX_MEM_RF_d3=8'h0;
reg EX_MEM_cy=1'b0,EX_MEM_z=1'b0;
reg [2:0] EX_MEM_op=3'b0;// EX_MEM reg

reg [15:0] MEM_WB_IM_d=16'h0;
reg [7:0] MEM_WB_Accout=8'h0,MEM_WB_alu1out=8'h0,MEM_WB_alu2out=8'h0,MEM_WB_RF_d1=8'h0;
reg [15:0] MEM_WB_DM_dr=16'h0;
reg MEM_WB_cy=1'b0,MEM_WB_z=1'b0;
reg [2:0] MEM_WB_op=3'b0;//MEM_WB reg
 

//control signals

reg [1:0] ID_EX_pcsrc=2'b00,EX_MEM_pcsrc=2'b00;//pcsrc

reg ID_EX_pcwrite=1'b1;//pcwrite

reg ID_EX_regwrite=1'b0,EX_MEM_regwrite=1'b0,MEM_WB_regwrite=1'b0;//regwrite

reg ID_EX_RFsrca2=1'b0,EX_MEM_RFsrca2=1'b0,MEM_WB_RFsrca2=1'b0;//RFsrca2

reg [2:0] ID_EX_RFsrcd2=3'b0,EX_MEM_RFsrcd2=3'b0,MEM_WB_RFsrcd2=3'b0;//RFsrcd2

reg [1:0] ID_EX_alu2srca=2'b0;//alu2srca

reg [1:0] ID_EX_alu2srcb=2'b0;//alu2srcb

reg [1:0] ID_EX_cysrc=2'b0,EX_MEM_cysrc=2'b0,MEM_WB_cysrc=2'b0;//cysrc

reg [2:0] ID_EX_Accsrc=3'b0,EX_MEM_Accsrc=3'b0,MEM_WB_Accsrc=3'b0;//Accsrc

reg ID_EX_Accwrite=1'b0,EX_MEM_Accwrite=1'b0,MEM_WB_Accwrite=1'b0;//Accwrite

reg [1:0] ID_EX_DMsrca=2'b0,EX_MEM_DMsrca=2'b0;//DMsrca

reg [1:0] ID_EX_DMsrcd=2'b0,EX_MEM_DMsrcd=2'b0;//DMsrcd

reg ID_EX_read=1'b0,EX_MEM_read=1'b0;//read

reg ID_EX_write=1'b0,EX_MEM_write=1'b0;//write

reg ID_EX_cywrite=1'b0,EX_MEM_cywrite=1'b0,MEM_WB_cywrite=1'b0;//cywrite

reg ID_EX_zwrite=1'b0,EX_MEM_zwrite=1'b0,MEM_WB_zwrite=1'b0;//zwrite

reg ID_EX_cinsrc=1'b0,EX_MEM_cinsrc=1'b0,MEM_WB_cinsrc=1'b0;//cinsrc

reg ID_EX_zsrc=1'b0,EX_MEM_zsrc=1'b0,MEM_WB_zsrc=1'b0;//zsrc

// branch prediction

reg [18:0] lookup [3:0];// 7:0 pc 15:8 bta 17:16 HB 18 full
integer i;

initial
begin
for(i=0;i<4;i=i+1) 
begin
lookup[i]=19'b0;

end
end

wire alu1_bta;
wire lookupwrite;
reg IF_ID_lookupwrite=1'b1,ID_EX_lookupwrite=1'b1;
wire [1:0] lookupindex;
reg [1:0] IF_ID_lookupindex=2'b00,ID_EX_lookupindex=2'b00,IF_ID_lookupindex1=2'b00;

assign lookupindex=(pc==lookup[0][7:0])?2'b00:
						 (pc==lookup[1][7:0])?2'b01:
						 (pc==lookup[2][7:0])?2'b10:
						 (pc==lookup[3][7:0])?2'b11:2'b00;

assign alu1_bta=(((pc==lookup[0][7:0])&&(lookup[0][17]==1'b1))||((pc==lookup[1][7:0])&&(lookup[1][17]==1'b1))||((pc==lookup[2][7:0])&&(lookup[2][17]==1'b1))||((pc==lookup[3][7:0])&&(lookup[3][17]==1'b1)));

assign lookupwrite=~((pc==lookup[0][7:0])||(pc==lookup[1][7:0])||(pc==lookup[2][7:0])||(pc==lookup[3][7:0]));




// branch prediction reading end 


assign pc_next=((ID_EX_pcsrc & ~{{2{stall_jump}}})==2'b00)?((alu1_bta)?lookup[lookupindex][15:8]:alu1out):// with branch prediction
               ((ID_EX_pcsrc & ~{{2{stall_jump}}})==2'b01)?(alu2out):
					((ID_EX_pcsrc & ~{{2{stall_jump}}})==2'b10)?(ID_EX_RF_d1):alu1out;


//assign pc_next=(ID_EX_pcsrc==2'b00)?(alu1out):// without branch prediction
//               (ID_EX_pcsrc==2'b01)?(alu2out):
//					(ID_EX_pcsrc==2'b10)?(ID_EX_RF_d1):alu1out;

assign ACC=Accout;
assign RF_a1=(RFsrca1==2'b00)?IF_ID_IM_d[10:8]:
             (RFsrca1==2'b01)?IF_ID_IM_d[2:0]:
				 (RFsrca1==2'b10)?3'b110:3'bxxx;

assign RF_a2=(MEM_WB_RFsrca2)?3'b110:MEM_WB_IM_d[10:8];

assign Accin=(MEM_WB_Accsrc==3'b000)?MEM_WB_alu2out:
             (MEM_WB_Accsrc==3'b001)?MEM_WB_DM_dr[7:0]:
				 (MEM_WB_Accsrc==3'b010)?MEM_WB_RF_d1:
				 (MEM_WB_Accsrc==3'b011)?MEM_WB_IM_d[7:0]:
				 (MEM_WB_Accsrc==3'b100)?alu3out:8'hxx;

assign alu2_a=(ID_EX_alu2srca==2'b00)?ID_EX_Accout:
              (ID_EX_alu2srca==2'b01)?ID_EX_RF_d1:
				  (ID_EX_alu2srca==2'b10)?ID_EX_alu1out:
				  (ID_EX_alu2srca==2'b11)?{7'b0,cy}:8'hxx;

assign alu2_b=(ID_EX_alu2srcb==2'b00)?ID_EX_RF_d1:
              (ID_EX_alu2srcb==2'b01)?ID_EX_IM_d[7:0]:
				  (ID_EX_alu2srcb==2'b10)?8'b1:
				  (ID_EX_alu2srcb==2'b11)?8'hFF:8'hxx;

assign RF_d2=(MEM_WB_RFsrcd2==3'b000)?MEM_WB_Accout:
             (MEM_WB_RFsrcd2==3'b001)?MEM_WB_RF_d1:
				 (MEM_WB_RFsrcd2==3'b010)?MEM_WB_DM_dr[7:0]:
				 (MEM_WB_RFsrcd2==3'b011)?MEM_WB_IM_d[7:0]:
				 (MEM_WB_RFsrcd2==3'b100)?MEM_WB_alu1out:
				 (MEM_WB_RFsrcd2==3'b101)?MEM_WB_alu2out:8'hxx;

assign DM_a=(EX_MEM_DMsrca==2'b00)?EX_MEM_RF_d1:
            (EX_MEM_DMsrca==2'b01)?EX_MEM_RF_d3:
				(EX_MEM_DMsrca==2'b10)?EX_MEM_IM_d[7:0]:8'hxx;

assign DM_dw=(EX_MEM_DMsrcd==2'b00)?{8'h0,EX_MEM_Accout}:
             (EX_MEM_DMsrcd==2'b01)?{8'h0,EX_MEM_RF_d1}:
				 (EX_MEM_DMsrcd==2'b10)?{8'h0,EX_MEM_IM_d[7:0]}:16'hxxxx;


assign cy_in=(MEM_WB_cysrc==2'b00)?MEM_WB_cy:
             (MEM_WB_cysrc==2'b01)?MEM_WB_alu2out[0]:
				 (MEM_WB_cysrc==2'b10)?1'b0:
				 (MEM_WB_cysrc==2'b11)?cy3:1'b0;

assign cin=(ID_EX_cinsrc)?cin_new:1'b0;

assign cin_alu3=(MEM_WB_cinsrc)?cy:1'b0;

assign z_in=(MEM_WB_zsrc)?z3:MEM_WB_z;

assign Acc_new=(Acc_select==4'b0000)?Accout:
               (Acc_select==4'b0001)?DM_dr[7:0]:
					(Acc_select==4'b0010)?MEM_WB_DM_dr[7:0]:
					(Acc_select==4'b0011)?alu2out:
					(Acc_select==4'b0100)?EX_MEM_alu2out:
					(Acc_select==4'b0101)?MEM_WB_alu2out:
					(Acc_select==4'b0110)?alu3out:
					(Acc_select==4'b0111)?ID_EX_RF_d1:
					(Acc_select==4'b1000)?EX_MEM_RF_d1:
					(Acc_select==4'b1001)?MEM_WB_RF_d1:
					(Acc_select==4'b1010)?ID_EX_IM_d[7:0]:
					(Acc_select==4'b1011)?EX_MEM_IM_d[7:0]:
					(Acc_select==4'b1100)?MEM_WB_IM_d[7:0]:8'hxx;

assign RF_d1_new=(RF_d1_select==4'b0000)?RF_d1:
                 (RF_d1_select==4'b0001)?alu2out:
					  (RF_d1_select==4'b0010)?EX_MEM_alu2out:
					  (RF_d1_select==4'b0011)?MEM_WB_alu2out:
					  (RF_d1_select==4'b0100)?ID_EX_RF_d1:
					  (RF_d1_select==4'b0101)?EX_MEM_RF_d1:
					  (RF_d1_select==4'b0110)?MEM_WB_RF_d1:
					  (RF_d1_select==4'b0111)?ID_EX_IM_d[7:0]:
					  (RF_d1_select==4'b1000)?EX_MEM_IM_d[7:0]:
					  (RF_d1_select==4'b1001)?MEM_WB_IM_d[7:0]:
					  (RF_d1_select==4'b1010)?ID_EX_Accout:
					  (RF_d1_select==4'b1011)?EX_MEM_Accout:
					  (RF_d1_select==4'b1100)?MEM_WB_Accout:
					  (RF_d1_select==4'b1101)?DM_dr[7:0]:
					  (RF_d1_select==4'b1110)?MEM_WB_DM_dr[7:0]:8'hxx;
					  
assign RF_d3_new=(RF_d3_select==4'b0000)?RF_d3:
                 (RF_d3_select==4'b0001)?alu2out:
					  (RF_d3_select==4'b0010)?EX_MEM_alu2out:
					  (RF_d3_select==4'b0011)?MEM_WB_alu2out:
					  (RF_d3_select==4'b0100)?ID_EX_RF_d1:
					  (RF_d3_select==4'b0101)?EX_MEM_RF_d1:
					  (RF_d3_select==4'b0110)?MEM_WB_RF_d1:
					  (RF_d3_select==4'b0111)?ID_EX_IM_d[7:0]:
					  (RF_d3_select==4'b1000)?EX_MEM_IM_d[7:0]:
					  (RF_d3_select==4'b1001)?MEM_WB_IM_d[7:0]:
					  (RF_d3_select==4'b1010)?ID_EX_Accout:
					  (RF_d3_select==4'b1011)?EX_MEM_Accout:
					  (RF_d3_select==4'b1100)?MEM_WB_Accout:
					  (RF_d3_select==4'b1101)?DM_dr[7:0]:
					  (RF_d3_select==4'b1110)?MEM_WB_DM_dr[7:0]:8'hxx;

assign cin_new=(cin_select==3'b000)?EX_MEM_cy:
               (cin_select==3'b001)?MEM_WB_cy:
					(cin_select==3'b010)?cy:
					(cin_select==3'b011)?EX_MEM_alu2out[0]:
					(cin_select==3'b100)?MEM_WB_alu2out[0]:1'b0;

assign cy_new=(cy_select==3'b000)?EX_MEM_cy:
              (cy_select==3'b001)?MEM_WB_cy:
				  (cy_select==3'b010)?cy:
				  (cy_select==3'b011)?cy2:
				  (cy_select==3'b100)?cy3:cy;

assign z_new=(z_select==3'b000)?EX_MEM_z:
             (z_select==3'b001)?MEM_WB_z:
				 (z_select==3'b010)?z:
				 (z_select==3'b011)?z2:
				 (z_select==3'b100)?z3:z;

				 
// branch prediction writing


always @(*)// in ID stage
begin 
if(IF_ID_lookupwrite==1'b1) begin

if((IF_ID_IM_d[15:11]==5'b01111)||(IF_ID_IM_d[15:11]==5'b10000)||(IF_ID_IM_d[15:11]==5'b10001)||(IF_ID_IM_d[15:11]==5'b10010)||((IF_ID_IM_d[15:11]==5'b00100)&&(IF_ID_IM_d[7:3]==5'b01101)))// jmp,jnz,jnc,call,ret
begin
if(lookup[0][18]==1'b0)// full=0
IF_ID_lookupindex=2'b00;
else if(lookup[1][18]==1'b0)// full=0
IF_ID_lookupindex=2'b01;
else if(lookup[2][18]==1'b0)// full=0
IF_ID_lookupindex<=2'b10;
else if(lookup[3][18]==1'b0)// full=0
IF_ID_lookupindex=2'b11;
else// full=0
IF_ID_lookupindex=2'b00;
end

else 
IF_ID_lookupindex<=2'b00;

end

else
IF_ID_lookupindex=IF_ID_lookupindex1;


end






always @(posedge clk)// in execute stage
begin
if(ID_EX_lookupwrite==1'b1) begin
if((ID_EX_IM_d[15:11]==5'b01111)||(ID_EX_IM_d[15:11]==5'b10000)||(ID_EX_IM_d[15:11]==5'b10001)||(ID_EX_IM_d[15:11]==5'b10010))// jmp,jnz,jnc,call
begin
lookup[ID_EX_lookupindex][15:8]<=alu2out;
lookup[ID_EX_lookupindex][17:16]<=(ID_EX_pcsrc!=2'b00)?2'b11:2'b00;
lookup[ID_EX_lookupindex][7:0]<=ID_EX_pc;
lookup[ID_EX_lookupindex][18]<=1'b1;
end
else if((ID_EX_IM_d[15:11]==5'b00100)&&(ID_EX_IM_d[7:3]==5'b01101))// RET
begin
lookup[ID_EX_lookupindex][15:8]<=ID_EX_RF_d1;
lookup[ID_EX_lookupindex][17:16]<=(ID_EX_pcsrc!=2'b00)?2'b11:2'b00;
lookup[ID_EX_lookupindex][7:0]<=ID_EX_pc;
lookup[ID_EX_lookupindex][18]<=1'b1;
end
end

else begin
if(((ID_EX_pcsrc==2'b00)&&(lookup[ID_EX_lookupindex][17:16]==2'b11))&&((ID_EX_IM_d[15:11]==5'b10000)||(ID_EX_IM_d[15:11]==5'b10001)))
lookup[ID_EX_lookupindex][17:16]<=2'b10;
else if(((ID_EX_pcsrc==2'b00)&&(lookup[ID_EX_lookupindex][17:16]==2'b10))&&((ID_EX_IM_d[15:11]==5'b10000)||(ID_EX_IM_d[15:11]==5'b10001)))
lookup[ID_EX_lookupindex][17:16]<=2'b00;
else if(((ID_EX_pcsrc==2'b00)&&(lookup[ID_EX_lookupindex][17:16]==2'b01))&&((ID_EX_IM_d[15:11]==5'b10000)||(ID_EX_IM_d[15:11]==5'b10001)))
lookup[ID_EX_lookupindex][17:16]<=2'b00;
else if(((ID_EX_pcsrc!=2'b00)&&(lookup[ID_EX_lookupindex][17:16]==2'b00))&&((ID_EX_IM_d[15:11]==5'b10000)||(ID_EX_IM_d[15:11]==5'b10001)))
lookup[ID_EX_lookupindex][17:16]<=2'b01;
else if(((ID_EX_pcsrc!=2'b00)&&(lookup[ID_EX_lookupindex][17:16]==2'b01))&&((ID_EX_IM_d[15:11]==5'b10000)||(ID_EX_IM_d[15:11]==5'b10001)))
lookup[ID_EX_lookupindex][17:16]<=2'b11;
else if(((ID_EX_pcsrc!=2'b00)&&(lookup[ID_EX_lookupindex][17:16]==2'b10))&&((ID_EX_IM_d[15:11]==5'b10000)||(ID_EX_IM_d[15:11]==5'b10001)))
lookup[ID_EX_lookupindex][17:16]<=2'b11;
end

end


// branch prediction writing end			 

IM_8085 IM1(pc,IM_d);

adder_8085 alu1(pc,8'b1,alu1out);

ALU_8085 alu2(alu2_a,alu2_b,cin,op,z2,cy2,alu2out);

ALU_8085 alu3(MEM_WB_Accout,MEM_WB_DM_dr[7:0],cin_alu3,MEM_WB_op,z3,cy3,alu3out);

DM_8085 DM1(DM_a,DM_dr,DM_dw,clk,EX_MEM_read,EX_MEM_write);

RF_8085_single RF1(RF_a1,RF_a2,IF_ID_IM_d[10:8],RF_d1,RF_d2,RF_d3,clk,MEM_WB_regwrite);

ACC_8085 ACC1(clk,Accin,Accout,MEM_WB_Accwrite);

flag cy_flag(cy_in,cy,clk,MEM_WB_cywrite);

flag z_flag(z_in,z,clk,MEM_WB_zwrite);

alucontrol_8085_single alucontr(ID_EX_IM_d[15:11],ID_EX_IM_d[7:3],op);

controller_8085_single contr_single(IF_ID_IM_d[15:11],IF_ID_IM_d[7:3],z_new,cy_new,pcwrite,regwrite,Accwrite,read,write,cywrite,zwrite,RFsrca2,cinsrc,zsrc,pcsrc,RFsrca1,alu2srca,alu2srcb,DMsrca,DMsrcd,cysrc,Accsrc,RFsrcd2);

hazard_control_8085 h1(ID_EX_pcsrc,EX_MEM_pcsrc,IF_ID_IM_d,ID_EX_IM_d,EX_MEM_IM_d,MEM_WB_IM_d,Acc_select,RF_d1_select,RF_d3_select,cin_select,cy_select,z_select,stall_load,stall_indirect,stall_jump,lookup[ID_EX_lookupindex][17]);

//IF_ID stage
always @(posedge clk)
begin
if(ID_EX_pcwrite & stall_load & stall_indirect)
begin
if(stall_jump)//new
begin
IF_ID_pc<=pc;// new
IF_ID_lookupindex1<=lookupindex;
IF_ID_lookupwrite<=lookupwrite;// new
IF_ID_IM_d<=IM_d;
IF_ID_alu1out<=alu1out;
pc<=pc_next;
end
else if(lookup[ID_EX_lookupindex][17] & ~stall_jump) begin
IF_ID_pc<=pc;
IF_ID_lookupindex1<=lookupindex;
IF_ID_IM_d<=16'h2078;
IF_ID_alu1out<=alu1out;
pc<=lookup[ID_EX_lookupindex][7:0]+8'b1;
IF_ID_lookupwrite<=lookupwrite;
end
else 
begin
IF_ID_pc<=pc;// new
IF_ID_lookupindex1<=lookupindex;
IF_ID_lookupwrite<=lookupwrite;// new
IF_ID_IM_d<=16'h2078;
IF_ID_alu1out<=alu1out;
pc<=pc_next;
end
end
end

//ID_EX stage
always @(posedge clk)
begin
if(ID_EX_pcwrite & stall_load & stall_indirect) begin
if(stall_jump)
begin
ID_EX_pc<=IF_ID_pc;// new
ID_EX_lookupindex<=IF_ID_lookupindex;
ID_EX_lookupwrite<=IF_ID_lookupwrite;// new
ID_EX_IM_d<=IF_ID_IM_d;
ID_EX_Accout<=Acc_new;
ID_EX_alu1out<=IF_ID_alu1out;
ID_EX_RF_d1<=RF_d1_new;
ID_EX_RF_d3<=RF_d3_new;

//control signals


ID_EX_pcsrc<=pcsrc;
ID_EX_pcwrite<=pcwrite;
ID_EX_RFsrca2<=RFsrca2;
ID_EX_regwrite<=regwrite;
ID_EX_RFsrcd2<=RFsrcd2;
ID_EX_alu2srca<=alu2srca;
ID_EX_alu2srcb<=alu2srcb;
ID_EX_cysrc<=cysrc;
ID_EX_Accsrc<=Accsrc;
ID_EX_Accwrite<=Accwrite;
ID_EX_DMsrca<=DMsrca;
ID_EX_DMsrcd<=DMsrcd;
ID_EX_read<=read;
ID_EX_write<=write;
ID_EX_cywrite<=cywrite;
ID_EX_zwrite<=zwrite;
ID_EX_cinsrc<=cinsrc;
ID_EX_zsrc<=zsrc;
end

else
begin
ID_EX_pc<=IF_ID_pc;// new
ID_EX_lookupindex<=IF_ID_lookupindex;// new
ID_EX_lookupwrite<=IF_ID_lookupwrite;// new
ID_EX_IM_d<=16'h2078;
ID_EX_Accout<=0;
ID_EX_alu1out<=0;
ID_EX_RF_d1<=0;
ID_EX_RF_d3<=0;

//control signals


ID_EX_pcsrc<=0;
ID_EX_pcwrite<=1'b1;
ID_EX_RFsrca2<=0;
ID_EX_regwrite<=1'b0;
ID_EX_RFsrcd2<=0;
ID_EX_alu2srca<=0;
ID_EX_alu2srcb<=0;
ID_EX_cysrc<=0;
ID_EX_Accsrc<=0;
ID_EX_Accwrite<=1'b0;
ID_EX_DMsrca<=0;
ID_EX_DMsrcd<=0;
ID_EX_read<=1'b0;
ID_EX_write<=1'b0;
ID_EX_cywrite<=1'b0;
ID_EX_zwrite<=1'b0;
ID_EX_cinsrc<=0;
ID_EX_zsrc<=0;
end
end
end

//EX_MEM stage
always @(posedge clk)
begin

EX_MEM_IM_d<=ID_EX_IM_d;
EX_MEM_Accout<=ID_EX_Accout;
EX_MEM_alu1out<=ID_EX_alu1out;
EX_MEM_alu2out<=alu2out;
EX_MEM_RF_d1<=ID_EX_RF_d1;
EX_MEM_RF_d3<=ID_EX_RF_d3;
EX_MEM_cy<=cy2;
EX_MEM_z<=z2;
EX_MEM_op<=op;

//control signals
EX_MEM_pcsrc<=ID_EX_pcsrc;
EX_MEM_RFsrca2<=ID_EX_RFsrca2;
EX_MEM_regwrite<=ID_EX_regwrite;
EX_MEM_RFsrcd2<=ID_EX_RFsrcd2;
EX_MEM_cysrc<=ID_EX_cysrc;
EX_MEM_Accsrc<=ID_EX_Accsrc;
EX_MEM_Accwrite<=ID_EX_Accwrite;
EX_MEM_DMsrca<=ID_EX_DMsrca;
EX_MEM_DMsrcd<=ID_EX_DMsrcd;
EX_MEM_read<=ID_EX_read;
EX_MEM_write<=ID_EX_write;
EX_MEM_cywrite<=ID_EX_cywrite;
EX_MEM_zwrite<=ID_EX_zwrite;
EX_MEM_cinsrc<=ID_EX_cinsrc;
EX_MEM_zsrc<=ID_EX_zsrc;

end

//MEM_WB stage
always @(posedge clk)
begin

MEM_WB_IM_d<=EX_MEM_IM_d;
MEM_WB_Accout<=EX_MEM_Accout;
MEM_WB_alu1out<=EX_MEM_alu1out;
MEM_WB_alu2out<=EX_MEM_alu2out;
MEM_WB_RF_d1<=EX_MEM_RF_d1;
MEM_WB_DM_dr<=DM_dr;
MEM_WB_cy<=EX_MEM_cy;
MEM_WB_z<=EX_MEM_z;
MEM_WB_op<=EX_MEM_op;

//control signals
MEM_WB_RFsrca2<=EX_MEM_RFsrca2;
MEM_WB_regwrite<=EX_MEM_regwrite;
MEM_WB_RFsrcd2<=EX_MEM_RFsrcd2;
MEM_WB_cysrc<=EX_MEM_cysrc;
MEM_WB_Accsrc<=EX_MEM_Accsrc;
MEM_WB_Accwrite<=EX_MEM_Accwrite;
MEM_WB_cywrite<=EX_MEM_cywrite;
MEM_WB_zwrite<=EX_MEM_zwrite;
MEM_WB_cinsrc<=EX_MEM_cinsrc;
MEM_WB_zsrc<=EX_MEM_zsrc;

end

endmodule

