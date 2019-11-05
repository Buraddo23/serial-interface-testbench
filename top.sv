`timescale 1ps / 1ps

import uvm_pkg::*;
import sif_pkg::*;
`include "uvm_macros.svh"
`include "sif_macros.svh"
  
`include "binding_module.sv"

module top;  
  reg         tb_clk;
  wire        tb_rst_n;
  wire [15:0] tb_xa_addr;
  wire [15:0] tb_xa_data_wr;
  wire [15:0] tb_xa_data_rd;
  wire        tb_xa_wr_s;
  wire        tb_xa_rd_s;
  wire [15:0] tb_wa_addr;
  wire [15:0] tb_wa_data_wr;
  wire        tb_wa_wr_s;
  
  sif DUT(.clk(tb_clk), 
          .rst_b(tb_rst_n), 
          .xa_addr(tb_xa_addr), 
          .xa_data_wr(tb_xa_data_wr), 
          .xa_data_rd(tb_xa_data_rd),
          .xa_wr_s(tb_xa_wr_s),
          .xa_rd_s(tb_xa_rd_s),
          .wa_addr(tb_wa_addr),
          .wa_data_wr(tb_wa_data_wr),
          .wa_wr_s(tb_wa_wr_s)
         );
         
  bind sif binding_module U_sif_assert(.*);
  
  always #10 tb_clk = ~tb_clk;
  
  initial begin
    tb_clk = 1'b0;
    run_test();
  end
  
endmodule : top
