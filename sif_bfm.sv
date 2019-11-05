interface sif_bfm(input bit clk);

  bit               rst_n;
  shortint unsigned xa_addr;
  shortint unsigned xa_data_wr;
  shortint unsigned xa_data_rd;
  bit               xa_wr_s;
  bit               xa_rd_s;
  shortint unsigned wa_addr;
  shortint unsigned wa_data_wr;
  bit               wa_wr_s;

  clocking driver_cb @(posedge clk);
    output rst_n;
    
    output xa_addr;
    output xa_data_wr;
    input  xa_data_rd;
    output xa_wr_s;
    output xa_rd_s;
    
    input  wa_addr;
    input  wa_data_wr;
    input  wa_wr_s;
  endclocking : driver_cb
  
  clocking monitor_cb @(posedge clk);
    input rst_n;
    
    input xa_addr;
    input xa_data_wr;
    input xa_data_rd;
    input xa_wr_s;
    input xa_rd_s;
    
    input wa_addr;
    input wa_data_wr;
    input wa_wr_s;
  endclocking : monitor_cb

  task reset();
    rst_n = 1'b0;
    @(driver_cb);
    @(driver_cb);
    rst_n = 1'b1;
  endtask : reset
  
  task master_write(input  shortint unsigned iaddr, 
                    input  shortint unsigned idata_wr,
                    output shortint unsigned idata_rd,
                    input  bit               write,
                    input  bit               read
                   );
    @(driver_cb);
    xa_wr_s = write;
    xa_rd_s = read;
    xa_addr = iaddr;
    xa_data_wr = idata_wr;
    idata_rd = xa_data_rd;
  endtask : master_write
  
  function void get_xbus_input(output shortint unsigned addr,
                         output shortint unsigned data_wr,
                         output bit               write,
                         output bit               read
                        );
    addr    = xa_addr;
    data_wr = xa_data_wr;
    write   = xa_wr_s;
    read    = xa_rd_s;
  endfunction : get_xbus_input
  
  function void get_xbus_output(output shortint unsigned data_rd);
    data_rd = xa_data_rd;
  endfunction : get_xbus_output
  
  function void get_wbus(output shortint unsigned addr,
                         output shortint unsigned data_wr,
                         output bit               write
                        );
    addr    = wa_addr;
    data_wr = wa_data_wr;
    write   = wa_wr_s;
  endfunction : get_wbus
endinterface : sif_bfm
