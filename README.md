# 4X4 Router
Verification of 4X4 router in System Verilog.The main intension of this repository is to document the verification plan and test case implementation in System Verilog testbench environment.

<details>
  <summary> Defining the black box design of Router 4X4 </summary>

  #### Router 4X4 is a switch, which can transfer a series of packets from source ports to the destination ports 
  
  <li> Note :: This DUT is not synthesizable, it is only designed for verification practices. The design has control & status registers </li>

  <li> Input Ports : clk, reset, sa1, sa2, sa3, sa4, sa1_valid, sa2_valid, sa3_valid, sa4_valid </li>

  <li> Output Ports : da1, da2, da3, da4, da1_valid, da2_valid, da3_valid, da4_valid </li>

  #### Black Box Design

  ![image](https://github.com/lmadem/4X4-Router/assets/93139766/b17d4f5a-5f71-459c-b057-f427bcd7fe37)


  #### Packet Format

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/7fff2584-70f0-4da7-ac12-d0b45958d596)

  <li> Minimum packet length is 12 bytes and max is 2000 bytes </li>
  <li> RTL(router) accepts 8-bits per clock </li>
  <li> inp_valid indicates start/end of packet at the source port </li>
  <li> outp_valid indicates start/end of packet at the destination port </li>  
  
  #### I/O Pins

  ![image](https://github.com/lmadem/4X4-Router/assets/93139766/9e6a135e-fd50-4c93-9222-af9b49fcc1f8)


  #### pins to access Control Registers

  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/85085177-f3a3-4f23-b4f1-3c7958c807b9)

  #### Control Registers
  
  ![image](https://github.com/lmadem/1X1-Router-/assets/93139766/c2dda49e-ffbf-4f2b-9a99-243d69e2078d)


  #### Status Registers

  ![image](https://github.com/lmadem/4X4-Router/assets/93139766/0693cf5e-54d7-40f9-a6c7-955a65264756)

  <li> Apart from the above mentioned status registers, the DUT has other status registers. Please look into the "router.sv" file for further information </li>
  <li> This router 4X4 is designed in system verilog. Please check out the file "router.sv" </li>
  
</details>

<details>
  <summary> Verification Plan </summary>

  #### The verification plan for Router 4X4 

  <li> The idea is to build a robust verification environment in system verilog which can handle various testcases. The testcases has basic functionality checks, functional coverage hits, covering corner cases, erroneous cases, and error-injection checks</li>

  #### Test Plan

  ![image](https://github.com/lmadem/4X4-Router/assets/93139766/9c468ab8-d5bf-42e0-affd-741b93cbb33a)


</details>

<details>
  <summary> Verification Results </summary>

   <li> Built a robust verification environment in System Verilog and implemented all the testcases as per the testplan. The SV testbench verification environment consists of header class, packet class, generator class, multiple drivers, multiple monitors, and scoreboard class, environment class, base_test class, test classes, program block, top module, interface and the design </li>

   <li> This environment will be able to drive one testcase per simulation </li>

   #### Test Plan Status

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/f6f0d3ad-d63c-4dca-bdd0-048a99175c98)
   
</details>
<details>
  <summary> EDA Results </summary>
  
   #### Base_Test EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/3679733f-7ce4-456f-990a-9df4a0c7412d)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/79482adf-5ab9-4caf-ab01-50e0a2bbf82f)

   #### New_Test1 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/d060af56-b983-4007-a972-da76aa25718d)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/b597386f-5a43-4749-8cf5-330a3b10b949)

   #### New_Test2 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/c81d0ee9-af06-439f-85c1-a0814ffb2868)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/3d271b9e-f343-4553-9926-ae9e9649bd76)

   #### New_Test3 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/a51403d4-4c17-4874-b6ba-64b7f13856a4)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/3e8031d1-7556-41cf-9654-ed20ccee8fac)

   #### New_Test4 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/8b46665e-b655-48fe-80a2-b6fa1e6b9b4d)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/e2198683-0d59-46b2-bc57-c6ebf3fe719b)

   #### New_Test5 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/4c7165ca-cd9f-494b-8be1-0b3a76e21e05)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/b54b8f14-fae4-4f62-93aa-b76a6fff584c)

   #### New_Test6 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/cf6238d5-cc91-444f-b177-18a6af55c8ec)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/04679c48-c3e7-4f93-b77c-a240a5f4efeb)

   #### New_Test7 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/992300cc-549f-473e-b75c-44b971e75865)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/e7a52452-285f-4416-a7f8-b96c96d4f455)

   #### New_Test8 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/522379e8-7ad0-489c-a800-1fde39b16d7d)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/c58813dd-3405-41a0-bbc7-889a49707ed4)

   #### New_Test9 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/2181826a-fb34-4743-8546-c570b1c1011d)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/974b622c-4e80-4645-859a-e441ba3b10ea)

   #### New_Test10 EDA Result

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/32739840-a27e-4039-81fc-8b985550227b)

   ![image](https://github.com/lmadem/4X4-Router/assets/93139766/c424c1e9-f576-48f9-ab66-193146bd3ddb)

</details>
</details>

<details>
  <summary> EDA Playground Link and Simluation Steps </summary>

  #### EDA Playground Link

  ```bash
https://www.edaplayground.com/x/Miur
  ```

  #### Verification Standards

  <li> Constrained random stimulus, robust generator, multiple drivers, multiple monitors, out-of-order scoreboard, coverage component and environment </li>

  #### Simulation Steps
  
  <details>
    <summary> SV Environment </summary>

##### Step 1 : UnComment "top.sv", "interface.sv", and "program_test.sv"(lines 5,6,7) in testbench.sv file 

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


