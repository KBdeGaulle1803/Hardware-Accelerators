`timescale 1ns / 1ps

module MAC_32bit_adder(
input greater_sign, lesser_sign, output reg out_sign=0,
input [7:0] greater_exp, lesser_exp, output reg [7:0] out_exp=0,
input [22:0] greater_mant, lesser_mant, output reg [22:0] out_mant=0,
input clk
);
reg [24:0] inter_add=0;
reg [8:0] inter_exp=0;
integer diff=0;
reg all_0=1;

always@(posedge clk)
begin
out_sign=greater_sign;
inter_exp[7:0]=greater_exp;
inter_add= (greater_sign==lesser_sign)?({(greater_exp?2'b01:2'b00),greater_mant}+
({(lesser_exp?2'b01:2'b00),lesser_mant}>>(greater_exp-lesser_exp))):
({(greater_exp?2'b01:2'b00),greater_mant}-
({(lesser_exp?2'b01:2'b00),lesser_mant}>>(greater_exp-lesser_exp)));
diff= (inter_add[24])?0:(inter_add[23])?1:(inter_add[22])?2:(inter_add[21])?3:
(inter_add[20])?4:(inter_add[19])?5:(inter_add[18])?6:(inter_add[17])?7:
(inter_add[16])?8:(inter_add[15])?9:(inter_add[14])?10:(inter_add[13])?11:
(inter_add[12])?12:(inter_add[11])?13:(inter_add[10])?14:(inter_add[9])?15:
(inter_add[8])?16:(inter_add[7])?17:(inter_add[6])?18:(inter_add[5])?19:
(inter_add[4])?20:(inter_add[3])?21:(inter_add[2])?22:(inter_add[1])?23:
(inter_add[0])?24:127;
all_0= (diff==0)?(inter_exp>253):(diff==1)?(inter_exp==255):(diff==127);
diff= (diff<25)?((diff<(inter_exp+1))?diff:inter_exp+1):diff;
inter_add= (diff==0)?{1'b0,inter_add[24:1]}:(diff==1)?inter_add:
(diff==2)?{inter_add[23:0],1'd0}:(diff==3)?{inter_add[22:0],2'd0}:
(diff==4)?{inter_add[21:0],3'd0}:(diff==5)?{inter_add[20:0],4'd0}:
(diff==6)?{inter_add[19:0],5'd0}:(diff==7)?{inter_add[18:0],6'd0}:
(diff==8)?{inter_add[17:0],7'd0}:(diff==9)?{inter_add[16:0],8'd0}:
(diff==10)?{inter_add[15:0],9'd0}:(diff==11)?{inter_add[14:0],10'd0}:
(diff==12)?{inter_add[13:0],11'd0}:(diff==13)?{inter_add[12:0],12'd0}:
(diff==14)?{inter_add[11:0],13'd0}:(diff==15)?{inter_add[10:0],14'd0}:
(diff==16)?{inter_add[9:0],15'd0}:(diff==17)?{inter_add[8:0],16'd0}:
(diff==18)?{inter_add[7:0],17'd0}:(diff==19)?{inter_add[6:0],18'd0}:
(diff==20)?{inter_add[5:0],19'd0}:(diff==21)?{inter_add[4:0],20'd0}:
(diff==22)?{inter_add[3:0],21'd0}:(diff==23)?{inter_add[2:0],22'd0}:
(diff==24)?{inter_add[1:0],23'd0}:0;
inter_exp= inter_exp+1-diff+(!inter_exp&inter_add[23]);
inter_add= (all_0)?0:inter_add;
inter_exp= (all_0)?(greater_exp==255)?255:0:inter_exp;
out_mant= inter_add[22:0];
out_exp= inter_exp[7:0];
end

endmodule
