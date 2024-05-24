`timescale 1ns / 1ps

module MAC_32bit_sort(
input [31:0] A, B,
output reg [31:0] greater=0, lesser=0
);

always@(*)
if(A>B) {greater,lesser}={A,B};
else {greater,lesser}={B,A};
    
endmodule
