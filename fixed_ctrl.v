`timescale 1ns / 1ps

module fixed_ctrl(
input [31:0] num,
input clk, res,
output reg [31:0] x, cf,
output reg m0, m1, resM1, resM2, resA1, resA2, resS, st 
);
reg [3:0] state;

always@(posedge clk)
begin
state= (res)?4'd9:(state==4'd9)?4'd0:state+4'd1;
if(state==4'd0||state==4'd1)
begin
x=num;
{m0,m1,st}=3'd0;
{resM1, resM2, resA1, resA2, resS}=5'd0;
end
else if(state==4'd2)
begin
x=x;
{m0,m1,st}=3'd2;
{resM1, resM2, resA1, resA2, resS}=5'd0;
end
else if(state==4'd9)
begin
x=32'd0;
{m0,m1,st}={2'd0,(!res)};
{resM1, resM2, resA1, resA2, resS}={4'b1111,res};
end
else if(state==4'd8)
begin
x=x;
{m0,m1,st}=3'd0;
{resM1, resM2, resA1, resA2, resS}=5'b10010;
end
else 
begin
x=x;
{m0,m1,st}=3'd6;
{resM1, resM2, resA1, resA2, resS}=5'd0;
end
end

always@(negedge clk)
begin
if(state==4'd1||state==4'd2) cf=32'h10000000;
else if(state==4'd3) cf=32'h08000000;
else if(state==4'd4) cf=32'h02AAAAAB;
else if(state==4'd5) cf=32'h00AAAAAB;
else if(state==4'd6) cf=32'h00222222;
else if(state==4'd7) cf=32'h0005B05B;
else cf=32'd0;
end
    
endmodule