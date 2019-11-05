class sif_agent extends uvm_agent;
  `uvm_component_utils(sif_agent)
  
  sequencer   sequencer_h;
  sif_driver  driver_h;
  sif_monitor monitor_h;
  slave_with_memory swm_h;
  
  uvm_analysis_port #(sif_seq_item) mon_ap;
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    sif_agent_config sif_agent_config_h;
    sif_monitor_config sif_monitor_config_h; 
    
    super.build_phase(phase);
       
    if(!uvm_config_db #(sif_agent_config)::get(this, "", "config", sif_agent_config_h))
      `uvm_fatal("AGENT", "Failed to get config object");
    is_active = sif_agent_config_h.get_is_active();
    
    if(get_is_active() == UVM_ACTIVE) begin : make_stimulus
      sequencer_h = sequencer ::type_id::create("sequencer_h", this);
      driver_h    = sif_driver::type_id::create("driver_h", this);
    end : make_stimulus
    else begin : create_memory
      swm_h = slave_with_memory::type_id::create("swm_h", this);
    end : create_memory
    
    sif_monitor_config_h = new(.bfm(sif_agent_config_h.bfm));
    uvm_config_db #(sif_monitor_config)::set(this, "monitor_h*", "config", sif_monitor_config_h);
    
    if(sif_agent_config_h.get_uses_xbus()==1)
      sif_monitor::type_id::set_type_override(xbus_monitor::get_type());
    else
      sif_monitor::type_id::set_type_override(wbus_monitor::get_type());
    
    monitor_h = sif_monitor::type_id::create("monitor_h", this);
    
    mon_ap = new("mon_ap", this);
  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
    if (get_is_active() == UVM_ACTIVE) begin
      driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
    end
    monitor_h.ap.connect(mon_ap);
  endfunction : connect_phase
endclass : sif_agent
