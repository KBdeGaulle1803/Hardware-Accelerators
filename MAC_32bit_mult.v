`timescale 1ns / 1ps

module MAC_32bit_mult(
input greater_sign, lesser_sign, output reg out_sign=0,
input [7:0] greater_exp, lesser_exp, output reg [7:0] out_exp=0,
input [22:0] greater_mant, lesser_mant, output reg [22:0] out_mant=0,
input clk
);
reg [47:0] inter_add=0;
reg [8:0] inter_exp=0;
reg [4:0] diff=0, diff2=0;
reg all_0=1;

always@(posedge clk)
begin
out_sign= (greater_sign^lesser_sign);
inter_add= {(greater_exp?2'b01:2'b00),greater_mant}*
{(lesser_exp?2'b01:2'b00),lesser_mant};
inter_exp= (greater_exp==255||lesser_exp==255)?511:greater_exp+lesser_exp;
inter_add= (inter_exp<127||inter_exp>381)?0:inter_add;
inter_exp= (inter_exp<127)?0:(inter_exp>381)?255:inter_exp-127;
diff= (inter_add[47])?0:(inter_add[46])?1:(inter_add[45])?2:(inter_add[44])?3:
(inter_add[43])?4:(inter_add[42])?5:(inter_add[41])?6:(inter_add[40])?7:
(inter_add[39])?8:(inter_add[38])?9:(inter_add[37])?10:(inter_add[36])?11:
(inter_add[35])?12:(inter_add[34])?13:(inter_add[33])?14:(inter_add[32])?15:
(inter_add[31])?16:(inter_add[30])?17:(inter_add[29])?18:(inter_add[28])?19:
(inter_add[27])?20:(inter_add[26])?21:(inter_add[25])?22:(inter_add[24])?23:
(inter_add[23])?24:25;
diff2= (greater_exp+lesser_exp<127 && 127-greater_exp-lesser_exp<23)?127-greater_exp-lesser_exp
:diff;
all_0= (diff==0)?(inter_exp>253):(diff==1)?(inter_exp==255):(diff==25);
inter_add[47:23]= (!diff2[4])?((!diff2[3])?((!diff2[2])?((!diff2[1])?((!diff2[0])?
{1'b0,inter_add[47:24]}:inter_add[47:23]):((!diff2[0])?{inter_add[46:23],1'd0}
:{inter_add[45:23],2'd0})):((!diff2[1])?((!diff2[0])?{inter_add[44:23],3'd0}
:{inter_add[43:23],4'd0}):((!diff2[0])?{inter_add[42:23],5'd0}:{inter_add[41:23],6'd0})))
:((!diff2[2])?((!diff2[1])?((!diff2[0])?{inter_add[40:23],7'd0}:{inter_add[39:23],8'd0})
:((!diff2[0])?{inter_add[38:23],9'd0}:{inter_add[37:23],10'd0})):((!diff2[1])?((!diff2[0])?
{inter_add[36:23],11'd0}:{inter_add[35:23],12'd0}):((!diff2[0])?{inter_add[34:23],13'd0}
:{inter_add[33:23],14'd0})))):((!diff2[3])?((!diff2[2])?((!diff2[1])?((!diff2[0])?
{inter_add[32:23],15'd0}:{inter_add[31:23],16'd0}):((!diff2[0])?{inter_add[30:23],17'd0}
:{inter_add[29:23],18'd0})):((!diff2[1])?((!diff2[0])?{inter_add[28:23],19'd0}
:{inter_add[27:23],20'd0}):((!diff2[0])?{inter_add[26:23],21'd0}:{inter_add[25:23],22'd0})))
:((!diff2[2])?((!diff2[1])?((!diff2[0])?{inter_add[24:23],23'd0}:0):((!diff2[0])?0:0))
:((!diff2[1])?((!diff2[0])?0:0):((!diff2[0])?0:0))));
inter_exp= (inter_exp==255)?255:inter_exp+1-diff+(!inter_exp&inter_add[46]);
inter_add= (all_0)?0:inter_add;
inter_exp= (all_0)?(inter_exp==255)?255:0:inter_exp;
out_mant= inter_add[45:23];
out_exp= inter_exp[7:0];
end

endmodule
