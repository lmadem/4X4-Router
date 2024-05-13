//Include router verification environment package
`include "router_env_pkg.sv"


//Define program block with name program_router_tb with router interface as port.
program program_router_tb(router_if pif);
  
  //Import the UVM base class library
  import uvm_pkg::*;
  
  //Import router verification environment from router_env_pkg
  import router_env_pkg::*;
  
  //Include testcase
  //enable respective testcase line to run and give the testname in +UVM_TESTNAME argument
  //example for running test_all_ports enable line 27 and provide "test_all_ports" in the argument
  
  //`include "test_sa_da.sv"
  //`include "test_sa2.sv"
  //`include "test_da3.sv"
  //`include "test_equal_sizes.sv"
  //`include "test_full_size.sv"
  //`include "test_mixed_size.sv"
  //`include "test_invalid_da.sv"
  //`include "crc_test_callback.sv"
  `include "test_invalid_len.sv"
  //`include "test_all_ports.sv"
  
  initial 
    begin
      $timeformat(-9, 1, "ns", 10);
      //set the physical interface to test
      uvm_config_db#(virtual router_if)::set(null,"uvm_test_top","vif",pif);
      
      //Run the UVM environment to simulate the test
      run_test();
  
 
end

endprogram
