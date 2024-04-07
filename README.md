# 4X4 Router
Verification of 4X4 router in System Verilog. The main intension of this repository is to document the verification plan and test case implementation in System Verilog testbench environment.

<details>
  <summary> Defining the black box design of Router 4X4 </summary>

  #### Router 4X4 is a switch, which can transfer a series of packets from source ports to the destination ports 
  
  <li> Note :: This DUT is not synthesizable, it is only designed for verification practices. The design has control & status registers </li>

  <li> Input Ports : clk, reset, sa1, sa2, sa3, sa4, sa1_valid, sa2_valid, sa3_valid, sa4_valid </li>

  <li> Output Ports : da1, da2, da3, da4, da1_valid, da2_valid, da3_valid, da4_valid </li>

  #### Black Box Design

  ![image](https://github.com/lmadem/4X4-Router/assets/93139766/fe2efd33-3a5a-4bed-96d5-b6be13c28a26)

  #### Packet Format

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/7fff2584-70f0-4da7-ac12-d0b45958d596)

  <li> Minimum packet length is 12 bytes and max is 2000 bytes </li>
  <li> RTL(router) accepts 8-bits per clock </li>
  <li> inp_valid indicates start/end of packet at the source port </li>
  <li> outp_valid indicates start/end of packet at the destination port </li>  
  
  #### I/O Pins


  #### pins to access Control Registers

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/85085177-f3a3-4f23-b4f1-3c7958c807b9)

  #### Control Registers
  
  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/c2dda49e-ffbf-4f2b-9a99-243d69e2078d)


  #### Status Registers

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/9b170ef9-f910-4590-bd70-91014c153986)


  <li> This router 4X4 is designed in system verilog. Please check out the file "router.sv" </li>
  
</details>

<details>
  <summary> Verification Plan </summary>

  #### The verification plan for Router 4X4 

  <li> The idea is to build an robust verification environment in system verilog which can handle various testcases. The testcases has basic functionality checks, functional coverage hits, covering corner cases, erroneous cases, and error-injection checks</li>

  #### Test Plan


</details>

<details>
  <summary> Verification Results </summary>

   <li> Built a robust verification environment in System Verilog and implemented all the testcases as per the testplan. The SV testbench verification environment consists of header class, packet class, generator class, multiple drivers, Monitors, and scoreboard class, environment class, base_test class, test classes, program block, top module, interface and the design </li>

   <li> This environment will be able to drive one testcase per simulation </li>

   #### Test Plan Status
  

</details>
<details>
  <summary> EDA Results </summary>
  
   #### Base_Test EDA Result



   #### New_Test1 EDA Result


   #### New_Test2 EDA Result



   #### New_Test3 EDA Result

 

   #### New_Test4 EDA Result



   #### New_Test5 EDA Result



   #### New_Test6 EDA Result



   #### New_Test7 EDA Result



   #### New_Test8 EDA Result



   #### New_Test9 EDA Result



   #### New_Test10 EDA Result



</details>
</details>

<details>
  <summary> EDA Playground Link and Simluation Steps </summary>

  #### EDA Playground Link

  ```bash
https://www.edaplayground.com/x/Miur
  ```

  #### Verification Standards

  <li> Constrained random stimulus, robust generator, multiple drivers, multiple monitors, Out-of-order scoreboard, coverage component and environment </li>

  #### Simulation Steps
  
  <details>
    <summary> SV Environment </summary>

##### Step 1 : UnComment "top.sv", "interface.sv", and "program_test.sv"(lines 3,4,5) in testbench.sv file 

##### Step 2 : To run individual tests, please look into the above attached screenshots in EDA Results

  </details>
</details>

<details>
  <summary>Challenge</summary>

#### The error-injection and erroneous cases 
<li> The simulation environment is hanging and going into a forever loop. It is because the run() task of driver, imonitor and omonitor components run forever, the output monitor block will end up in a forever loop when the stimulus is error-injected or erroneous </li>
<li> Here, the design has status registers and it became easy to test error-injection and erroneous testcases </li>
<li> But in general, the mechanism to control the simulation environment in an organized way even for error-injection and erroneous cases are bit tricky</li>
<li> The solution would be using UVM, as it has objections and timeouts </li>
<li> Reference link for the above problem : https://verificationacademy.com/forums/t/how-to-stop-a-simulation-in-a-controlled-way/35064 </li>


</details>


