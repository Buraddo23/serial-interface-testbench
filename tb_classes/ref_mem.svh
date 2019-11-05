class reference_memory extends uvm_component;
  `uvm_component_utils(reference_memory)
  
  uvm_analysis_imp #(sif_seq_item, reference_memory) ap;
  shortint unsigned memory[shortint unsigned];
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    ap = new("ap", this);
  endfunction : build_phase
  
  function void write(sif_seq_item t);
    if(t.wr_s) begin
      memory[t.addr] = t.data_wr;
     `uvm_info("REFERENCE MEMORY", {"Received: ", t.convert2string()}, UVM_FULL);
    end
  endfunction : write
  
  function void report_phase(uvm_phase phase);
    int f;
    f = $fopen("ref_mem.txt", "w");
    
    if(!f)
      `uvm_error("MEMORY", "File was not opened successfully")
    
    foreach(memory[address]) begin
      $fdisplay(f, "Address: %4h\tValue: %4h", address, memory[address]);
    end
    
    $fclose(f);
  endfunction : report_phase
endclass : reference_memory
