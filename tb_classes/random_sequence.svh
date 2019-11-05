class random_sequence extends uvm_sequence #(sif_seq_item);
  `uvm_object_utils(random_sequence)
  
  sif_seq_item command;
  
  function new (string name = "random_sequence");
    super.new(name);
  endfunction : new
  
  task body();
    repeat (100) begin : random_loop
      command = sif_seq_item::type_id::create("command");
      start_item(command);
      assert(command.randomize());
      `uvm_info("RANDOM", $sformatf("random command: %s", command.convert2string), UVM_FULL);
      finish_item(command);
    end : random_loop
  endtask : body
endclass : random_sequence
