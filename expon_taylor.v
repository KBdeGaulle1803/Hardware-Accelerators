`timescale 1ns / 1ps

module expon_taylor(
output [31:0] exp,
input [31:0] num,
input clk, res
);
wire [31:0] x, cf, y, ip1M1, ip2M1, ipM2, ipA, stin, sub_fac, mul_fac;
wire m0, m1, resM1, resM2, resA1, resA2, resS, st;

assign ip1M1= (m0)?ipM2:mul_fac;
assign ip2M1= (m1)?y:{1'b0,8'd127,23'd0};

et_cu CT(num, clk, res, x, cf, sub_fac, mul_fac, m0, m1, resM1, resM2, resA1,
resA2, resS, st);
adder A2(x, sub_fac, clk, resA2, y);
multiplier M1(ip1M1, ip2M1, (!clk), resM1, ipM2);
multiplier M2(ipM2, cf, clk, resM2, ipA);
adder A1(ipA, stin, (!clk), resA1, stin);
sync ST(stin, st, resS, exp);

endmodule
