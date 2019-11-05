class xbus_monitor extends sif_monitor;
  `uvm_component_utils(xbus_monitor);
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    ap = new("ap", this);
  endfunction : build_phase
  
  task monitor_task();
    sif_seq_item cmd;
    cmd = new("cmd");
    
    bfm.get_xbus_input(cmd.addr, cmd.data_wr, cmd.wr_s, cmd.rd_s);
              
    if (cmd.rd_s && ~cmd.wr_s) begin : read_op
      @(bfm.monitor_cb);
      bfm.get_xbus_output(cmd.data_rd);
    end else begin : no_write_illegal_op
      cmd.data_rd = 0;
    end
        
    `uvm_info("XBUS MONITOR", cmd.convert2string(), UVM_FULL);
    ap.write(cmd);
  endtask : monitor_task
endclass : xbus_monitor
