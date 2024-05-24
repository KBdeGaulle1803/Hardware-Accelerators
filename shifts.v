`timescale 1ns / 1ps

module shifts(
input [24:0] in_add,
input [7:0] in_exp,
output [24:0] inter_add,
output [7:0] inter_exp
);
wire [24:0] mid_add;
wire [8:0] mid_exp;
wire [7:0] diff2, diff;
wire all_0;

assign diff2= (in_add[24])?0:(in_add[23])?1:(in_add[22])?2:(in_add[21])?3:
(in_add[20])?4:(in_add[19])?5:(in_add[18])?6:(in_add[17])?7:(in_add[16])?8:
(in_add[15])?9:(in_add[14])?10:(in_add[13])?11:(in_add[12])?12:(in_add[11])?13:
(in_add[10])?14:(in_add[9])?15:(in_add[8])?16:(in_add[7])?17:(in_add[6])?18:
(in_add[5])?19:(in_add[4])?20:(in_add[3])?21:(in_add[2])?22:(in_add[1])?23:
(in_add[0])?24:127;
assign all_0= (diff2==0)?(in_exp>253):(diff2==1)?(in_exp==255):(diff2==127);
assign diff= (diff2<25)?((diff2<(inter_exp+1))?diff2:inter_exp+1):diff2;
assign mid_add= (diff==0)?{1'b0,in_add[24:1]}:(diff==1)?in_add:
(diff==2)?{in_add[23:0],1'd0}:(diff==3)?{in_add[22:0],2'd0}:
(diff==4)?{in_add[21:0],3'd0}:(diff==5)?{in_add[20:0],4'd0}:
(diff==6)?{in_add[19:0],5'd0}:(diff==7)?{in_add[18:0],6'd0}:
(diff==8)?{in_add[17:0],7'd0}:(diff==9)?{in_add[16:0],8'd0}:
(diff==10)?{in_add[15:0],9'd0}:(diff==11)?{in_add[14:0],10'd0}:
(diff==12)?{in_add[13:0],11'd0}:(diff==13)?{in_add[12:0],12'd0}:
(diff==14)?{in_add[11:0],13'd0}:(diff==15)?{in_add[10:0],14'd0}:
(diff==16)?{in_add[9:0],15'd0}:(diff==17)?{in_add[8:0],16'd0}:
(diff==18)?{in_add[7:0],17'd0}:(diff==19)?{in_add[6:0],18'd0}:
(diff==20)?{in_add[5:0],19'd0}:(diff==21)?{in_add[4:0],20'd0}:
(diff==22)?{in_add[3:0],21'd0}:(diff==23)?{in_add[2:0],22'd0}:
(diff==24)?{in_add[1:0],23'd0}:0;
assign mid_exp= in_exp+1-diff;
assign inter_add= (all_0)?0:mid_add;
assign inter_exp= (all_0)?(in_exp==255)?255:0:mid_exp[7:0];

endmodule