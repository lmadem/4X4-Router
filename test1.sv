//TestCase1: The purpose of this testcase1 is to implement 100% functional coverage through constrained random stimulus. Here the cover points are simple

//coverpoint sa has 4 bins, coverpoint da has 4 bins since the design can only support 4 source ports and 4 destination ports; cross sa, da; It cover 16 possible cases

//Sa1 -> Da1,Da2,Da3,Da4 : Sa2 -> Da1,Da2,Da3,Da4 : Sa3 -> Da1,Da2,Da3,Da4 : Sa4 -> Da1,Da2,Da3,Da4
`include "base_test.sv"
class test1 extends base_test;
  string testname; //used to identify the testcase
  //custom constructor with virtual interface handles as arguments.
  function new(input virtual router_if.tb_mod_port vif_in,
               input virtual router_if.tb_mon  vif_mon_in,
               input virtual router_if.tb_mon  vif_mon_out,
               input string testname
	          );
    
    //Call base_test class custom constructor with virtual interface handles as arguments.
    super.new(vif_in , vif_mon_in , vif_mon_out, testname);
  endfunction
  
  //run method to start Verification environment.
  virtual task run();
    $display("[Test1] run started at time=%0t", $realtime);
    
    //Decide number of packets to generate in generator
    
    no_of_pkts = 50;
    //$display(no_of_pkts);
    
    //Construct objects for environment and connects intefaces.
    build();
    env.cov_status = 1;
    
    //Start the Verification Environment
    env.run();
    
    
    $display("[Test1] run ended at time=%0t", $realtime);
  endtask

endclass
