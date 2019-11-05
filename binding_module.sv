module binding_module(
  output        rst_b, 
  output        clk,
  output        xa_wr_s,
  output        xa_rd_s,
  input         wa_wr_s,
  output [15:0] xa_addr,
  input  [15:0] xa_data_rd,
  output [15:0] xa_data_wr, 
  input  [15:0] wa_addr,
  input  [15:0] wa_data_wr
);

  import uvm_pkg::*;
  `include "uvm_macros.svh"
                     
  sif_bfm bfm(clk);
  
  assign rst_b      = bfm.rst_n;
  assign xa_addr    = bfm.xa_addr;
  assign xa_data_wr = bfm.xa_data_wr;
  assign xa_rd_s    = bfm.xa_rd_s;
  assign xa_wr_s    = bfm.xa_wr_s;
  
  assign bfm.wa_wr_s    = wa_wr_s;
  assign bfm.xa_data_rd = xa_data_rd;
  assign bfm.wa_addr    = wa_addr;
  assign bfm.wa_data_wr = wa_data_wr;
  
  initial begin
    uvm_config_db #(virtual sif_bfm)::set(null, "*", "bfm", bfm);
  end
  
  reg[15:0] prev_data_rd, prev_addr, prev_data_wr;
    
  assert property (@(posedge clk) xa_rd_s |-> ##1 prev_data_rd != xa_data_rd);
  assert property (@(posedge clk) xa_wr_s |-> ##1 (prev_addr != wa_addr) && (prev_data_wr != wa_data_wr));
  
  always @(posedge clk) begin
    prev_data_rd = xa_data_rd;
    prev_addr = wa_addr;
    prev_data_wr = wa_data_wr;
  end
endmodule : binding_module
