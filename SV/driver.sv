//Driver Class
class driver;
  //Define virtual interface, mailbox and packet class handles
  virtual router_if.tb_mod_port vif;
  mailbox_inst mbx;
  packet pkt;
  
  static bit [15:0] id; //used for incrementing driver id's and persistent throughout the simulation
  bit [15:0] obj_id; //driver id
  
  bit [31:0] no_of_pkts_recvd; //No of packets received from generator
  bit [31:0] pkt_count; //No of packtes driven from driver
  
  //custom constructor with mailbox and interface handles as arguments
  function new(input mailbox_inst mbx_arg, input virtual router_if.tb_mod_port vif_arg);
    mbx = mbx_arg;
    vif = vif_arg;
    id++;
    obj_id = id;
  endfunction
  
  extern task run();
  extern task drive(packet pkt);
  extern task drive_reset(packet pkt);
  extern task drive_stimulus(packet pkt);
  extern task configure_dut_csr(packet pkt);
  extern task read_dut_csr(packet pkt);
  extern function void report();
endclass 
    
//run method to start the driver operation
task driver::run();
  //$display("[Driver %2d] run started at time=%0t", obj_id, $realtime);
  //driver runs forever
  while(1) 
    begin
      //wait for packet from generator and get once it is available in mailbox
      mbx.get(pkt);
      if(pkt.kind == STIMULUS)
        begin
          //$display("Check");
          //$display(no_of_pkts_recvd);
          no_of_pkts_recvd++; 
        end
      //$display("[Driver %2d] received  %0s packet %1d from generator at time=%0t",obj_id, pkt.kind.name(), no_of_pkts_recvd, $realtime);
      //Process the Received transaction
      drive(pkt);
      //$display("[Driver %2d] sent  %0s packet %1d from generator at time=%0t",obj_id, pkt.kind.name(), no_of_pkts_recvd, $realtime);
    end //end of while
  //$display("[Driver %2d] run ended at time=%0t", obj_id, $realtime);
endtask
    

//drive method with packet as argument
task driver::drive(packet pkt);
  //check the transaction type and call the appropriate method
  case(pkt.kind)
    RESET     :  drive_reset(pkt);
    STIMULUS  :  drive_stimulus(pkt);
    CSR_WRITE :  configure_dut_csr(pkt);
    CSR_READ  :  read_dut_csr(pkt);
    default   :  $display("[Driver %2d] Unknown packet received", obj_id);
  endcase
endtask
   

//drive_reset method with packet as argument
task driver::drive_reset(packet pkt);
  //$display("[Driver %2d] Driving Reset transaction into DUT at time=%0t",obj_id, $realtime); 
  vif.reset <= 1'b1;
  repeat(pkt.reset_cycles) @(vif.cb);
  vif.reset <= 1'b0;
  //$display("[Driver %2d] Driving Reset transaction completed at time=%0t",obj_id, $realtime); 
endtask
    


//drive_stimulus method with packet as argument
task driver::drive_stimulus(packet pkt);
  @(vif.cb);
  //$display("[Driver %2d] Driving of packet %0d (size=%0d) sa%0d->da%0d started at time=%0t",obj_id, no_of_pkts_recvd, pkt.len, pkt.sa, pkt.da, $realtime);
  vif.cb.sa_valid[obj_id] <= 1;
  foreach(pkt.inp_stream[i])  
    begin
      vif.cb.sa[obj_id] <= pkt.inp_stream[i];
      @(vif.cb);
    end
  //$display("[Driver %2d] Driving of packet %0d (size=%0d) sa%0d->da%0d ended at time=%0t \n",obj_id, no_of_pkts_recvd, pkt.len, pkt.inp_stream[0], pkt.inp_stream[1],$realtime);
  vif.cb.sa_valid[obj_id] <= 0;
  vif.cb.sa[obj_id] <= 'z;
  repeat(5) @(vif.cb);
  pkt_count++;
  //$display("[Driver] Packet Count is %0d", pkt_count);
endtask
    

//DUT configuration  method with packet as argument
task driver::configure_dut_csr(packet pkt);
  //$display("[Driver %2d] Configuring DUT Control registers Started at time=%0t",obj_id, $realtime);
  @(vif.cb);
  vif.cb.wr <= 1;
  vif.cb.addr  <= pkt.addr; 
  vif.cb.wdata <= pkt.data;
  @(vif.cb);
  vif.cb.wr <= 0;
  //$display("[Driver %2d] Configuring DUT Control registers Ended at time=%0t",obj_id, $realtime);
endtask


//DUT Status Register Read method with packet as argument
task driver::read_dut_csr(packet pkt);
  //$display("[Driver %2d] Reading DUT Status registers Started at time=%0t",obj_id, $realtime);
  @(vif.cb);
  vif.cb.rd <= 1;
  vif.cb.addr <= pkt.addr;
  @(vif.cb.rdata);
  //$display("[Driver %2d] ****csr_pkt_dropped_count=%0d ****",obj_id,vif.cb.rdata);
  vif.cb.rd <= 0;
  //$display("[Driver %2d] Reading DUT Status registers Ended at time=%0t",obj_id, $realtime);
endtask

//report function to display the number of sent packets to scoreboard inbox    
function void driver::report();
  $display("[Driver %2d] Report: total_packets_driven = %0d", obj_id, pkt_count); 
endfunction



    
