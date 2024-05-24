`timescale 1ns / 1ps

module SLP(
input [ID*32-1:0] ip,
input [ID*HID*32-1:0] ib,
input [HID*HOD*32-1:0] hb,
input [HOD*OD*32-1:0] ob,
input clk, rst,
output reg [7:0] state=0,
output reg rs_mat=1, relu_en=0, n_cust=1,
output [C2*32-1:0] out_mat,
output reg [1:0] cust_R1=1, level=0,
output reg [3:0] cust_R2C1=ID,
output reg [2:0] cust_C2=HID,
output reg [R2C1*32-1:0] out_int=0,
output reg [OD*32-1:0] op=0,
output reg [ID*32-1:0] ip_in=0,
output reg [ID*HID*32-1:0] ib_in=0,
output reg [HID*HOD*32-1:0] hb_in=0,
output reg [HOD*OD*32-1:0] ob_in=0,
output reg [R1*R2C1*32-1:0] ipm1=0,
output reg [R2C1*C2*32-1:0] ipm2=0,
output [31:0] in1, in2,
output [31:0] out_mac,
output [3:0] state_mac, addr2,
output addr1
);
parameter ID=10, HID=3, HOD=5, OD=1, R1=1, R2C1=10, C2=5;
integer i, j, k;

always@(posedge clk)
begin
n_cust=1;
if(rst)
begin
state=0;
level=0;
op=0;
relu_en=0;
out_int=0;
cust_R1=1;
cust_R2C1=ID;
cust_C2=HID;
ip_in=0;
ib_in=0;
hb_in=0;
ob_in=0;
end
else
begin
out_int={out_mat,{(R2C1-C2){32'd0}}};
if(level==0 && state==0) begin
ip_in=ip;
ib_in=ib;
hb_in=hb;
ob_in=ob;
ipm1=ip;
for (i=0; i<R2C1; i=i+1) for (j=0; j<C2; j=j+1) for (k=0; k<32; k=k+1) 
ipm2[(R2C1*C2-i*C2-j-1)*32+k] = (i<ID && j<HID)? ib[(ID*HID-i*HID-j-1)*32+k] : 1'd0;
end
else begin
ip_in=ip_in;
ib_in=ib_in;
hb_in=hb_in;
ob_in=ob_in;
end
if(level==0 && state==(ID+2)*HID+1) begin
state=1;
level=level+1;
ipm1=out_int;
op=op;
end
else if(level==1 && state==(HID+2)*HOD+1) begin
state=1;
level=level+1;
ipm1=out_int;
op=op;
end
else if(level==2 && state==(HOD+2)*OD+2) begin
state=0;
level=0;
ipm1=out_int;
op=out_int[ID*32-1:(ID-OD)*32];
end 
else begin
state=state+1;
level=level;
ipm1=ipm1;
op=op;
end
if(level==0 && state==(ID+2)*HID) begin
relu_en=1;
cust_R1=1;
cust_R2C1=HID;
cust_C2=HOD;
for (i=0; i<R2C1; i=i+1) for (j=0; j<C2; j=j+1) for (k=0; k<32; k=k+1) 
ipm2[(R2C1*C2-i*C2-j-1)*32+k] = (i<HID && j<HOD)? hb[(HID*HOD-i*HOD-j-1)*32+k] : 1'd0;
end
else if(level==1 && state==(HID+2)*HOD) begin
relu_en=0;
cust_R1=1;
cust_R2C1=HOD;
cust_C2=OD;
for (i=0; i<R2C1; i=i+1) for (j=0; j<C2; j=j+1) for (k=0; k<32; k=k+1) 
ipm2[(R2C1*C2-i*C2-j-1)*32+k] = (i<HOD && j<OD)? ob[(HOD*OD-i*OD-j-1)*32+k] : 1'd0;
end
else if(level==2 && state==(HOD+2)*OD+1) begin
relu_en=0;
cust_R1=1;
cust_R2C1=ID;
cust_C2=HID;
for (i=0; i<R2C1; i=i+1) for (j=0; j<C2; j=j+1) for (k=0; k<32; k=k+1) 
ipm2[(R2C1*C2-i*C2-j-1)*32+k] = (i<ID && j<HID)? ib[(ID*HID-i*HID-j-1)*32+k] : 1'd0;
end 
else begin
relu_en=relu_en;
cust_R1=cust_R1;
cust_R2C1=cust_R2C1;
ipm2=ipm2;
end
end
end

always@(negedge clk)
begin
if(rst) rs_mat=1;
else begin
if(level==0) begin
if(state==(ID+2)*HID+1 || state==0) rs_mat=1;
else rs_mat=0;
end
else if(level==1) begin
if(state==(HID+2)*HOD+1) rs_mat=1;
else rs_mat=0;
end
else if(level==2) begin
if(state==(HOD+2)*OD+1 || state==(HOD+2)*OD+2) rs_mat=1;
else rs_mat=0;
end
end
end

mat_cont #(.R1(R1), .R2C1(R2C1), .C2(C2)) mmul(ipm1, ipm2, clk, rs_mat, relu_en, n_cust, cust_R1,
cust_R2C1, cust_C2, out_mat, in1, in2, out_mac, state_mac, addr2, addr1);
    
endmodule
