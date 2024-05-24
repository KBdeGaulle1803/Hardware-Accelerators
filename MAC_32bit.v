`timescale 1ns / 1ps

module MAC_32bit(
input [31:0] X1, X2,
output [31:0] acc,
input clk, rst
);
wire [31:0] G, L, M1, M2, A1, A2, inter_sum;

assign M1 = (rst)?32'd0:X1;
assign M2 = (rst)?32'd0:X2;
assign A1 = (rst)?32'd0:inter_sum;
assign A2 = (rst)?32'd0:acc;

MAC_32bit_mult M(.greater_sign(M1[31]),.lesser_sign(M2[31]),.out_sign(inter_sum[31]),
.greater_exp(M1[30:23]),.lesser_exp(M2[30:23]),.out_exp(inter_sum[30:23]),
.greater_mant(M1[22:0]),.lesser_mant(M2[22:0]),.out_mant(inter_sum[22:0]),.clk(clk));
MAC_32bit_sort S(A1, A2, G, L);
MAC_32bit_adder A(.greater_sign(G[31]),.lesser_sign(L[31]),.out_sign(acc[31]),
.greater_exp(G[30:23]),.lesser_exp(L[30:23]),.out_exp(acc[30:23]),
.greater_mant(G[22:0]),.lesser_mant(L[22:0]),.out_mant(acc[22:0]),.clk(clk));
    
endmodule
