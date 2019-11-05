virtual class sif_monitor extends uvm_monitor;
  `uvm_component_utils(sif_monitor)
  
  virtual sif_bfm bfm;
  uvm_analysis_port #(sif_seq_item) ap;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase (uvm_phase phase);
    sif_monitor_config sif_monitor_config_h;
    super.build_phase(phase);
    
    if (!uvm_config_db #(sif_monitor_config)::get(this, "", "config", sif_monitor_config_h))
      `uvm_fatal("MONITOR", "Failed to get config object");
    bfm = sif_monitor_config_h.bfm;
  endfunction : build_phase
  
  task run_phase(uvm_phase phase);
    forever begin : monitor_block
      @(bfm.monitor_cb);
      fork
        monitor_task();
      join_none
    end
  endtask : run_phase
  
  pure virtual task monitor_task();
endclass : sif_monitor
