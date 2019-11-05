`timescale 1ps / 1ps
/*
small interface - for training purpose.
write is passed after one clock to the output.
read returns the address with a few bits changed, after one clock.
*/

module sif (
   rst_b, clk,
   xa_wr_s, xa_rd_s, xa_addr, xa_data_wr, xa_data_rd, 
   wa_wr_s, wa_addr, wa_data_wr
);

input rst_b, clk, xa_wr_s, xa_rd_s;
input [15:0] xa_addr, xa_data_wr;
output wa_wr_s;
output [15:0] xa_data_rd, wa_addr, wa_data_wr;

wire rst_b, clk, xa_wr_s, xa_rd_s, wa_wr_s;
wire [15:0] xa_addr, xa_data_wr, xa_data_rd, wa_addr, wa_data_wr;
wire bit8_xor_4, bit7_xor_5;
wire [15:0] data_rd_mint;


//addr 05de data 04de
//addr 0463 data 04e3
//addr 1305 data 1305

//always @(posedge clk) $display($time, " SIF1 read %x addr %x data %x", xa_rd_s, xa_addr, xa_data_rd);

assign data_rd_mint = xa_rd_s ? { xa_addr[15:9], bit8_xor_4, bit7_xor_5,  xa_addr[6:0] } : 0;
assign bit8_xor_4 =  xa_addr[8] ^ xa_addr[4];
assign bit7_xor_5 =  xa_addr[7] ^ xa_addr[5];

dff16_en dff1 (.rst_b(rst_b), .clk(clk), .en(1'b1), .d(data_rd_mint), .q(xa_data_rd) );

dff_en   dff2 (.rst_b(rst_b), .clk(clk), .en(1'b1),    .d(xa_wr_s),      .q(wa_wr_s) );

dff16_en dff3 (.rst_b(rst_b), .clk(clk), .en(xa_wr_s), .d(xa_data_wr),   .q(wa_data_wr) );
dff16_en dff4 (.rst_b(rst_b), .clk(clk), .en(xa_wr_s), .d(xa_addr),      .q(wa_addr) );

endmodule


module dff_en  (clk, d, rst_b, en, q);

input  clk, d, rst_b, en;
output q;
reg    q;

always @(posedge clk or negedge rst_b)
   if (!rst_b)  q <= 1'b0;
   else if (en) q <= d;
	  
endmodule

module dff16_en  (clk, d, rst_b, en, q);

input  clk, rst_b, en;
input  [15:0] d;
output [15:0] q;
reg    [15:0] q;

always @(posedge clk or negedge rst_b)
   if (!rst_b)  q <= 16'b0;
   else if (en) q <= d;
	  
endmodule



