`timescale 1ns / 1ps

module new_expon_cont(
input [31:0] num,
input clk, res,
output reg [31:0] x, cf,
output reg m0, m1, resM1, resM2, resA, resS, resC, memen, st 
);
reg [3:0] state;

always@(posedge clk) state= (res)?4'd0:(state==4'd9)?4'd0:state+4'd1;

always@(posedge clk) x = (state)?x:num;

always@(posedge clk)
begin
if(state==4'd0) {resS, st, resA, resC, resM1, m0, m1} = (res)?7'b1011100:7'b0110100;
else if(state==4'd1) {resS, st, resA, resC, resM1, m0, m1} = 7'b0011100;
else if(state==4'd2) {resS, st, resA, resC, resM1, m0, m1} = 7'b0011000;
else if(state==4'd3) {resS, st, resA, resC, resM1, m0, m1} = 7'b0001001;
else if(state==4'd9) {resS, st, resA, resC, resM1, m0, m1} = 7'b0001111;
else {resS, st, resA, resC, resM1, m0, m1} = 7'b0001011;
end

always@(negedge clk)
begin
if(state==4'd0) {memen, resM2} = (res)?2'b01:2'b11;
else if(state==4'd1) {memen, resM2} = 2'b11;
else if(state==4'd9) {memen, resM2} = 2'b01;
else {memen, resM2} = 2'b00;
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