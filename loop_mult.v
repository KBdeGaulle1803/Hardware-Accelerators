`timescale 1ns / 1ps

module loop_mult(
input [31:0] A,
input clk, rst, rstu, st, m1, m2,
output [31:0] resf, res
);
wire [31:0] ip1, ip2;

assign ip1= (m1)?res:{1'b0,8'd127,23'd0};
assign ip2= (m2)?A:{1'b0,8'd127,23'd0};

multiplier M(ip1, ip2, clk, (rst||rstu), res);
sync S(res, st, rstu, resf);

endmodule
