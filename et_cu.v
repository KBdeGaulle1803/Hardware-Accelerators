`timescale 1ns / 1ps

module et_cu(
input [31:0] num,
input clk, res,
output reg [31:0] x, cf, sub_fac, mul_fac,
output reg m0, m1, resM1, resM2, resA1, resA2, resS, st 
);
reg [3:0] state;

always@(posedge clk)
begin
state= (res)?4'd12:(state==4'd12)?4'd0:state+4'd1;
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
else if(state==4'd12)
begin
x=32'd0;
{m0,m1,st}={2'd0,(!res)};
{resM1, resM2, resA1, resA2, resS}={4'b1111,res};
end
else if(state==4'd11)
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

if(state!=4'd12 && state!=4'd0) mul_fac= 32'h3F800000;
else mul_fac=0;

end

always@(negedge clk)
begin
if(state==4'd1||state==4'd2) cf=32'h3F800000;
else if(state==4'd3) cf=32'h3F000000;
else if(state==4'd4) cf=32'h3E2AAAAB;
else if(state==4'd5) cf=32'h3D2AAAAB;
else if(state==4'd6) cf=32'h3C088889;
else if(state==4'd7) cf=32'h3AB60B61;
else if(state==4'd8) cf=32'h39500D01;
else if(state==4'd9) cf=32'h37D00D01;
else if(state==4'd10) cf=32'h3638EF1D;
else cf=32'd0;

if(state!=4'd12) sub_fac= 32'd0;
else sub_fac=0;

end
    
endmodule