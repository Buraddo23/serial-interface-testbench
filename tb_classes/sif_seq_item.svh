class sif_seq_item extends uvm_sequence_item;
  `uvm_object_utils(sif_seq_item);
  
  rand shortint unsigned addr;
  rand bit               wr_s;
  rand bit               rd_s;
  
  rand shortint unsigned data_wr;
  
       shortint unsigned data_rd;
       
  constraint wr_rd_c {
    (wr_s+rd_s) dist {
      0 := 5,
      1 := 10,
      2 := 3
    };                      
  }
  
  function new(string name = "");
    super.new(name);
  endfunction : new
  
  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    sif_seq_item tested;
      
    if (rhs==null) 
      `uvm_fatal(get_type_name(), "Tried to do comparison to a null pointer");
      
    if (!$cast(tested,rhs))
      return 0;
    else
      return super.do_compare(rhs, comparer) && 
             (tested.addr == addr) &&
             (tested.wr_s == wr_s) &&
             (tested.rd_s == rd_s) &&
             (tested.data_wr == data_wr) &&
             (tested.data_rd == data_rd);
   endfunction : do_compare

   function void do_copy(uvm_object rhs);
     sif_seq_item RHS;
     assert(rhs != null) else
       $fatal(1,"Tried to copy null transaction");
     super.do_copy(rhs);
     assert($cast(RHS,rhs)) else
       $fatal(1,"Faied cast in do_copy");
     addr = RHS.addr;
     wr_s = RHS.wr_s;
     rd_s = RHS.rd_s;
     data_wr = RHS.data_wr;
     data_rd = RHS.data_rd;
   endfunction : do_copy
  
  function string convert2string();
    return $sformatf("Addr: %4h  R: %1h  W: %1h  data_r: %4h  data_w: %4h",
                    addr, rd_s, wr_s, data_rd, data_wr);
  endfunction : convert2string
endclass : sif_seq_item
