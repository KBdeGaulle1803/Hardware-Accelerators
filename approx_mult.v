`timescale 1ns/1ps

module approx_mult(
  input [31:0] a,b,
  input en,rst,
  output reg [31:0] out 
);

reg [23:0] man_a, man_b;
reg [7:0] exp_f;
reg [47:0] man_f;

always @(posedge en) begin
if(!rst) begin
  out[31] = a[31]^b[31];
  man_a[23] = (a[30:23]!=0);
  man_b[23] = (b[30:23]!=0);
  man_a[22:0] = (a[30:23]!=0)?a[22:0]:0;
  man_b[22:0] = (b[30:23]!=0)?b[22:0]:0;
  exp_f = (a[30:23]+b[30:23]>9'd124)?a[30:23]+b[30:23]-9'd125:0;
  exp_f = (a[30:23]+b[30:23]>9'd254)?9'd255:exp_f;
  exp_f = (a[30:23] && b[30:23])?exp_f:0;
  exp_f = (a[30:23]==255 || b[30:23]==255)?255:exp_f;
  man_f = (exp_f)?man_a*man_b:0;
  if(man_f[47] == 1)  {exp_f,man_f} = {(exp_f==255)?255:exp_f+1,man_f>>1};
  else {exp_f,man_f} = {exp_f,man_f};
  

  out[30:23] = exp_f[7:0];
  out[22:0] = man_f[45:23];
  end 
else
{exp_f, man_a, man_b, man_f, out} = 0;
end
    
endmodule
