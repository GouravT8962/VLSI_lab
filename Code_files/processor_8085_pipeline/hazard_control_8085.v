module hazard_control_8085(ID_EX_pcsrc,EX_MEM_pcsrc,IF_ID_IM_d,ID_EX_IM_d,EX_MEM_IM_d,MEM_WB_IM_d,Acc_select,RF_d1_select,RF_d3_select,cin_select,cy_select,z_select,stall_load,stall_indirect,stall_jump,HB);
input [15:0] IF_ID_IM_d,ID_EX_IM_d,EX_MEM_IM_d,MEM_WB_IM_d;
input [1:0] ID_EX_pcsrc,EX_MEM_pcsrc;
input HB;
output reg [3:0]  Acc_select=4'b0000,RF_d1_select=4'b0000,RF_d3_select=4'b0000;
output reg [2:0] cy_select=3'b010,z_select=3'b010;
output reg [2:0] cin_select=3'b010;
output reg stall_load=1'b1;
output reg stall_indirect=1'b1;
output reg stall_jump=1'b1;

always @(*)
begin
if((((ID_EX_IM_d[15:11]==5'b01101)||(ID_EX_IM_d[15:11]==5'b11010))&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))&&(ID_EX_IM_d!=EX_MEM_IM_d))
stall_load=1'b0;
else
stall_load=1'b1;
end

