class sif_test extends uvm_test;
  `uvm_component_utils(sif_test);
  
  random_sequence random_h;
  env             env_h;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    virtual sif_bfm bfm;
    env_config env_config_h;
    
    super.build_phase(phase);
    
    if(!uvm_config_db #(virtual sif_bfm)::get(this, "", "bfm", bfm))
      `uvm_fatal("TEST", "Failed to get BFM");
    
    env_config_h = new(bfm);
    
    uvm_config_db #(env_config)::set(this, "env_h*", "config", env_config_h);
    
    random_h = random_sequence::type_id::create("random_h", this);
    env_h = env::type_id::create("env_h", this);
  endfunction : build_phase
  
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    random_h.start(env_h.master_agent_h.sequencer_h);
    phase.drop_objection(this);
  endtask : main_phase
endclass : sif_test
