`timescale 1ns / 1ps

module sigmoid(
output [31:0] sig,
input [31:0] num,
input clk, res
);
wire [31:0] x, cf, ip1M1, ip2M1, ipM2, ipA, stin;
wire m0, m1, resM1, resM2, resA, resS, st;

assign ip1M1= (m0)?ipM2:{1'b0,8'd127,23'd0};
assign ip2M1= (m1)?{1'b1,x[30:0]}:{1'b0,8'd127,23'd0};

sigmoid_ctrl CT(num, clk, res, x, cf, m0, m1, resM1, resM2, resA, resS, st);
multiplier M1(ip1M1, ip2M1, (!clk), resM1, ipM2);
multiplier M2(ipM2, cf, clk, resM2, ipA);
adder AD(ipA, stin, (!clk), resA, stin);
sync ST(stin, st, resS, sig);

endmodule
