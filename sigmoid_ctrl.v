`timescale 1ns / 1ps

module sigmoid_ctrl(
input [31:0] num,
input clk, res,
output reg [31:0] x, cf,
output reg m0, m1, resM1, resM2, resA, resS, st 
);
reg [2:0] state;

always@(posedge clk)
begin
state= (res)?3'd5:(state==3'd5)?3'd0:state+3'd1;
if(state==3'd0)
begin
x=num;
{m0,m1,st}=3'd0;
{resM1, resM2, resA, resS}=4'd0;
end
else if(state==3'd1)
begin
x=x;
{m0,m1,st}=3'd2;
{resM1, resM2, resA, resS}=3'd0;
end
else if(state==3'd2||state==3'd3)
begin
x=x;
{m0,m1,st}=3'd6;
{resM1, resM2, resA, resS}=3'd0;
end
else if(state==3'd4)
begin
x=x;
{m0,m1,st}=3'd0;
{resM1, resM2, resA, resS}=4'b1000;
end
else 
begin
x=32'd0;
{m0,m1,st}={2'd0,(!res)};
{resM1, resM2, resA, resS}={3'b111,res};
end
end

always@(negedge clk)
begin
if(state==3'd0)
begin
if(x[30:23]<8'd126) cf=(x[31])?32'h3EFFFFBE:32'h3F000021;
else if(x[30:23]==8'd126) cf=(x[31])?32'h3F000021:32'h3EFFFFBE;
else if(x[30:23]==8'd127 && !x[22]) cf=(x[31])?32'h3F005A3D:32'h3EFF4B86;
else if(x[30:23]==8'd127 && x[22]) cf=(x[31])?32'h3F02ED3C:32'h3EFA2588;
else if(x[30:23]==8'd128 && x[22:21]==2'd0) cf=(x[31])?32'h3F080E7A:32'h3EEFE30C;
else if(x[30:23]==8'd128 && x[22:21]==2'd1) cf=(x[31])?32'h3F0B7249:32'h3EE91B6E;
else if(x[30:23]==8'd128 && x[22:21]==2'd2) cf=(x[31])?32'h3F086332:32'h3EEF399C;
else if(x[30:23]==8'd128 && x[22:21]==2'd3) cf=(x[31])?32'h3EFBA3C4:32'h3F022E1E;
else if(x[30:23]==8'd129 && x[22:20]==3'd0) cf=(x[31])?32'h3EDBC681:32'h3F121CC0;
else if(x[30:23]==8'd129 && x[22:20]==3'd1) cf=(x[31])?32'h3EB7629D:32'h3F244EB2;
else if(x[30:23]==8'd129 && x[22:20]==3'd2) cf=(x[31])?32'h3E938E28:32'h3F3638EC;
else if(x[30:23]==8'd129 && x[22:20]==3'd3) cf=(x[31])?32'h3E66AEEB:32'h3F465445;
else if(x[30:23]==8'd129 && x[22:20]==3'd4) cf=(x[31])?32'h3E304CA4:32'h3F53ECD7;
else if(x[30:23]==8'd129 && x[22:20]==3'd5) cf=(x[31])?32'h3E043E70:32'h3F5EF064;
else if(x[30:23]==8'd129 && x[22:20]==3'd6) cf=(x[31])?32'h3DC35DDF:32'h3F679444;
else if(x[30:23]==8'd129 && x[22:20]==3'd7) cf=(x[31])?32'h3D8E63F7:32'h3F6E3381;
else if(x[30:23]==8'd130 && x[22:19]==4'd0) cf=(x[31])?32'h3D4D8569:32'h3F7327A9;
else if(x[30:23]==8'd130 && x[22:19]==4'd1) cf=(x[31])?32'h3D12D3C3:32'h3F76D2C4;
else if(x[30:23]==8'd130 && x[22:19]==4'd2) cf=(x[31])?32'h3CCFC6F9:32'h3F7981C8;
else if(x[30:23]==8'd130 && x[22:19]==4'd3) cf=(x[31])?32'h3C91C5FC:32'h3F7B71D0;
else if(x[30:23]==8'd130 && x[22:19]==4'd4) cf=(x[31])?32'h3C4BB222:32'h3F7CD137;
else if(x[30:23]==8'd130 && x[22:19]==4'd5) cf=(x[31])?32'h3C0CA4E4:32'h3F7DCD6C;
else if(x[30:23]==8'd130 && x[22:20]==3'd3) cf=(x[31])?32'h3BED8496:32'h3F7E24F7;
else if(x[30:23]==8'd130 && x[22:20]==3'd4) cf=(x[31])?32'h3B5F944A:32'h3F7F206C;
else if(x[30:23]==8'd130 && x[22:20]==3'd5) cf=(x[31])?32'h3ACEA6B7:32'h3F7F98AD;
else if(x[30:23]==8'd130 && x[22:20]==3'd6) cf=(x[31])?32'h3A3BF5CB:32'h3F7FD103;
else if(x[30:23]==8'd130 && x[22:20]==3'd7) cf=(x[31])?32'h39A89AC4:32'h3F7FEAED;
else cf=(x[31])?32'h00000000:32'h3F800000;
end
else if(state==3'd1)
begin
if(x[30:23]<8'd126) cf=(x[31])?32'h3E8009BA:32'hBE8009BA;
else if(x[30:23]==8'd126) cf=(x[31])?32'h3E800042:32'hBE800042;
else if(x[30:23]==8'd127 && !x[22]) cf=(x[31])?32'h3E83B436:32'hBE83B436;
else if(x[30:23]==8'd127 && x[22]) cf=(x[31])?32'h3E92F55F:32'hBE92F55F;
else if(x[30:23]==8'd128 && x[22:21]==2'd0) cf=(x[31])?32'h3EA7B201:32'hBEA7B201;
else if(x[30:23]==8'd128 && x[22:21]==2'd1) cf=(x[31])?32'h3EB23BCC:32'hBEB23BCC;
else if(x[30:23]==8'd128 && x[22:21]==2'd2) cf=(x[31])?32'h3EAB260B:32'hBEAB260B;
else if(x[30:23]==8'd128 && x[22:21]==2'd3) cf=(x[31])?32'h3E961C5A:32'hBE961C5A;
else if(x[30:23]==8'd129 && x[22:20]==3'd0) cf=(x[31])?32'h3E7595DA:32'hBE7595DA;
else if(x[30:23]==8'd129 && x[22:20]==3'd1) cf=(x[31])?32'h3E3EE6D4:32'hBE3EE6D4;
else if(x[30:23]==8'd129 && x[22:20]==3'd2) cf=(x[31])?32'h3E0F039E:32'hBE0F039E;
else if(x[30:23]==8'd129 && x[22:20]==3'd3) cf=(x[31])?32'h3DD08497:32'hBDD08497;
else if(x[30:23]==8'd129 && x[22:20]==3'd4) cf=(x[31])?32'h3D9509E6:32'hBD9509E6;
else if(x[30:23]==8'd129 && x[22:20]==3'd5) cf=(x[31])?32'h3D51F698:32'hBD51F698;
else if(x[30:23]==8'd129 && x[22:20]==3'd6) cf=(x[31])?32'h3D11C780:32'hBD11C780;
else if(x[30:23]==8'd129 && x[22:20]==3'd7) cf=(x[31])?32'h3CC88894:32'hBCC88894;
else if(x[30:23]==8'd130 && x[22:19]==4'd0) cf=(x[31])?32'h3C88FC6D:32'hBC88FC6D;
else if(x[30:23]==8'd130 && x[22:19]==4'd1) cf=(x[31])?32'h3C39BCC2:32'hBC39BCC2;
else if(x[30:23]==8'd130 && x[22:19]==4'd2) cf=(x[31])?32'h3BF9FC77:32'hBBF9FC77;
else if(x[30:23]==8'd130 && x[22:19]==4'd3) cf=(x[31])?32'h3BA74B0E:32'hBBA74B0E;
else if(x[30:23]==8'd130 && x[22:19]==4'd4) cf=(x[31])?32'h3B5F2F20:32'hBB5F2F20;
else if(x[30:23]==8'd130 && x[22:19]==4'd5) cf=(x[31])?32'h3B136AC4:32'hBB136AC4;
else if(x[30:23]==8'd130 && x[22:20]==3'd3) cf=(x[31])?32'h3AF3E9EF:32'hBAF3E9EF;
else if(x[30:23]==8'd130 && x[22:20]==3'd4) cf=(x[31])?32'h3A53C0FF:32'hBA53C0FF;
else if(x[30:23]==8'd130 && x[22:20]==3'd5) cf=(x[31])?32'h39B5940C:32'hB9B5940C;
else if(x[30:23]==8'd130 && x[22:20]==3'd6) cf=(x[31])?32'h391A0744:32'hB91A0744;
else if(x[30:23]==8'd130 && x[22:20]==3'd7) cf=(x[31])?32'h3881650E:32'hB881650E;
else cf=(x[31])?32'h00000000:32'h80000000;
end
else if(state==3'd2)
begin
if(x[30:23]<8'd126) cf=(x[31])?32'hBA1C3BE2:32'h3A1C3BE2;
else if(x[30:23]==8'd126) cf=(x[31])?32'h3A1C0B27:32'hBA1C0B27;
else if(x[30:23]==8'd127 && !x[22]) cf=(x[31])?32'h3C604E19:32'hBC604E19;
else if(x[30:23]==8'd127 && x[22]) cf=(x[31])?32'h3D31A11C:32'hBD31A11C;
else if(x[30:23]==8'd128 && x[22:21]==2'd0) cf=(x[31])?32'h3D90FD94:32'hBD90FD94;
else if(x[30:23]==8'd128 && x[22:21]==2'd1) cf=(x[31])?32'h3DA6DF95:32'hBDA6DF95;
else if(x[30:23]==8'd128 && x[22:21]==2'd2) cf=(x[31])?32'h3D9BEDEA:32'hBD9BEDEA;
else if(x[30:23]==8'd128 && x[22:21]==2'd3) cf=(x[31])?32'h3D7FF207:32'hBD7FF207;
else if(x[30:23]==8'd129 && x[22:20]==3'd0) cf=(x[31])?32'h3D416E34:32'hBD416E34;
else if(x[30:23]==8'd129 && x[22:20]==3'd1) cf=(x[31])?32'h3D0A9B88:32'hBD0A9B88;
else if(x[30:23]==8'd129 && x[22:20]==3'd2) cf=(x[31])?32'h3CBFD3FA:32'hBCBFD3FA;
else if(x[30:23]==8'd129 && x[22:20]==3'd3) cf=(x[31])?32'h3C81A1BF:32'hBC81A1BF;
else if(x[30:23]==8'd129 && x[22:20]==3'd4) cf=(x[31])?32'h3C2C7DA3:32'hBC2C7DA3;
else if(x[30:23]==8'd129 && x[22:20]==3'd5) cf=(x[31])?32'h3BE2DCD7:32'hBBE2DCD7;
else if(x[30:23]==8'd129 && x[22:20]==3'd6) cf=(x[31])?32'h3B93ED2D:32'hBB93ED2D;
else if(x[30:23]==8'd129 && x[22:20]==3'd7) cf=(x[31])?32'h3B3F8F62:32'hBB3F8F62;
else if(x[30:23]==8'd130 && x[22:19]==4'd0) cf=(x[31])?32'h3AF739AA:32'hBAF739AA;
else if(x[30:23]==8'd130 && x[22:19]==4'd1) cf=(x[31])?32'h3A9EC7BA:32'hBA9EC7BA;
else if(x[30:23]==8'd130 && x[22:19]==4'd2) cf=(x[31])?32'h3A4AF6A8:32'hBA4AF6A8;
else if(x[30:23]==8'd130 && x[22:19]==4'd3) cf=(x[31])?32'h3A0283F4:32'hBA0283F4;
else if(x[30:23]==8'd130 && x[22:19]==4'd4) cf=(x[31])?32'h39A4A506:32'hB9A4A506;
else if(x[30:23]==8'd130 && x[22:19]==4'd5) cf=(x[31])?32'h394FE132:32'hB94FE132;
else if(x[30:23]==8'd130 && x[22:20]==3'd3) cf=(x[31])?32'h3928650F:32'hB928650F;
else if(x[30:23]==8'd130 && x[22:20]==3'd4) cf=(x[31])?32'h3886A5B3:32'hB886A5B3;
else if(x[30:23]==8'd130 && x[22:20]==3'd5) cf=(x[31])?32'h37D60214:32'hB7D60214;
else if(x[30:23]==8'd130 && x[22:20]==3'd6) cf=(x[31])?32'h37291CB1:32'hB7291CB1;
else if(x[30:23]==8'd130 && x[22:20]==3'd7) cf=(x[31])?32'h3683FE3D:32'hB683FE3D;
else cf=(x[31])?32'h00000000:32'h80000000;
end
else if(state==3'd3)
begin
if(x[30:23]<8'd126) cf=(x[31])?32'hBC9F3355:32'h3C9F3355;
else if(x[30:23]==8'd126) cf=(x[31])?32'hBC9F3564:32'h3C9F3564;
else if(x[30:23]==8'd127 && !x[22]) cf=(x[31])?32'hBC369112:32'h3C369112;
else if(x[30:23]==8'd127 && x[22]) cf=(x[31])?32'hBC4075D8:32'h3C4075D8;
else if(x[30:23]==8'd128 && x[22:21]==2'd0) cf=(x[31])?32'h3BA57130:32'hBBA57130;
else if(x[30:23]==8'd128 && x[22:21]==2'd1) cf=(x[31])?32'h3BE222F2:32'hBBE222F2;
else if(x[30:23]==8'd128 && x[22:21]==2'd2) cf=(x[31])?32'h3BCB9663:32'hBBCB9663;
else if(x[30:23]==8'd128 && x[22:21]==2'd3) cf=(x[31])?32'h3B99FD54:32'hBB99FD54;
else if(x[30:23]==8'd129 && x[22:20]==3'd0) cf=(x[31])?32'h3B548396:32'hBB548396;
else if(x[30:23]==8'd129 && x[22:20]==3'd1) cf=(x[31])?32'h3B0B2D30:32'hBB0B2D30;
else if(x[30:23]==8'd129 && x[22:20]==3'd2) cf=(x[31])?32'h3AB0CAFC:32'hBAB0CAFC;
else if(x[30:23]==8'd129 && x[22:20]==3'd3) cf=(x[31])?32'h3A5C6F83:32'hBA5C6F83;
else if(x[30:23]==8'd129 && x[22:20]==3'd4) cf=(x[31])?32'h3A0802AE:32'hBA0802AE;
else if(x[30:23]==8'd129 && x[22:20]==3'd5) cf=(x[31])?32'h39A6B0B6:32'hB9A6B0B6;
else if(x[30:23]==8'd129 && x[22:20]==3'd6) cf=(x[31])?32'h394B7435:32'hB94B7435;
else if(x[30:23]==8'd129 && x[22:20]==3'd7) cf=(x[31])?32'h38F78B1E:32'hB8F78B1E;
else if(x[30:23]==8'd130 && x[22:19]==4'd0) cf=(x[31])?32'h3896A77B:32'hB896A77B;
else if(x[30:23]==8'd130 && x[22:19]==4'd1) cf=(x[31])?32'h383743AD:32'hB83743AD;
else if(x[30:23]==8'd130 && x[22:19]==4'd2) cf=(x[31])?32'h37DE017E:32'hB7DE017E;
else if(x[30:23]==8'd130 && x[22:19]==4'd3) cf=(x[31])?32'h37866820:32'hB7866820;
else if(x[30:23]==8'd130 && x[22:19]==4'd4) cf=(x[31])?32'h372355C2:32'hB72355C2;
else if(x[30:23]==8'd130 && x[22:19]==4'd5) cf=(x[31])?32'h36C4F4AC:32'hB6C4F4AC;
else if(x[30:23]==8'd130 && x[22:20]==3'd3) cf=(x[31])?32'h369C23B7:32'hB69C23B7;
else if(x[30:23]==8'd130 && x[22:20]==3'd4) cf=(x[31])?32'h35E5B8D9:32'hB5E5B8D9;
else if(x[30:23]==8'd130 && x[22:20]==3'd5) cf=(x[31])?32'h35290ADB:32'hB5290ADB;
else if(x[30:23]==8'd130 && x[22:20]==3'd6) cf=(x[31])?32'h3478BD16:32'hB478BD16;
else if(x[30:23]==8'd130 && x[22:20]==3'd7) cf=(x[31])?32'h33B70180:32'hB3B70180;
else cf=(x[31])?32'h00000000:32'h80000000;
end
else cf=32'd0;
end
    
endmodule
