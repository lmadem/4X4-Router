//erroneous testcase
//TestCase7: TestCase7: The test is to drive the invalid Da ports and see the behaviour of design
`include "base_test.sv"
`include "test_packet7.sv"
class test7 extends base_test;
  new_packet7 pkt7;
  string testname; //used to identify the testcase
  bit [15:0] dropped_pkt_cnt; //used to read the control register(da_invalid_addr_dropped_pkt) from DUT
  //custom constructor with virtual interface handles as arguments.
  function new(input virtual router_if.tb_mod_port vif_in,
               input virtual router_if.tb_mon  vif_mon_in,
               input virtual router_if.tb_mon  vif_mon_out,
               input string testname
	          );
    
    //Call base_test class custom constructor with virtual interface handles as arguments.
    super.new(vif_in , vif_mon_in , vif_mon_out, testname);
    this.testname = testname;
  endfunction
  
  //run method to start Verification environment.
  virtual task run();
    $display("[Test7] run started at time=%0t", $realtime);
    
    //construct object for pkt7 handle
    pkt7 = new;
    
    //Decide number of packets to generate in generator
    no_of_pkts = 10;
    //$display(no_of_pkts);
    
    //Construct objects for environment and connects intefaces.
    build();
    env.env_disable_EOT = 1;
    env.env_disable_report = 1;
    
    //Pass new_packet7 oject to Generator.
    //Handle assignment packet=new_packet(b=d);
    for (bit [2:0] i=1; i<=4; i++) 
      env.gen.ref_pkt[i] = pkt7;
    
    //Start the Verification Environment
    env.run();
    if(env.env_disable_EOT == 1)
      wait(env.scb.total_input_pkts.sum() == 4*(no_of_pkts)); //wait till the input packets get collcted by scoreboard inbox
    
    repeat(2000) @(vif.cb); //drain time
    read_dut_csr();
    report();
    
    
    
    $display("[Test7] run ended at time=%0t", $realtime);
  endtask
  
  virtual task read_dut_csr();
    $display("[%s] Reading DUT Status registers Started at time=%0t", testname, $time);
    @(vif.cb);
    vif.cb.rd <= 1;
    vif.cb.addr <= 'h66; //da_invalid_pkt_dropped_count; //addr='h66;
    @(vif.cb.rdata);
    dropped_pkt_cnt = vif.cb.rdata;
    $display("\n\n*********************************");
    $display("***** CSR DUT Status*****************");
    $display("csr_pkt_dropped_count=%0d ",vif.cb.rdata);
    $display("\n\n*********************************");
    vif.cb.rd <= 0;
    repeat(2) @(vif.cb);
    $display("[%s] Reading DUT Status registers Ended at time=%0t",testname, $time);
  endtask
  
  function void report();
    $display("\n[%s] ****** Report Started **********", testname); 
    //Call report method of iMon,oMon and scoreboard
    for(bit [2:0] i=1; i<=4; i++)
      env.drv[i].report();
    for(bit [2:0] i=1; i<=4; i++)
      env.iMon[i].report();
    for(bit [2:0] i=1; i<=4; i++)
      env.oMon[i].report();
    env.scb.report();
    $display("[CSR] Status csr_pkt_dropped_count=%0d at time=%0t ",dropped_pkt_cnt, $realtime);
    $display("\n*******************************"); 
    //Check the results and print test Passed or Failed
    if(4*(no_of_pkts) == dropped_pkt_cnt) begin
      $display("***********[%s] PASSED ************",testname); 
      $display("****Total number of packets driven = %0d", no_of_pkts*4);
      $display("Dropped Packets Count from DUT = %0d", dropped_pkt_cnt);
    end
    else 
      begin
        $display("*********[%s] FAILED ************",testname);  
        $display("******dropped_pkt_count = %0d *********",dropped_pkt_cnt);
      end
    $display("*************************\n"); 
    $display("[Environment]*********Report ended**********\n"); 
  endfunction

endclass
