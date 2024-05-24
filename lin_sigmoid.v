`timescale 1ns / 1ps

module lin_sigmoid(
output [31:0] sig,
input [31:0] num,
input clk, res
);
wire [31:0] x, cf1, cf2, ipA;

PLAN_ctrl C(num, clk, res, x, cf1, cf2);
multiplier M({1'b1,x[30:0]}, cf1, (!clk), res, ipA);
adder A(ipA, cf2, clk, res, sig);

endmodule
