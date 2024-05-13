//Environment Class
//`include "coverage.sv"
class environment;
  
  string testname; //used to identify testcase 
  //component class handles
  generator gen; //generator class handle
  driver drv[4:1]; //driver class handles
  iMonitor iMon[4:1]; //iMonitor class handles
  oMonitor oMon[4:1]; //oMonitor class handles
  scoreboard scb; //scoreboard class handle
  coverage cov; //coverage class handle
  generator_ext gen_e; //generator extension class handle, used for test10
  
  bit [31:0] no_of_pkts;//assigned in testcase
  bit [31:0] dropped_count; //to keep a count of dropped packets using control status register
  bit env_disable_report; //will be triggered by the testclass
  bit env_disable_EOT; //will be disabled by the testclass
  
  bit cov_status; //will be used for coverage component
 
  //mailbox class handles
  
  mailbox_inst mbx_gen[4:1]; //will be connected to generator and driver(Generator->Driver)
  mailbox_inst mbx_imon[4:1];//will be connected to input monitor and scoreboard inbox(iMonitor->Scoreboard)
  mailbox_inst mbx_omon[4:1];//will be connected to output monitor and scoreboard outbox(oMonitor->Scoreboard)
  
  //virtual interface handles for driver, iMonitor, and oMonitor
  
  virtual router_if.tb_mod_port vif;
  virtual router_if.tb_mon vif_mon_in;
  virtual router_if.tb_mon vif_mon_out;
  
  //custom constructor with virtual interface handles as arguments and pkt count
  function new(input virtual router_if.tb_mod_port vif_arg,
               input virtual router_if.tb_mon  vif_mon_in_arg,
               input virtual router_if.tb_mon  vif_mon_out_arg,
               input bit [31:0] no_of_pkts,
               input string testname
              );
    vif = vif_arg;
    vif_mon_in = vif_mon_in_arg;
    vif_mon_out = vif_mon_out_arg;
    this.no_of_pkts = no_of_pkts;
    this.testname = testname;
  endfunction
  
  extern function void build();
  extern task run();
  extern function void report();
  
endclass
    
//build function for building verification components and connecting them
function void environment::build();
  $display("[Environment] build started at time=%t", $realtime);
  //Construct objects for mailbox handles
  for(bit [2:0] i=1; i<=4; i++) 
      begin
        mbx_gen[i] = new(1);
        mbx_imon[i] = new;
        mbx_omon[i] = new;
      end
  if(testname == "TestCase10")
    gen_e = new(mbx_gen[4:1], this.no_of_pkts);
  else
    gen = new(mbx_gen[4:1], this.no_of_pkts);
  
  //Construct all components and connect them
  for(bit [2:0] i=1; i<=4; i++)
    begin
      drv[i] = new(mbx_gen[i], vif);
      iMon[i] = new(mbx_imon[i], vif_mon_in);
      oMon[i] = new(mbx_omon[i], vif_mon_out);
    end
    
  scb = new(mbx_imon, mbx_omon);
  
  //coverage component and mailbox connection
  cov = new(mbx_imon, testname);
  
  $display("[Environment] build ended at time=%t", $realtime);
endfunction
    

task environment::run();
  $display("[Environment] run started at time=%t", $realtime); 
  $display("check %s", testname);
  //Starting all the components of environment
  fork
    if(testname == "TestCase10")
      gen_e.run();
    else
      gen.run();
    
    for(bit [2:0] i=1; i<=4 ; i++)
      fork
        automatic bit [2:0] k = i;
        drv[k].run();
        iMon[k].run();
        oMon[k].run();
      join_none
    
    scb.run();
    
    if(cov_status)
      cov.run();
  join_any

  if(testname == "Base_Test" && !env_disable_EOT)
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Base_Test termination
  if(testname == "TestCase1" && !env_disable_EOT)
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test1 termination
  else if(testname == "TestCase2" && !env_disable_EOT)
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test2 termination
  else if(testname == "TestCase3" && !env_disable_EOT)
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test3 termination
  else if(testname == "TestCase4" && !env_disable_EOT)
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test4 termination
  else if(testname == "TestCase5" && !env_disable_EOT)
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test5 termination
  else if(testname == "TestCase6" && !env_disable_EOT)
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test6 termination
  else if(testname == "TestCase7" && !env_disable_EOT) //will be disabled by test7
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test7 termination
  else if(testname == "TestCase8" && !env_disable_EOT) //will be disabled by test8
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test8 termination
  else if(testname == "TestCase9" && !env_disable_EOT) //will be disabled by test9
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test9 termination
  else if(testname == "TestCase10" && !env_disable_EOT)
    wait(scb.total_output_pkts.sum() == (4*no_of_pkts));//Test10 termination
  
  if(!env_disable_EOT) 
    scb.search_and_compare(); //call this function when this environment is enabled
  repeat(20) @(vif.cb);//drain time
  
  //Print results of all components
  if(!env_disable_report) 
    report();
  
  $display("[Environment] run ended at time=%t", $realtime); 
