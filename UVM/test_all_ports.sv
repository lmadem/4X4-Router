//test_all_ports : The test is to send the stimulus from SA1 -> DA1, SA2 -> DA2, SA3 -> DA3, and SA4 -> DA4 parallely
//Include sa1_da1_sequence, sa2_da2_sequence, sa3_da3_sequence, and sa4_da4_sequence for this test
//test_all_ports by extending from uvm_test
class test_all_ports extends uvm_test;
  //Register test_all_ports  into factory
  `uvm_component_utils(test_all_ports);
  
  //Instantiate environment component
  environment env;
  
  bit [7:0] pkt_count;
  
  //virtual interface
  virtual router_if vif;
  
  //custom constructor
  function new (string name = "test_all_ports", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void start_of_simulation_phase(uvm_phase phase);
  extern virtual task main_phase(uvm_phase phase);

endclass	

//build_phase to construct child components
function void test_all_ports::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  //Construct object for environment
  env = environment::type_id::create("env", this);
  
  //Below shown all are environment(testbench) configurations
  //Get the physical interface from program block
  uvm_config_db#(virtual router_if)::get(this, "", "vif", vif);
  
  //set the test name for readability in the environment
  uvm_config_db#(string)::set(this, "env.*", "test_name", get_type_name());
  
  for(bit [2:0] i=1; i<=4; i++) 
    begin
      //below are to set the physical interface to child components (drvr,iMon and oMon) 
      //Set the physical interface to Driver
      uvm_config_db#(virtual router_if.tb_mod_port)::set(this, $sformatf("env.m_agent[%0d]", i), "drvr_if", vif.tb_mod_port);
  
      //Set the physical interface to Input Monitor
      uvm_config_db#(virtual router_if.tb_mon)::set(this, $sformatf("env.m_agent[%0d]", i), "iMon_if", vif.tb_mon);
  
      //Set the physical interface to Output Monitor
      uvm_config_db#(virtual router_if.tb_mon)::set(this, $sformatf("env.s_agent[%0d]", i), "oMon_if", vif.tb_mon);
    
      //set the pkt count to be generated by sequence
      pkt_count = 2;
      uvm_config_db#(int)::set(this, $sformatf("env.m_agent[%0d].seqr", i), "item_count", pkt_count);
    end
  
  //Set the number of packets to retain in environment for the validation of test
  uvm_config_db#(int)::set(this, "env", "item_count", pkt_count*4);
  
  //Below shown settings are to configure sequencer to execute particular sequence in a particular phase
  
  //configure sequencer to execute reset_sequence in reset_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.reset_phase", "default_sequence", reset_sequence::get_type());
  
  //configure sequencer to execute config_sequence in configure_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.configure_phase", "default_sequence", config_sequence::get_type());
  
  //configure sequencer to execute sa1_da1_sequence in main_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.main_phase", "default_sequence", sa1_da1_sequence::get_type());
  
  //configure sequencer to execute sa2_da2_sequence in main_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[2].seqr.main_phase", "default_sequence", sa2_da2_sequence::get_type());
  
  //configure sequencer to execute sa3_da3_sequence in main_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[3].seqr.main_phase", "default_sequence", sa3_da3_sequence::get_type());
  
  //configure sequencer to execute sa4_da4_sequence in main_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[4].seqr.main_phase", "default_sequence", sa4_da4_sequence::get_type());
  
  //configure sequencer to execute shutdown_sequence in shutdown_phase of sequencer
  uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent[1].seqr.shutdown_phase", "default_sequence", shutdown_sequence::get_type());
  

endfunction

//start_of_simulation_phase to print testbench topology
function void test_all_ports::start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  //Print testbench topology
  uvm_root::get().print_topology();
  
  //Print factory override information
  uvm_factory::get().print();

endfunction

//main_phase to set drain_time
task test_all_ports::main_phase(uvm_phase phase);
  uvm_objection objection;
  super.main_phase(phase);
  
  //Get the phase objection object
  objection = phase.get_objection();
  
  //Set the Drain time..
  objection.set_drain_time(this, 15000ns);
  
  //The drain time is the amount of time to wait once all objections have been dropped
  
endtask
