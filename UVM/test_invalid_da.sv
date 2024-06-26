//This test is to drive invalid da addresses in the DA port and see the behaviour of the design
class test_invalid_da extends uvm_test;
  //Register test_invalid_da into factory
  `uvm_component_utils(test_invalid_da);
  
  //Instantiate environment component
  environment env;
  
  //virtual interface
  virtual router_if vif;
  
  bit [31:0] dropped_pkt_count;
  bit [31:0] exp_pkt_count;  
  
  //custom constructor
  function new (string name = "test_invalid_da", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);
  extern virtual task shutdown_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
endclass	

//build_phase to construct child components
function void test_invalid_da::build_phase(uvm_phase phase);
  super.build_phase(phase);
  //packet count
  exp_pkt_count = 15;
  //Construct object for environment
  env = environment::type_id::create("env", this);
  
  //factory override by type (packet to packet_invalid_da)
  set_type_override_by_type(packet::get_type(), packet_invalid_da::get_type());
  
  //Below shown all are environment(testbench) configurations
  //Get the physical interface from program block
  uvm_config_db#(virtual router_if)::get(this, "", "vif", vif);
  
  //set the test name for readability in the environment
  uvm_config_db#(string)::set(this, "env.*", "test_name", get_type_name());
  
  for(bit [2:0] i=1; i<=4; i++) begin
    //below are to set the physical interface to child components (drvr,iMon and oMon) 
    //Set the physical interface to Driver
    uvm_config_db#(virtual router_if.tb_mod_port)::set(this, $sformatf("env.m_agent[%0d]", i), "drvr_if", vif.tb_mod_port);
  
    //Set the physical interface to Input Monitor
    uvm_config_db#(virtual router_if.tb_mon)::set(this, $sformatf("env.m_agent[%0d]", i), "iMon_if", vif.tb_mon);
  
    //Set the physical interface to Output Monitor
    uvm_config_db#(virtual router_if.tb_mon)::set(this, $sformatf("env.s_agent[%0d]", i), "oMon_if", vif.tb_mon);
    
    //set the pkt count to be generated by sequence
    uvm_config_db#(int)::set(this, $sformatf("env.m_agent[%0d].seqr", i), "item_count", exp_pkt_count);
  end
  
  //Set the number of packets to retain in environment for the validation of test
  uvm_config_db#(int)::set(this, "env", "item_count", exp_pkt_count*4);
  
  //Below shown settings are to configure sequencer to execute particular sequence in a particular phase
  
  //configure sequencer to execute reset_sequence in reset_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.reset_phase", "default_sequence", reset_sequence::get_type());
  
  //configure sequencer to execute config_sequence in configure_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.configure_phase", "default_sequence", config_sequence::get_type());
  
  //configure sequencer to execute sa1_da1_sequence in main_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.main_phase", "default_sequence", invalid_da_sequence::get_type());
  
  //configure sequencer to execute sa2_da2_sequence in main_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[2].seqr.main_phase", "default_sequence", invalid_da_sequence::get_type());
  
  //configure sequencer to execute sa3_da3_sequence in main_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[3].seqr.main_phase", "default_sequence", invalid_da_sequence::get_type());
  
  //configure sequencer to execute sa4_da4_sequence in main_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[4].seqr.main_phase", "default_sequence", invalid_da_sequence::get_type());
  
  //configure sequencer to execute shutdown_sequence in shutdown_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.shutdown_phase", "default_sequence", invalid_da_shutdown_seq::get_type());
  
  uvm_config_db#(bit)::set(this,"env","enable_report",1'b1); 

endfunction

//start_of_simulation_phase to print testbench topology
function void test_invalid_da::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  //Print testbench topology
  uvm_root::get().print_topology();
  
  //Print factory override information
  uvm_factory::get().print();

endfunction

//main_phase to set drain_time
task test_invalid_da::main_phase(uvm_phase phase);
  uvm_objection objection;
  super.main_phase(phase);
  
  //Get the phase objection object
  objection = phase.get_objection();
  
  //Set the Drain time..
  objection.set_drain_time(this, 2500ns);
  
  //The drain time is the amount of time to wait once all objections have been dropped
  
endtask
    
    
//Run shutdown sequence in shutdown phase to read drooped count from DUT
task test_invalid_da::shutdown_phase(uvm_phase phase);
  //Instantiate and construct shutdown sequence
  invalid_da_shutdown_seq seq;
  seq = invalid_da_shutdown_seq::type_id::create("seq", this);
  phase.raise_objection(this, "Raised objection from Invalid DA test");
  //Start the shutdown seq on sequencer
  seq.start(this.env.m_agent[1].seqr);
  
  //Get the dropped count from seq which helps in deciding test pass or fail
  dropped_pkt_count = seq.dropped_pkt_count;
  phase.drop_objection(this, "Dropped objection from Invalid DA test");
endtask
    
 
//report_phase to print test PASS or FAIL results.
function void test_invalid_da::report_phase(uvm_phase phase);
  //Check if total pkts dropped by dut equal to pkts driven into DUT 
  if(exp_pkt_count*4 != dropped_pkt_count) begin

    `uvm_info("FAIL", "****************Test FAILED******************", UVM_NONE);
    `uvm_info("FAIL","Test Failed due to packet count MIS_MATCH",UVM_NONE); 
    `uvm_info("FAIL",$sformatf("exp_pkt_count=%0d Dropped_pkt_count=%0d ",exp_pkt_count*4,dropped_pkt_count),UVM_NONE); 
    `uvm_fatal("FAIL","******************Test FAILED ************");
  end
  //Test Passed as all packets dropped by DUT.
  else begin
    `uvm_info("PASS", "******************Test PASSED ***************",UVM_NONE);
    `uvm_info("PASS",$sformatf("exp_pkt_count=%0d Dropped_pkt_count=%0d ",exp_pkt_count*4,dropped_pkt_count),UVM_NONE); 
    `uvm_info("PASS","******************************************",UVM_NONE);
  end
endfunction
      