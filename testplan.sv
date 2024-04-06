//This testplan is to verify the 4X4 Router functionality. It includes design functionality checks, erroneous test cases and error injection check

//**********************************************************************************************************
//BaseTest : The purpose of this test is to implement the fundamental functionality of the design. This base_test will be extended to create various testcases in the environment - PASS

//TestCase1: The purpose of this testcase1 is to implement 100% functional coverage through constrained random stimulus - PASS

//Here the cover points are simple. coverpoint sa has 4 bins, coverpoint da has 4 bins since the design can only support 4 source ports and 4 destination ports; cross sa, da; It cover 16 possible cases

//Sa1 -> Da1,Da2,Da3,Da4 : Sa2 -> Da1,Da2,Da3,Da4 : Sa3 -> Da1,Da2,Da3,Da4 : Sa4 -> Da1,Da2,Da3,Da4

//**********************************************************************************************************

//TestCase2: The test is to send the stimulus from a single source port - PASS

//Example : Sa2 -> Da*

//**********************************************************************************************************

//TestCase3: The test is to send the stimulus to a single destination port - PASS

//Example : Sa* -> Da3

//**********************************************************************************************************

//TestCase4: The test is to send the stimulus packets of equal sizes - PASS

//**********************************************************************************************************

//TestCase5: The test is to send the stimulus packets of full size(2000 bytes) - PASS

//**********************************************************************************************************

//TestCase6: The test is to send the stimulus packets of mixed-sizes and hit the 100% coverage - PASS

//**********************************************************************************************************

//erroneous testcase
//TestCase7: The test is to drive the invalid Da ports and see the behaviour of design - PASS

//(Notes : Driving invalid da addresses can be acheived but the simulation will hang when the scoreboard starts collecting packet from output monitor, as the packet do not exists at the destination port.The output monitor logic will end up in forever loop. Therefore quitting the simulation when scoreboard inbox collects all the packets from input monitor and that should match with dropped_pkt_count(reads dut status register). Adding an extra delay for the DUT to sample the packets and observe the behaviour).

//**********************************************************************************************************

//error injection 
//TestCase8: The test is to inject the invalid crc in the packet and see the behaviour of design - PASS


//erroneous testcase
//TestCase9 : The test is to drive the invalid packet length and see the behaviour of design - PASS


//TestCase10 : The test is to send the stimulus from SA1 -> DA1, SA2 - DA2, SA3 - DA3, and SA4 - DA4 parallely - PASS

