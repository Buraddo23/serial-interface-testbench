class coverage extends uvm_subscriber #(sif_seq_item);
  `uvm_component_utils(coverage)
  
  enum {idle, read_op, write_op, illegal} op;
  
  covergroup op_cov;
    coverpoint op {
      bins ops[] = {[idle:illegal]};
    
      bins transitions[] = (idle, read_op, write_op, illegal => idle, read_op, write_op, illegal);
    }
  endgroup
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    op_cov = new();
  endfunction : new
  
  function void write(sif_seq_item t);
    $cast(op, t.rd_s + t.wr_s*2);
    op_cov.sample();
  endfunction : write
endclass : coverage
