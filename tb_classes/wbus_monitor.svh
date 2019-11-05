class wbus_monitor extends sif_monitor;
  `uvm_component_utils(wbus_monitor);
  
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
    
    bfm.get_wbus(cmd.addr, cmd.data_wr, cmd.wr_s);
      
    if(cmd.wr_s) begin
      `uvm_info("WBUS MONITOR", cmd.convert2string(), UVM_FULL);
      ap.write(cmd);
    end
  endtask : monitor_task
endclass : wbus_monitor
