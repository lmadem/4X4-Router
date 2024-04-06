//TestCase10 : The test is to send the stimulus from SA1 -> DA1, SA2 - DA2, SA3 - DA3, and SA4 - DA4 parallely
`include "base_test.sv"
`include "test_packet10.sv"
class test10 extends base_test;
  new_packet10 pkt10;
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
    $display("[Test10] run started at time=%0t", $realtime);
    
    //construct object for pkt10 handle
    pkt10 = new;
    
    //Decide number of packets to generate in generator
    no_of_pkts = 20;
    //$display(no_of_pkts);
    
    //Construct objects for environment and connects intefaces.
    build();
    
    //Pass new_packet10 oject to Generator.
    //Handle assignment packet=new_packet(b=d);
    for (bit [2:0] i=1; i<=4; i++) 
      env.gen_e.ref_pkt[i] = pkt10;
    
    //Start the Verification Environment
    env.run();
    
    
    $display("[Test10] run ended at time=%0t", $realtime);
  endtask

endclass
