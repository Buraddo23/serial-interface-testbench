class env extends uvm_env;
  `uvm_component_utils(env);
  
  sif_agent        master_agent_h, slave_agent_h;
  sif_scoreboard   sif_scoreboard_h;
  reference_memory ref_mem_h;
  coverage         coverage_h;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);          
    env_config env_config_h;
    sif_agent_config master_config_h, slave_config_h;
    
    super.build_phase(phase);
    
    if(!uvm_config_db #(env_config)::get(this, "", "config", env_config_h))
      `uvm_fatal("ENV", "Failed to get config");
  
    master_config_h = new(.bfm(env_config_h.bfm), .is_active(UVM_ACTIVE),  .uses_xbus(1));
    slave_config_h  = new(.bfm(env_config_h.bfm), .is_active(UVM_PASSIVE), .uses_xbus(0));
    
    uvm_config_db #(sif_agent_config)::set(this, "master_agent_h*", "config", master_config_h);
    uvm_config_db #(sif_agent_config)::set(this, "slave_agent_h*",  "config", slave_config_h);
    
    master_agent_h = sif_agent::type_id::create("master_agent_h", this);
    slave_agent_h  = sif_agent::type_id::create("slave_agent_h",  this);
    
    sif_scoreboard_h = sif_scoreboard  ::type_id::create("sif_scoreboard_h", this);
    ref_mem_h        = reference_memory::type_id::create("ref_mem_h",        this);
    coverage_h       = coverage        ::type_id::create("coverage_h",       this);
  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
    master_agent_h.mon_ap.connect(sif_scoreboard_h.ap_x);
    master_agent_h.mon_ap.connect(ref_mem_h.ap);
    slave_agent_h.mon_ap.connect(sif_scoreboard_h.ap_w);
    master_agent_h.mon_ap.connect(coverage_h.analysis_export);
  endfunction :connect_phase
endclass : env
