class sif_driver extends uvm_driver #(sif_seq_item);
  `uvm_component_utils(sif_driver)
  
  virtual sif_bfm bfm;
  int seq;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual sif_bfm)::get(null, "*", "bfm", bfm))
      `uvm_fatal("DRIVER", "Failed to get BFM");
  endfunction : build_phase
  
  task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
    bfm.reset();
    phase.drop_objection(this);
  endtask : reset_phase
  
  task main_phase(uvm_phase phase);
    sif_seq_item cmd;
    super.main_phase(phase);
    
    forever begin : cmd_loop
      shortint unsigned data_rd;
      
      seq_item_port.get_next_item(cmd);
      bfm.master_write(cmd.addr, cmd.data_wr, data_rd, cmd.wr_s, cmd.rd_s);
      `uvm_info("DRIVER", $sformatf("driven command: %s", cmd.convert2string), UVM_DEBUG);
      cmd.data_rd = data_rd;
      seq_item_port.item_done();
    end : cmd_loop
  endtask : main_phase
  
  task shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    
    phase.raise_objection(this);
    @(bfm.driver_cb);
    phase.drop_objection(this);
  endtask : shutdown_phase
endclass : sif_driver