endtask
    
//Define report method to print results.
function void environment::report();
  $display("[Environment] ****** Report Started ********** "); 
  //Calling report methods of generator, iMon,oMon and scoreboard
  if(testname == "TestCase10")
    gen_e.report();
  else
    gen.report();
  
  for(bit [2:0] i=1; i<=4; i++) 
    drv[i].report();
  
  for(bit [2:0] i=1; i<=4; i++) 
    iMon[i].report();
  
  for(bit [2:0] i=1; i<=4; i++) 
    oMon[i].report();
  
  scb.report();
 
  
  $display("\n*******************************"); 
  //Check the results and print test Passed or Failed
  if(testname == "Base_Test" && (scb.m_mismatches == 0 && (4*no_of_pkts == scb.total_output_pkts.sum())))
    begin
      $display("***********%s PASSED************", testname); 
      $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
    end
  else if(testname == "TestCase1")
    begin
      cov.report();
      if(cov.coverage_score_test1 == 100.00)
        begin
          //Calling report method of coverage component;
          $display("***********%s PASSED************", testname); 
          $display("*****Functional_coverage=%0f *****", cov.coverage_score_test1);
          $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
        end 
      else 
        begin
          $display("***********%s FAILED************", testname); 
          $display("*****Functional_coverage=%0f *****", cov.coverage_score_test6);
          $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
        end
    end
  else if(testname == "TestCase2" && (scb.m_mismatches == 0 && (4*no_of_pkts == scb.total_output_pkts.sum())))
    begin
      $display("***********%s PASSED************", testname); 
      $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches); 
    end
  else if(testname == "TestCase3" && (scb.m_mismatches == 0 && (4*no_of_pkts == scb.total_output_pkts.sum())))
    begin
      $display("***********%s PASSED************", testname); 
      $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches); 
    end
  else if(testname == "TestCase4" && (scb.m_mismatches == 0 && (4*no_of_pkts == scb.total_output_pkts.sum())))
    begin
      $display("***********%s PASSED************", testname); 
      $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches); 
    end
  else if(testname == "TestCase5" && (scb.m_mismatches == 0 && (4*no_of_pkts == scb.total_output_pkts.sum())))
    begin
      $display("***********%s PASSED************", testname); 
      $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches); 
    end
  else if(testname == "TestCase6")
    begin
      cov.report();
      if(cov.coverage_score_test6 == 100.00)
        begin
          //Calling report method of coverage component;
          $display("***********%s PASSED************", testname); 
          $display("*****Functional_coverage=%0f *****", cov.coverage_score_test6);
          $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
        end 
      else 
        begin
          $display("***********%s FAILED************", testname); 
          $display("*****Functional_coverage=%0f *****", cov.coverage_score_test6);
          $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches);
        end
    end
  else if(testname == "TestCase10" && (scb.m_mismatches == 0 && (4*no_of_pkts == scb.total_output_pkts.sum())))
    begin
      $display("***********%s PASSED************", testname); 
      $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches); 
    end
  else
    begin
      $display("***********%s FAILED************", testname); 
      $display("*******Matches=%0d Mis_matches=%0d *********",scb.m_matches,scb.m_mismatches); 
    end
  
  $display("*************************\n "); 
  $display("[Environment] ******** Report ended******** \n"); 
endfunction


