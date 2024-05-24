`timescale 1ns / 1ps

module mat_cont(
input [R1*R2C1*32-1:0] M1,
input [R2C1*C2*32-1:0] M2,
input clk, rst, relu, n_cust,
input [1:0] cust_R1,
input [3:0] cust_R2C1,
input [2:0] cust_C2,
output reg [R1*C2*32-1:0] O, 
output reg [31:0] in1=0, in2=0,
output [31:0] out_mac,
output reg [3:0] state=0, addr2=0,
output reg addr1=0
);
parameter R1= 2, R2C1= 14, C2= 6;
reg [31:0] Mi1 [0:R1-1][0:R2C1-1];
reg [31:0] Mi2 [0:R2C1-1][0:C2-1];
reg [31:0] Oi [0:R1-1][0:C2-1];
reg addr1_prev;
reg [2:0] addr2_prev;
integer i, j, k;
reg rst_mac=1, relu_en=0, nc_stat=0;
reg [1:0] nc_R1=1;
reg [3:0] nc_R2C1=1;
reg [2:0] nc_C2=1;

always@(posedge clk)
begin
if(rst)
begin
state=0;
addr2=0;
in1=0;
in2=0;
addr1=0;
addr1_prev=0;
addr2_prev=0;
for(i=0; i<R1; i=i+1) for(j=0; j<C2; j=j+1) Oi[i][j]=0;
rst_mac=1;
relu_en=0;
for(i=0; i<R1; i=i+1) for(j=0; j<R2C1; j=j+1) Mi1[i][j]=0;
for(i=0; i<R2C1; i=i+1) for(j=0; j<C2; j=j+1) Mi2[i][j]=0;
nc_R1=1;
nc_R2C1=1;
nc_C2=1;
nc_stat=0;
end
else
begin
if(state==0)
begin
for(i=0; i<R1; i=i+1) for(j=0; j<R2C1; j=j+1) for(k=0; k<32; k=k+1) 
Mi1[i][j][k]= (addr1==0 && addr2==0)?M1[(R1*R2C1-i*R2C1-j-1)*32+k]:Mi1[i][j][k]; 
for(i=0; i<R2C1; i=i+1) for(j=0; j<C2; j=j+1) for(k=0; k<32; k=k+1) 
Mi2[i][j][k]= (addr1==0 && addr2==0)?M2[(R2C1*C2-i*C2-j-1)*32+k]:Mi2[i][j][k];
for(i=0; i<R1; i=i+1) for(j=0; j<C2; j=j+1) Oi[i][j]=(addr1==0 && addr2==0)?0:Oi[i][j]; 
in1 = Mi1[addr1][state];
in2 = Mi2[state][addr2];
Oi[addr1_prev][addr2_prev]=Oi[addr1_prev][addr2_prev];
rst_mac=0;
relu_en=relu;
state<= state+1;
nc_R1=cust_R1;
nc_R2C1=cust_R2C1;
nc_C2=cust_C2;
nc_stat=n_cust;
end
else if((!nc_stat && state==R2C1) || (nc_stat && state==nc_R2C1))
begin
in1 = 0;
in2 = 0;
addr1_prev = addr1;
addr2_prev = addr2;
addr2 = ((!nc_stat && addr1==R1-1) || (nc_stat && addr1==nc_R1-1))?
((!nc_stat && addr2==C2-1) || (nc_stat && addr2==nc_C2-1))?0:addr2+1:addr2;
addr1 = ((!nc_stat && addr1==R1-1) || (nc_stat && addr1==nc_R1-1))?0:addr1+1;
rst_mac=0;
state<=state+1;
end
else if((!nc_stat && state==R2C1+1) || (nc_stat && state==nc_R2C1+1))
begin
in1 = 0;
in2 = 0;
Oi[addr1_prev][addr2_prev] = (relu_en)?(out_mac[31])?32'd0:out_mac:out_mac;
rst_mac=1;
state<=0;
end
else
begin
in1 = Mi1[addr1][state];
in2 = Mi2[state][addr2];
Oi[addr1_prev][addr2_prev]=Oi[addr1_prev][addr2_prev];
rst_mac=0;
state<= state+1;
end
end
end

MAC mult(.A(in1), .B(in2), .clk(clk), .rst(rst_mac), .acc(out_mac), .prod());

always @(negedge(state||addr1||addr2))
begin
for(i=0; i<R1; i=i+1) for(j=0; j<C2; j=j+1) for(k=0; k<32; k=k+1) 
O[(R1*C2-i*C2-j-1)*32+k]= Oi[i][j][k];
end
    
endmodule
