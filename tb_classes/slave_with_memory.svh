class slave_with_memory extends uvm_component;
  `uvm_component_utils(slave_with_memory)
  
  virtual sif_bfm bfm;
  shortint unsigned memory[shortint unsigned];
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db #(virtual sif_bfm)::get(null, "*", "bfm", bfm))
      `uvm_fatal("SLAVE", "Failed to get interface");
  endfunction : build_phase
  
  task run_phase(uvm_phase phase);      
    shortint unsigned address, data;
    bit wr_s;
    
    forever begin : monitor_block
      @(bfm.monitor_cb);
    
      bfm.get_wbus(address, data, wr_s);
      
      if(wr_s) begin
        memory[address] = data;
        `uvm_info("MEMORY", $sformatf("Address: %4h\tValue: %4h", address, memory[address]), UVM_HIGH)
      end
    end
  endtask : run_phase
  
  function void report_phase(uvm_phase phase);
    int f;
    f = $fopen("mem.txt", "w");
    
    if(!f)
      `uvm_error("MEMORY", "File was not opened successfully")
    
    foreach(memory[address]) begin
      $fdisplay(f, "Address: %4h\tValue: %4h", address, memory[address]);
    end
    
    $fclose(f);
  endfunction : report_phase
endclass : slave_with_memory
