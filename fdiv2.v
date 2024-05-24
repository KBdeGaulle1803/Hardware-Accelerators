`timescale 1ns / 1ps

module fdiv2(
input ck_in,
output reg ck_out=0);

always@(posedge ck_in) ck_out=!ck_out;

endmodule
