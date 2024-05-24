`timescale 1ns / 1ps

module fixed_expon(
output [31:0] exp,
//output ck2,
input [31:0] num,
input ck2, res
);
wire [31:0] x, cf, y, ip1M1, ip2M1, ipM2, ipA, stin, sub_fac, mul_fac, me1, fix_out;
wire [35:0] fix_in;
reg [7:0] exp_prod;
wire m0, m1, resM1, resM2, resA1, resA2, resS, st;

assign sub_fac= {!x[31],x[30:28],28'h8000000};
assign ip1M1= (m0)?ipM2:mul_fac;
assign ip2M1= (m1)?y:32'h10000000;
assign mul_fac= {3'd0,(me1[30:23]!=8'd0),me1[22:0],5'd0}|{1'b0,{31{&me1[30:23]}}};

always@(posedge st) exp_prod= me1[30:23]-(me1[30:23]!=0);

//fdiv2 F2(clk,ck2);
float_fix36 LI(num, ck2, res, fix_in);
fixed_ctrl CT({fix_in[35],fix_in[30:0]}, !ck2, res, x, cf, m0, m1, resM1, 
resM2, resA1, resA2, resS, st);
fix32_add A2({x[31],4'd0,x[30:0]}, {sub_fac[31],4'd0,sub_fac[30:0]}, !ck2, resA2, y);
fix32_mult M1(ip1M1, ip2M1, ck2, resM1, ipM2);
fix32_mult M2(ipM2, cf, !ck2, resM2, ipA);
fix32_add A1({ipA[31],4'd0,ipA[30:0]}, {stin[31],4'd0,stin[30:0]}, ck2, resA1, stin);
sync ST(stin, st, resS, fix_out);
fix32_float IL(fix_out, exp_prod, ck2, res, exp);
block BM(!ck2, 1'b1, 1'b0, {fix_in[34:28],fix_in[35]}, 32'd0, me1);

endmodule