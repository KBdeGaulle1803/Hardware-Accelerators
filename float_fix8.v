`timescale 1ns / 1ps

module float_fix8(
input [31:0] float,
input clk, rst,
output [7:0] fix8
);
reg [13:0] fix36;
integer range=0;

assign fix8 = fix36[13:6];

always@(posedge clk)
begin
if(!rst) begin
fix36=0;
range=float[30:23]-127;
fix36[6:0]= {1'b1,float[22:17]};
fix36= (range>0)?(fix36<<range):(fix36>>(-range));
fix36[13]= float[31];
end
else fix36=0;
end

endmodule
