`uvm_analysis_imp_decl(_xbus)
`uvm_analysis_imp_decl(_wbus)

class sif_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(sif_scoreboard)
  
  uvm_analysis_imp_xbus #(sif_seq_item, sif_scoreboard) ap_x;
  uvm_analysis_imp_wbus #(sif_seq_item, sif_scoreboard) ap_w;
  
  sif_seq_item wr_tr_q[$];
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap_x = new("ap_x", this);
    ap_w = new("ap_w", this);
  endfunction : build_phase
  
  
  function shortint unsigned predict_read(shortint unsigned addr);
    return {addr[15:9], addr[8]^addr[4], addr[7]^addr[5], addr[6:0]};
  endfunction : predict_read
  
  function void compare_read(sif_seq_item pkt);
    if (predict_read(pkt.addr) == pkt.data_rd)
      `uvm_info("SELF CHECKER", {"READ PASS: \nxbus: ", pkt.convert2string()}, UVM_HIGH)
    else
      `uvm_error("SELF CHECKER", {"READ FAIL: \nxbus: ", pkt.convert2string()})
  endfunction : compare_read
  
  
  function void write_xbus(sif_seq_item t);
    `uvm_info("SCOREBOARD", {"Received: ", t.convert2string()}, UVM_FULL);
    
    if(t.rd_s && ~t.wr_s) begin : verify_read_op
      compare_read(t);
    end : verify_read_op
    else if(~t.rd_s && t.wr_s) begin : verify_write_op
      wr_tr_q.push_back(t);
    end : verify_write_op
    else if(~t.rd_s && ~t.wr_s) begin : idle_op
      `uvm_info("SELF CHECKER", "IDLE COMMAND", UVM_FULL)
    end : idle_op
    else begin : illegal_op
      `uvm_info("SELF CHECKER", "ILLEGAL", UVM_MEDIUM)
      wr_tr_q.push_back(t);
    end : illegal_op
  endfunction : write_xbus
  
  function void write_wbus(sif_seq_item t);
    sif_seq_item x;
    
    `uvm_info("SCOREBOARD", {"Received: ", t.convert2string()}, UVM_FULL);
    
    x = wr_tr_q.pop_front();
    
    if(x.wr_s && x.rd_s) begin : illegal_op
      x.rd_s = 0;
    end : illegal_op
      
    if(!t.compare(x))
      `uvm_error("SELF CHECKER", {"WRITE FAIL: \nxbus: ", x.convert2string(), "\nwbus: ", t.convert2string()})
    else
      `uvm_info("SELF CHECKER", {"WRITE PASS: \nxbus: ", x.convert2string(), "\nwbus: ", t.convert2string()}, UVM_HIGH);
  endfunction : write_wbus
endclass : sif_scoreboard
