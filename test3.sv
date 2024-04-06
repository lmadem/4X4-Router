//TestCase3: The test is to send the stimulus to a single destination port

//Example : Sa* -> Da3
`include "base_test.sv"
`include "test_packet3.sv"
class test3 extends base_test;
  new_packet3 pkt3;
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
    $display("[Test3] run started at time=%0t", $realtime);
    
    //construct object for pkt3 handle
    pkt3 = new;
    
    //Decide number of packets to generate in generator
    no_of_pkts = 10;
    //$display(no_of_pkts);
    
    //Construct objects for environment and connects intefaces.
    build();
    
    //Pass new_packet3 oject to Generator.
    //Handle assignment packet=new_packet(b=d);
    for (bit [2:0] i=1; i<=4; i++) 
      env.gen.ref_pkt[i] = pkt3;
    
    //Start the Verification Environment
    env.run();
    
    
    $display("[Test3] run ended at time=%0t", $realtime);
  endtask

endclass
