module approx_add (
    input [31:0] a,b,
    input en,rst,
  output reg [31:0] out
);

reg [7:0] exp_r;
reg [23:0] man_a, man_b;

  always @(negedge en) begin
  if(!rst) begin
    man_a = a[22:0];
    man_b = b[22:0];
    man_a[23] = 1;
    man_b[23] = 1;

    if(a[30:23] >= b[30:23]) begin
        exp_r = a[30:23] - b[30:23];
        man_b = man_b >> exp_r;
        exp_r  = a[30:23];
    end

    else begin
        exp_r = b[30:23] - b[30:23];
        man_a = man_a >> exp_r;
        exp_r = b[30:23];
    end

    out[24:23] = 0;

  if(a[31] == 0 && b[31] == 0) begin
        out[24:0] = man_a + man_b;
    out[31] = 0; 
    end

    else if(a[31] == 0 && b[31] == 1 && man_a >= man_b) begin
        out[24:0] = man_a - man_b;
        out[31] = 1;
    end

    else if(a[31] == 0 && b[31] == 1 && man_a < man_b) begin
        out[24:0] = man_b - man_a;
        out[31] = 1;
    end

    else if(a[31] == 1 && b[31] == 0 && man_a >= man_b) begin
        out[24:0] = man_a - man_b;
        out[31] = 1;
    end

    else if(a[31] == 1 && b[31] == 0 && man_a < man_b) begin
        out[24:0] = man_b - man_a;
        out[31] = 0;
    end

    else if(a[31] == 1 && b[31] == 1) begin
        out[24:0] = man_a + man_b;
        out[31] = 1;
    end

    if(out[24] == 1) begin
        out[24:0] = out[24:0] >> 1;
        exp_r = exp_r + 1;
    end

    out[30:23] = exp_r;
    end
    else out<=0;
end
    
endmodule