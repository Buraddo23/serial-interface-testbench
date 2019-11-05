class env_config;
 virtual sif_bfm bfm;

 function new(virtual sif_bfm bfm);
    this.bfm = bfm;
 endfunction : new
endclass : env_config
