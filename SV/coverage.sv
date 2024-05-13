//Coverage class
class coverage;
  //packet class and mailbox handle
  packet pkt;
  mailbox_inst mbx[4:1];
  string testname;
  
  real coverage_score_test1; //to keep track of coverage score for test1
  real coverage_score_test6; //to keep track of coverage score for test6
  
 //covergroup with required coverpoints for testcase1
  
  covergroup fcov1 with function sample(packet pkt);
    
    //coverpoint for sa port
    coverpoint pkt.sa{
      bins sa1 = {1};
      bins sa2 = {2};
      bins sa3 = {3};
      bins sa4 = {4};
    }
    
    //coverpoint for da port
    coverpoint pkt.da{
      bins da1 = {1};
      bins da2 = {2};
      bins da3 = {3};
      bins da4 = {4};
    }
    
    //cross to monitor sa,da combinations
    cross pkt.sa, pkt.da;
    
  endgroup
  
  //covergroup with required coverpoints for testcase6
  covergroup fcov6 with function sample(packet pkt);
    
    //Define bins for differnet sizes of packet using len .
    coverpoint pkt.len {
      bins length_small = {[12:50]};
      bins length_medium= {[51:200]};
      bins length_big = {[201:999]};
      bins length_extralarge = {[1000:1499]};
      bins jumbo_pkts= {[1500:2000]};
      //bins short_length={[$:11]};
      //bins max_length={[2001:$]};
    }
    
  endgroup
  
  //custom constructor with mailbox agrument
  function new(input mailbox_inst mbx_arg[4:1], string testname);
    mbx = mbx_arg;
    this.testname = testname;
    if(testname == "TestCase1")
      fcov1 = new;
    else if(testname == "TestCase6")
      fcov6 = new;
  endfunction
  
  
  //run method to start the coverage sampling
  virtual task run();
    fork
      get_pkt_sample(1);
      get_pkt_sample(2);
      get_pkt_sample(3);
      get_pkt_sample(4);
    join
  endtask
  
  //report method to print the final functional coverage collected.
  function void report();
    //Call get_coverage method on fcov to get the functional coverage 
    if(testname == "TestCase1") begin
      coverage_score_test1 = fcov1.get_coverage();
      $display("********* Functional Coverage **********");
      $display("** coverage_score_test1 = %0f ",coverage_score_test1);
      $display("**************************************");
    end
    else if(testname == "TestCase6") begin
      coverage_score_test6 = fcov6.get_coverage();
      $display("********* Functional Coverage **********");
      $display("** coverage_score_test6 = %0f ",coverage_score_test6);
      $display("**************************************");
    end
  endfunction
  
  
  task get_pkt_sample(bit [2:0] sa);
    packet pkt;
    while(1) 
      begin
        @(mbx[sa].num);
        mbx[sa].peek(pkt);
        //Call the sample with with transaction object as argument.
        if(testname == "TestCase1") begin
          fcov1.sample(pkt);
          coverage_score_test1 = fcov1.get_coverage();
          $display("[Coverage] Port %0d Coverage=%0f ",sa, fcov1.get_coverage());
          if(coverage_score_test1 == 100.00)
            begin
              $display("Hit %0f Coverage", coverage_score_test1);
              $display("Success");
              $display("Killing the [%s] from coverage component", testname);
              $finish;
            end
        end
        else if(testname == "TestCase6") begin
          fcov6.sample(pkt);
          coverage_score_test6 = fcov6.get_coverage();
          $display("[Coverage] Port %0d Coverage=%0f ",sa, fcov6.get_coverage());
          if(coverage_score_test6 == 100.00)
            begin
              $display("Hit %0f Coverage", coverage_score_test6);
              $display("Success");
              $display("Killing the [%s] from coverage component", testname);
              $finish;
            end
        end
      end
  endtask
  
endclass
