//Include environment classes
`include "environment.sv"
//Base_test class
class base_test;
  
  string testname; //used to identify testcase in environment
  bit [31:0] no_of_pkts; //Stimulus packet count
  
  //virtual interface handles for Driver,iMonitor and oMonitor
  virtual router_if.tb_mod_port vif;
  virtual router_if.tb_mon      vif_mon_in;
  virtual router_if.tb_mon      vif_mon_out;
  
  //enviroment class handle
  environment env;
  
  //custom constructor with virtual interface handles as arguments.
  function new (input virtual router_if.tb_mod_port vif_arg,
                input virtual router_if.tb_mon  vif_mon_in_arg,
                input virtual router_if.tb_mon  vif_mon_out_arg,
                input string testname
	           );
    vif = vif_arg;
    vif_mon_in = vif_mon_in_arg;
    vif_mon_out = vif_mon_out_arg;
    this.testname = testname;
  endfunction
  
  extern virtual function void build();
  extern virtual task run();
    
endclass
    
 
//build function to build verification environment and connect them.
function void base_test::build();
  //Constructing object for environment and connect interfaces
  $display("Entered the build block at base test");
  env = new(vif, vif_mon_in, vif_mon_out, no_of_pkts,this.testname);
  $display("[Base_Test] Build %s", testname);
  //Calling env build method which contruct its internal components and connects them
  env.build();
endfunction

//run method to start Verification environment.
task base_test::run();
  $display("[Base_Test] run started at time=%0t",$realtime);
  //number of packets to generate in generator
  no_of_pkts = 10;
  build();
  //tart the Verification Environment
  env.run();
  $display("[Base_Test] run ended at time=%0t", $realtime);
endtask




