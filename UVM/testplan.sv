//This testplan is to verify the 4X4 Router functionality. It includes design functionality checks, erroneous test cases and error injection check

//**********************************************************************************************************
//test_sa_da : The purpose of this is to implement 100% functional coverage through constrained random stimulus and directed stimulus - PASS

//Here the cover points are simple. coverpoint sa has 4 bins, coverpoint da has 4 bins since the design can only support 4 source ports and 4 destination ports; cross sa, da; It cover 16 possible cases

//Sa1 -> Da1,Da2,Da3,Da4 : Sa2 -> Da1,Da2,Da3,Da4 : Sa3 -> Da1,Da2,Da3,Da4 : Sa4 -> Da1,Da2,Da3,Da4

//**********************************************************************************************************

//test_sa2: The test is to send the stimulus from a single source port - PASS

//Example : Sa2 -> Da*

//**********************************************************************************************************

//test_da3: The test is to send the stimulus to a single destination port - PASS

//Example : Sa* -> Da3

//**********************************************************************************************************

//test_equal_sizes: The test is to send the stimulus packets of equal sizes - PASS

//**********************************************************************************************************

//test_full_size: The test is to send the stimulus packets of full size(2000 bytes) - PASS

//**********************************************************************************************************

//test_mixed_size The test is to send the stimulus packets of mixed-sizes and hit the 100% coverage - PASS

//**********************************************************************************************************

//erroneous testcase
//test_invalid_da: The test is to drive the invalid Da ports and see the behaviour of design - PASS
//This test is completed through factory override mechanism. enhanced the existing packet class to a new class(packet_invalid_da) which contains invalid da addresses. Look "packet_invalid_da.sv", "invalid_da_sequence.sv", "invalid_da_shutdown_seq.sv", and "test_invalid_da.sv"

//**********************************************************************************************************

//error injection 
//test_invalid_crc: The test is to inject the invalid crc in the packet and see the behaviour of design - PASS
//This test is completed using UVM callback mechanism, injected an error in the input packet without modifying the environment. Look "callbacks_crc.sv"(which has pre_send & post_send methods & hooks), "crc_shutdown_seq.sv"(for reading status register), and "crc_test_callback.sv"(for configuring the test) & crc_sequence

//**********************************************************************************************************


//erroneous testcase
//test_invalid_len : The test is to drive the invalid packet length and see the behaviour of design - PASS
//This test is completed through factory override mechanism. enhanced the existing packet class to a new class(packet_invalid_len) which contains invalid packet sizes. Look "packet_invalid_len.sv", "invalid_len_sequence.sv", "len_shutdown_seq.sv", and "test_invalid_len.sv"

//**********************************************************************************************************

//test_all_ports : The test is to send the stimulus from SA1 -> DA1, SA2 -> DA2, SA3 -> DA3, and SA4 -> DA4 parallely - PASS

//**********************************************************************************************************

