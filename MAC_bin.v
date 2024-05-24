`timescale 1ns / 1ps

module MAC_bin(
input [7:0] x1, x2,
output reg [31:0] y=0,
input clk, en, res
);
reg [15:0] int_mul=0;

always@(posedge clk)
begin
if(res)
{y,int_mul}<=0;
else
begin
int_mul<= en?(x1*x2):0;
y <= int_mul+y;
end
end
    
endmodule
