`timescale 1ns / 1ps

module block(
input clka, ena, wea,
input [7:0] addra,
input [31:0] dina,
output [31:0] douta 
);

blk_mem_gen_0 exp_mem(clka, ena, wea, addra, dina, douta);

endmodule
