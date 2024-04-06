//TestCase6: The test is to send the stimulus packets of mixed-sizes and hit the 100% coverage
`include "base_test.sv"
`include "test_packet6.sv"
class test6 extends base_test;
  new_packet6 pkt6;
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
    $display("[Test6] run started at time=%0t", $realtime);
    
    //construct object for pkt6 handle
    pkt6 = new;
    
    //Decide number of packets to generate in generator
    no_of_pkts = 20;
    //$display(no_of_pkts);
    
    //Construct objects for environment and connects intefaces.
    build();
    env.cov_status = 1;
    
    //Pass new_packet6 oject to Generator.
    //Handle assignment packet=new_packet(b=d);
    for (bit [2:0] i=1; i<=4; i++) 
      env.gen.ref_pkt[i] = pkt6;
    
    //Start the Verification Environment
    env.run();
    
    
    $display("[Test6] run ended at time=%0t", $realtime);
  endtask

endclass
