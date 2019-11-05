package sif_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  `include "sif_monitor_config.svh"
  `include "sif_agent_config.svh"
  `include "env_config.svh"
  
  `include "sif_seq_item.svh"
  `include "random_sequence.svh"
  
  typedef uvm_sequencer #(sif_seq_item) sequencer;  
  `include "sif_driver.svh"
  `include "sif_monitor.svh"
  `include "xbus_monitor.svh"
  `include "wbus_monitor.svh"
  
  `include "slave_with_memory.svh"

  `include "sif_agent.svh"
  `include "scoreboard.svh"
  `include "coverage.svh"
  `include "ref_mem.svh"
  `include "env.svh"
  
  `include "sif_test.svh"
endpackage : sif_pkg