always @(*)
begin
if(((ID_EX_IM_d[15:11]==5'b00010)&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||((IF_ID_IM_d[15:11]==5'b00100)&&((IF_ID_IM_d[7:3]==5'b01010)||(IF_ID_IM_d[7:3]==5'b01011)))||(IF_ID_IM_d[15:11]==5'b01110)||(IF_ID_IM_d[15:11]==5'b10000)||(IF_ID_IM_d[15:11]==5'b10001)))&&(ID_EX_IM_d!=MEM_WB_IM_d))
stall_indirect=1'b0;// reg indirect
else if(((ID_EX_IM_d[15:11]==5'b11010)&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||((IF_ID_IM_d[15:11]==5'b00100)&&((IF_ID_IM_d[7:3]==5'b01010)||(IF_ID_IM_d[7:3]==5'b01011)))||(IF_ID_IM_d[15:11]==5'b01110)))&&(ID_EX_IM_d!=MEM_WB_IM_d))
stall_indirect=1'b0;// mov a,m
else if((ID_EX_IM_d[15:11]==5'b10110)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==ID_EX_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==ID_EX_IM_d[10:8]))))
stall_indirect=1'b0;// mov r,m
else
stall_indirect=1'b1;
end

always @(*)
begin
//if(ID_EX_pcsrc!=2'b00) old
if(((ID_EX_pcsrc!=2'b00)&&(HB==1'b0))||((ID_EX_pcsrc==2'b00)&&(HB==1'b1)&&((ID_EX_IM_d[15:11]==5'b01111)||(ID_EX_IM_d[15:11]==5'b10000)||(ID_EX_IM_d[15:11]==5'b10001)||(ID_EX_IM_d[15:11]==5'b10010)||((ID_EX_IM_d[15:11]==5'b00100)&&(ID_EX_IM_d[7:3]==5'b01101)))))
stall_jump=1'b0;
else
stall_jump=1'b1;
end





always @(*)
begin
if((((ID_EX_IM_d[15:11]==5'b00000)&&(ID_EX_IM_d[7:3]!=5'b01001))||((ID_EX_IM_d[15:11]==5'b00100)&&(ID_EX_IM_d[7:3]==5'b01010))||(ID_EX_IM_d[15:11]==5'b00101)||(ID_EX_IM_d[15:11]==5'b00110)||(ID_EX_IM_d[15:11]==5'b00111)||(ID_EX_IM_d[15:11]==5'b01000)||(ID_EX_IM_d[15:11]==5'b01001)||(ID_EX_IM_d[15:11]==5'b01010)||(ID_EX_IM_d[15:11]==5'b01011)||(ID_EX_IM_d[15:11]==5'b01100))&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//first instr is reg direct(except cmp )or immediate and other is dependent on Acc
Acc_select=4'b0011;//alu2out
else if((ID_EX_IM_d[15:11]==5'b11001)&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//mov a,r
Acc_select=4'b0111;//ID_EX_RF_d1
else if((ID_EX_IM_d[15:11]==5'b11100)&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//mvi a,8
Acc_select=4'b1010;//ID_EX_IM_d[7:0]
else if(((EX_MEM_IM_d[15:11]==5'b01101)||(EX_MEM_IM_d[15:11]==5'b11010))&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//first instr is lda and MOVAM and other is which depend on Acc 1 stall cycle
Acc_select=4'b0001;//DM_d
else if((((EX_MEM_IM_d[15:11]==5'b00000)&&(EX_MEM_IM_d[7:3]!=5'b01001))||((EX_MEM_IM_d[15:11]==5'b00100)&&(EX_MEM_IM_d[7:3]==5'b01010))||(EX_MEM_IM_d[15:11]==5'b00101)||(EX_MEM_IM_d[15:11]==5'b00110)||(EX_MEM_IM_d[15:11]==5'b00111)||(EX_MEM_IM_d[15:11]==5'b01000)||(EX_MEM_IM_d[15:11]==5'b01001)||(EX_MEM_IM_d[15:11]==5'b01010)||(EX_MEM_IM_d[15:11]==5'b01011)||(EX_MEM_IM_d[15:11]==5'b01100))&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//first instr is reg direct(except cmp)or immediate and other is dependent on Acc
Acc_select=4'b0100;//EX_MEM_alu2out
else if((EX_MEM_IM_d[15:11]==5'b11001)&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//mov a,r
Acc_select=4'b1000;//EX_MEM_RF_d1
else if((EX_MEM_IM_d[15:11]==5'b11100)&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//mvi a,8
Acc_select=4'b1011;//EX_MEM_IM_d[7:0]
else if(((MEM_WB_IM_d[15:11]==5'b01101)||(MEM_WB_IM_d[15:11]==5'b11010))&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//first instr is lda and MOVAM and next after next is depend on Acc
Acc_select=4'b0010;//MEM_WB_DM_d
else if((((MEM_WB_IM_d[15:11]==5'b00000)&&(MEM_WB_IM_d[7:3]!=5'b01001))||((EX_MEM_IM_d[15:11]==5'b00100)&&(EX_MEM_IM_d[7:3]==5'b01010))||(MEM_WB_IM_d[15:11]==5'b00101)||(MEM_WB_IM_d[15:11]==5'b00110)||(MEM_WB_IM_d[15:11]==5'b00111)||(MEM_WB_IM_d[15:11]==5'b01000)||(MEM_WB_IM_d[15:11]==5'b01001)||(MEM_WB_IM_d[15:11]==5'b01010)||(MEM_WB_IM_d[15:11]==5'b01011)||(MEM_WB_IM_d[15:11]==5'b01100))&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//first instr is reg direct(except cmp) or immediate and other is dependent on Acc
Acc_select=4'b0101;//MEM_WB_alu2out
else if(((MEM_WB_IM_d[15:11]==5'b00010)&&(MEM_WB_IM_d[7:3]!=5'b01001))&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//first instr is reg indirect and other depend on Acc 2stall cycle
Acc_select=4'b0110;//alu3out
else if((MEM_WB_IM_d[15:11]==5'b11001)&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//mov a,r
Acc_select=4'b1001;//MEM_WB_RF_d1
else if((MEM_WB_IM_d[15:11]==5'b11100)&&((IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b11000)||(IF_ID_IM_d[15:11]==5'b11011)||(IF_ID_IM_d[15:11]==5'b00100)||(IF_ID_IM_d[15:11]==5'b01110)))
//mvi a,8
Acc_select=4'b1100;//MEM_WB_IM_d[7:0]
else 
Acc_select=4'b0000;//Accout
end


always @(*)
begin
if((ID_EX_IM_d[15:11]==5'b00001)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==ID_EX_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==ID_EX_IM_d[10:8]))))
// inr/dcr r
RF_d1_select=4'b0001;//alu2out
else if((ID_EX_IM_d[15:11]==5'b10101)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==ID_EX_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==ID_EX_IM_d[10:8]))))
// mov r,r
RF_d1_select=4'b0100;//ID_EX_RF_d1
else if((ID_EX_IM_d[15:11]==5'b10011)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==ID_EX_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==ID_EX_IM_d[10:8]))))
//mvi r,8
RF_d1_select=4'b0111;//ID_EX_IM_d[7:0]
else if((ID_EX_IM_d[15:11]==5'b11000)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==ID_EX_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==ID_EX_IM_d[10:8]))))
// mov r,a
RF_d1_select=4'b1010;//ID_EX_Accout
else if((EX_MEM_IM_d[15:11]==5'b00001)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==EX_MEM_IM_d[10:8]))))
// inr/dcr r
RF_d1_select=4'b0010;//EX_MEM_alu2out
else if((EX_MEM_IM_d[15:11]==5'b10101)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==EX_MEM_IM_d[10:8]))))
// mov r,r
RF_d1_select=4'b0101;//EX_MEM_RF_d1
else if((EX_MEM_IM_d[15:11]==5'b10011)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==EX_MEM_IM_d[10:8]))))
// mvi r,8
RF_d1_select=4'b1000;//EX_MEM_IM_d[7:0]
else if((EX_MEM_IM_d[15:11]==5'b11000)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==EX_MEM_IM_d[10:8]))))
// mov r,a
RF_d1_select=4'b1011;//EX_MEM_Accout
else if((EX_MEM_IM_d[15:11]==5'b10110)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==EX_MEM_IM_d[10:8]))))
// mov r,m
RF_d1_select=4'b1101;//DM_d
else if((MEM_WB_IM_d[15:11]==5'b00001)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==MEM_WB_IM_d[10:8]))))
// inr/dcr r
RF_d1_select=4'b0011;//MEM_WB_alu2out
else if((MEM_WB_IM_d[15:11]==5'b10101)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==MEM_WB_IM_d[10:8]))))
// mov r,r
RF_d1_select=4'b0110;//MEM_WB_RF_d1
else if((MEM_WB_IM_d[15:11]==5'b10011)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==MEM_WB_IM_d[10:8]))))
// mvi r,8
RF_d1_select=4'b1001;//MEM_WB_RF_IM_d[7:0]
else if((MEM_WB_IM_d[15:11]==5'b11000)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==MEM_WB_IM_d[10:8]))))
// mov r,a
RF_d1_select=4'b1100;//MEM_WB_Accout
else if((MEM_WB_IM_d[15:11]==5'b10110)&&((((IF_ID_IM_d[15:11]==5'b11001)||(IF_ID_IM_d[15:11]==5'b00000)||(IF_ID_IM_d[15:11]==5'b00010)||(IF_ID_IM_d[15:11]==5'b00001)||(IF_ID_IM_d[15:11]==5'b00101)||(IF_ID_IM_d[15:11]==5'b00110)||(IF_ID_IM_d[15:11]==5'b00111)||(IF_ID_IM_d[15:11]==5'b01000)||(IF_ID_IM_d[15:11]==5'b01001)||(IF_ID_IM_d[15:11]==5'b01010)||(IF_ID_IM_d[15:11]==5'b01011)||(IF_ID_IM_d[15:11]==5'b01100)||(IF_ID_IM_d[15:11]==5'b10100)||(IF_ID_IM_d[15:11]==5'b11010)||(IF_ID_IM_d[15:11]==5'b11011))&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))||(((IF_ID_IM_d[15:11]==5'b10101)||(IF_ID_IM_d[15:11]==5'b10111)||(IF_ID_IM_d[15:11]==5'b10110))&&(IF_ID_IM_d[2:0]==MEM_WB_IM_d[10:8]))))
// mov r,m
RF_d1_select=4'b1110;//MEM_WB_DM_d
else 
RF_d1_select=4'b0000;//RF_d1
end

always @(*)// RF_d3_select
begin
if((ID_EX_IM_d[15:11]==5'b00001)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==ID_EX_IM_d[10:8]))
// inr/dcr r
RF_d3_select=4'b0001;//alu2out
else if((ID_EX_IM_d[15:11]==5'b10101)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==ID_EX_IM_d[10:8]))
// mov r,r
RF_d3_select=4'b0100;//ID_EX_RF_d1
else if((ID_EX_IM_d[15:11]==5'b10011)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==ID_EX_IM_d[10:8]))
//mvi r,8
RF_d3_select=4'b0111;//ID_EX_IM_d[7:0]
else if((ID_EX_IM_d[15:11]==5'b11000)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==ID_EX_IM_d[10:8]))
// mov r,a
RF_d3_select=4'b1010;//ID_EX_Accout
else if((EX_MEM_IM_d[15:11]==5'b00001)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))
// inr/dcr r
RF_d3_select=4'b0010;//EX_MEM_alu2out
else if((EX_MEM_IM_d[15:11]==5'b10101)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))
// mov r,r
RF_d3_select=4'b0101;//EX_MEM_RF_d1
else if((EX_MEM_IM_d[15:11]==5'b10011)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))
// mvi r,8
RF_d3_select=4'b1000;//EX_MEM_IM_d[7:0]
else if((EX_MEM_IM_d[15:11]==5'b11000)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))
// mov r,a
RF_d3_select=4'b1011;//EX_MEM_Accout
else if((EX_MEM_IM_d[15:11]==5'b10110)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==EX_MEM_IM_d[10:8]))
// mov r,m
RF_d3_select=4'b1101;//DM_d
else if((MEM_WB_IM_d[15:11]==5'b00001)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))
// inr/dcr r
RF_d3_select=4'b0011;//MEM_WB_alu2out
else if((MEM_WB_IM_d[15:11]==5'b10101)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))
// mov r,r
RF_d3_select=4'b0110;//MEM_WB_RF_d1
else if((MEM_WB_IM_d[15:11]==5'b10011)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))
// mvi r,8
RF_d3_select=4'b1001;//MEM_WB_RF_IM_d[7:0]
else if((MEM_WB_IM_d[15:11]==5'b11000)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))
// mov r,a
RF_d3_select=4'b1100;//MEM_WB_Accout
else if((MEM_WB_IM_d[15:11]==5'b10110)&&(IF_ID_IM_d[15:11]==5'b10111)&&(IF_ID_IM_d[10:8]==MEM_WB_IM_d[10:8]))
// mov r,m
RF_d3_select=4'b1110;//MEM_WB_DM_d
else 
RF_d3_select=4'b0000;//RF_d1
end





always @(*)
begin
if(((EX_MEM_IM_d[15:11]==5'b00000)||(EX_MEM_IM_d[15:11]==5'b00101)||(EX_MEM_IM_d[15:11]==5'b00110)||(EX_MEM_IM_d[15:11]==5'b00111)||(EX_MEM_IM_d[15:11]==5'b01000)||(EX_MEM_IM_d[15:11]==5'b01001)||(EX_MEM_IM_d[15:11]==5'b01010)||(EX_MEM_IM_d[15:11]==5'b01011)||(EX_MEM_IM_d[15:11]==5'b01100))&&((((ID_EX_IM_d[15:11]==5'b00000)||(ID_EX_IM_d[15:11]==5'b00010))&&((ID_EX_IM_d[7:3]==5'b00001)||(ID_EX_IM_d[7:3]==5'b00011)))||(ID_EX_IM_d[15:11]==5'b00110)||(ID_EX_IM_d[15:11]==5'b01000)))
cin_select=3'b000;// EX_MEM_cy
else if(((EX_MEM_IM_d[15:11]==5'b00100)&&((EX_MEM_IM_d[7:3]==5'b01011)||(EX_MEM_IM_d[7:3]==5'b01100)))&&((((ID_EX_IM_d[15:11]==5'b00000)||(ID_EX_IM_d[15:11]==5'b00010))&&((ID_EX_IM_d[7:3]==5'b00001)||(ID_EX_IM_d[7:3]==5'b00011)))||(ID_EX_IM_d[15:11]==5'b00110)||(ID_EX_IM_d[15:11]==5'b01000)))
cin_select=3'b011;// EX_MEM_alu2out[0];
else if(((MEM_WB_IM_d[15:11]==5'b00000)||(MEM_WB_IM_d[15:11]==5'b00101)||(MEM_WB_IM_d[15:11]==5'b00110)||(MEM_WB_IM_d[15:11]==5'b00111)||(MEM_WB_IM_d[15:11]==5'b01000)||(MEM_WB_IM_d[15:11]==5'b01001)||(MEM_WB_IM_d[15:11]==5'b01010)||(MEM_WB_IM_d[15:11]==5'b01011)||(MEM_WB_IM_d[15:11]==5'b01100))&&((((ID_EX_IM_d[15:11]==5'b00000)||(ID_EX_IM_d[15:11]==5'b00010))&&((ID_EX_IM_d[7:3]==5'b00001)||(ID_EX_IM_d[7:3]==5'b00011)))||(ID_EX_IM_d[15:11]==5'b00110)||(ID_EX_IM_d[15:11]==5'b01000)))
cin_select=3'b001;//MEM_WB_cy
else if(((MEM_WB_IM_d[15:11]==5'b00100)&&((MEM_WB_IM_d[7:3]==5'b01011)||(MEM_WB_IM_d[7:3]==5'b01100)))&&((((ID_EX_IM_d[15:11]==5'b00000)||(ID_EX_IM_d[15:11]==5'b00010))&&((ID_EX_IM_d[7:3]==5'b00001)||(ID_EX_IM_d[7:3]==5'b00011)))||(ID_EX_IM_d[15:11]==5'b00110)||(ID_EX_IM_d[15:11]==5'b01000)))
cin_select=3'b100;// MEM_WB_alu2out[0];
else
cin_select=3'b010;//cy

end

always @(*)
begin
if(((ID_EX_IM_d[15:11]==5'b00000)||(ID_EX_IM_d[15:11]==5'b00101)||(ID_EX_IM_d[15:11]==5'b00110)||(ID_EX_IM_d[15:11]==5'b00111)||(ID_EX_IM_d[15:11]==5'b01000)||(ID_EX_IM_d[15:11]==5'b01001)||(ID_EX_IM_d[15:11]==5'b01010)||(ID_EX_IM_d[15:11]==5'b01011)||(ID_EX_IM_d[15:11]==5'b01100)||((ID_EX_IM_d[15:11]==5'b00100)&&((ID_EX_IM_d[7:3]==5'b01011)||(ID_EX_IM_d[7:3]==5'b01100))))&&(IF_ID_IM_d[15:11]==5'b10001))
cy_select=3'b011;// cy2
else if(((EX_MEM_IM_d[15:11]==5'b00000)||(EX_MEM_IM_d[15:11]==5'b00101)||(EX_MEM_IM_d[15:11]==5'b00110)||(EX_MEM_IM_d[15:11]==5'b00111)||(EX_MEM_IM_d[15:11]==5'b01000)||(EX_MEM_IM_d[15:11]==5'b01001)||(EX_MEM_IM_d[15:11]==5'b01010)||(EX_MEM_IM_d[15:11]==5'b01011)||(EX_MEM_IM_d[15:11]==5'b01100)||((EX_MEM_IM_d[15:11]==5'b00100)&&((EX_MEM_IM_d[7:3]==5'b01011)||(EX_MEM_IM_d[7:3]==5'b01100))))&&(IF_ID_IM_d[15:11]==5'b10001))
cy_select=3'b000;// EX_MEM_cy
else if(((MEM_WB_IM_d[15:11]==5'b00000)||(MEM_WB_IM_d[15:11]==5'b00101)||(MEM_WB_IM_d[15:11]==5'b00110)||(MEM_WB_IM_d[15:11]==5'b00111)||(MEM_WB_IM_d[15:11]==5'b01000)||(MEM_WB_IM_d[15:11]==5'b01001)||(MEM_WB_IM_d[15:11]==5'b01010)||(MEM_WB_IM_d[15:11]==5'b01011)||(MEM_WB_IM_d[15:11]==5'b01100)||((MEM_WB_IM_d[15:11]==5'b00100)&&((MEM_WB_IM_d[7:3]==5'b01011)||(MEM_WB_IM_d[7:3]==5'b01100))))&&(IF_ID_IM_d[15:11]==5'b10001))
cy_select=3'b001;//MEM_WB_cy
else if((MEM_WB_IM_d[15:11]==5'b00010)&&(IF_ID_IM_d[15:11]==5'b10001))
cy_select=3'b100;//cy3
else
cy_select=3'b010;//cy
end

always @(*)
begin
if(((ID_EX_IM_d[15:11]==5'b00000)||(ID_EX_IM_d[15:11]==5'b00001)||(ID_EX_IM_d[15:11]==5'b00011)||(ID_EX_IM_d[15:11]==5'b00101)||(ID_EX_IM_d[15:11]==5'b00110)||(ID_EX_IM_d[15:11]==5'b00111)||(ID_EX_IM_d[15:11]==5'b01000)||(ID_EX_IM_d[15:11]==5'b01001)||(ID_EX_IM_d[15:11]==5'b01010)||(ID_EX_IM_d[15:11]==5'b01011)||(ID_EX_IM_d[15:11]==5'b01100))&&(IF_ID_IM_d[15:11]==5'b10000))
z_select=3'b011;// z2
else if(((EX_MEM_IM_d[15:11]==5'b00000)||(EX_MEM_IM_d[15:11]==5'b00001)||(EX_MEM_IM_d[15:11]==5'b00011)||(EX_MEM_IM_d[15:11]==5'b00101)||(EX_MEM_IM_d[15:11]==5'b00110)||(EX_MEM_IM_d[15:11]==5'b00111)||(EX_MEM_IM_d[15:11]==5'b01000)||(EX_MEM_IM_d[15:11]==5'b01001)||(EX_MEM_IM_d[15:11]==5'b01010)||(EX_MEM_IM_d[15:11]==5'b01011)||(EX_MEM_IM_d[15:11]==5'b01100))&&(IF_ID_IM_d[15:11]==5'b10000))
z_select=3'b000;// EX_MEM_z
else if(((MEM_WB_IM_d[15:11]==5'b00000)||(MEM_WB_IM_d[15:11]==5'b00001)||(MEM_WB_IM_d[15:11]==5'b00011)||(MEM_WB_IM_d[15:11]==5'b00101)||(MEM_WB_IM_d[15:11]==5'b00110)||(MEM_WB_IM_d[15:11]==5'b00111)||(MEM_WB_IM_d[15:11]==5'b01000)||(MEM_WB_IM_d[15:11]==5'b01001)||(MEM_WB_IM_d[15:11]==5'b01010)||(MEM_WB_IM_d[15:11]==5'b01011)||(MEM_WB_IM_d[15:11]==5'b01100))&&(IF_ID_IM_d[15:11]==5'b10000))
z_select=3'b001;//MEM_WB_z
else if((MEM_WB_IM_d[15:11]==5'b00010)&&(IF_ID_IM_d[15:11]==5'b10000))
z_select=3'b100;//z3
else
z_select=3'b010;//z
end

endmodule

















