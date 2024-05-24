`timescale 1ns / 1ps

module mux_26_1(
input [0:25] set,
input [7:0] select,
output res
);

assign res= (select==7'd0)?set[0]:(select==7'd1)?set[1]:(select==7'd2)?set[2]:(select==7'd3)?set[3]:
(select==7'd4)?set[4]:(select==7'd5)?set[5]:(select==7'd6)?set[6]:(select==7'd7)?set[7]:
(select==7'd8)?set[8]:(select==7'd9)?set[9]:(select==7'd10)?set[10]:(select==7'd11)?set[11]:
(select==7'd12)?set[12]:(select==7'd13)?set[13]:(select==7'd14)?set[14]:(select==7'd15)?set[15]:
(select==7'd16)?set[16]:(select==7'd17)?set[17]:(select==7'd18)?set[18]:(select==7'd19)?set[19]:
(select==7'd20)?set[20]:(select==7'd21)?set[21]:(select==7'd22)?set[22]:(select==7'd23)?set[23]:
(select==7'd24)?set[24]:set[25];
    
endmodule
