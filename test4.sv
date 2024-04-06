//TestCase4: The test is to send the stimulus packets of equal sizes
`include "base_test.sv"
`include "test_packet4.sv"
class test4 extends base_test;
  new_packet4 pkt4;
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
    $display("[Test4] run started at time=%0t", $realtime);
    
    //construct object for pkt4 handle
    pkt4 = new;
    
    //Decide number of packets to generate in generator
    no_of_pkts = 10;
    //$display(no_of_pkts);
    
    //Construct objects for environment and connects intefaces.
    build();
    
    //Pass new_packet4 oject to Generator.
    //Handle assignment packet=new_packet(b=d);
    for (bit [2:0] i=1; i<=4; i++) 
      env.gen.ref_pkt[i] = pkt4;
    
    //Start the Verification Environment
    env.run();
    
    
    $display("[Test4] run ended at time=%0t", $realtime);
  endtask

endclass
