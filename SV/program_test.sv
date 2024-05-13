`include "package.sv"
program testbench(router_if vif);
  import router_pkg::*;
  
  //Include test cases
  `include "base_test.sv"
  //`include "test1.sv"
  //`include "test2.sv"
  //`include "test3.sv"
  //`include "test4.sv"
  //`include "test5.sv"
  //`include "test6.sv"
  //`include "test7.sv"
  //`include "test8.sv"
  //`include "test9.sv"
  //`include "test10.sv"
  
  //Define test class handles
  base_test test;
  //test1 t1;
  //test2 t2;
  //test3 t3;
  //test4 t4;
  //test5 t5;
  //test6 t6;
  //test7 t7;
  //test8 t8;
  //test9 t9;
  //test10 t10;
  
  
  //testname to identify the testcase name
  string testname;
  //Pass argument "Base_Test" to run "base_test.sv"
  //Pass argument "TestCase1" to run "test1.sv"
  //Pass argument "TestCase2" to run "test2.sv"
  //Pass argument "TestCase3" to run "test3.sv"
  //Pass argument "TestCase4" to run "test4.sv"
  //Pass argument "TestCase5" to run "test5.sv"
  //Pass argument "TestCase6" to run "test6.sv"
  //Pass argument "TestCase7" to run "test7.sv"
  //Pass argument "TestCase8" to run "test8.sv"
  //Pass argument "TestCase9" to run "test9.sv"
  //Pass argument "TestCase10" to run "test10.sv"
  
  
  
  //Verification Flow
  initial
    begin
      $display("[Program Block] Simulation Started at time=%0t", $realtime);
      
      //Construct test object and pass required interface handles
      test = new(vif.tb_mod_port, vif.tb_mon, vif.tb_mon, "Base_Test");
      //t1 = new(vif.tb_mod_port, vif.tb_mon, vif.tb_mon, "TestCase1");
      
      //start the testcase.
      test.run();
      //t1.run();
      $display("[Program Block] Simulation Finished at time=%0t", $realtime);
    end

endprogram

