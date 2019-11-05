class sif_agent_config;
  virtual sif_bfm bfm;
  protected uvm_active_passive_enum is_active;
  protected bit uses_xbus;

  function new (virtual sif_bfm bfm, uvm_active_passive_enum is_active, bit uses_xbus);
    this.bfm = bfm;
    this.is_active = is_active;
    this.uses_xbus = uses_xbus;
  endfunction : new

  function uvm_active_passive_enum get_is_active();
    return is_active;
  endfunction : get_is_active
   
  function bit get_uses_xbus();
    return uses_xbus;
  endfunction : get_uses_xbus
endclass : sif_agent_config
