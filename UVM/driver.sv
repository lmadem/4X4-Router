//Driver goal is to receive transactions from sequencer through TLM ports nd drive them into DUT through virtual interface
//driver by extending from uvm_driver and typed to packet.
class driver extends uvm_driver #(packet);
  //Register driver into factory
  `uvm_component_utils(driver);
  
  //Register facade callback using uvm_register_cb macro
  `uvm_register_cb(driver, driver_callback_facade_crc);
  
  //variable no_of_pkts_recvd to keep track of packets received from sequencer
  bit [31:0] no_of_pkts_recvd;
  bit [31:0] csr_rdata; // to read dut csr register
  static bit [15:0] id; //used for incrementing driver id's and persistent throughout the simulation
  bit [15:0] obj_id; //driver id
  
  //virtual interface
  virtual router_if.tb_mod_port vif;
  
  //custom constructor
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
    id++;
    obj_id = id;
  endfunction
  
  //extern methods
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual task drive(ref packet pkt);
  extern virtual task drive_stimulus(input packet pkt);
  extern virtual task drive_reset(input packet pkt);  
  extern virtual task configure_dut_csr(ref packet pkt);
  extern virtual task read_dut_csr(ref packet pkt);

endclass
    
    
//run_phase to start the driver operations
task driver::run_phase(uvm_phase phase);
  `uvm_info($sformatf("Drvr %2d", obj_id), "run started", UVM_MEDIUM);
  forever //driver runs forever
    begin
      //Wait for packet from sequencer and pullout once packet available in TLM port
      seq_item_port.get_next_item(req);
      //Keep track of stimulus transaction count
      
      if(req.kind == STIMULUS)
        no_of_pkts_recvd++;
      `uvm_info("get_pkt", $sformatf("Driver %0d Received %0s Transaction from TLM port:Packet %0d", obj_id, req.kind.name(), no_of_pkts_recvd), UVM_MEDIUM); 
      
      //Embedding the callback method pre_send using uvm_do_callbacks macro
      `uvm_do_callbacks(driver, driver_callback_facade_crc, pre_send(this));
      
      //Process the Received transaction
      drive(req);
      
      //Embedding the callback method post_send using uvm_do_callbacks macro
      `uvm_do_callbacks(driver, driver_callback_facade_crc, post_send(this));
      
      //Indicate transaction complete status back to sequencer
      seq_item_port.item_done();
      `uvm_info("get_pkt", $sformatf("Driver %0d Transaction %0d Done", obj_id, no_of_pkts_recvd), UVM_MEDIUM);
    end
endtask

//connect_phase to connect virtual interface to physical interface
function void driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  //uvm_config_db::get to retrieve physical interface
  void'(uvm_config_db#(virtual router_if.tb_mod_port)::get(get_parent(), "", "drvr_if", vif));
  
  //Check if vif connected to physical interface or not
  if(vif == null)
    begin
      `uvm_fatal("VIF_ERR", $sformatf("Virtual Interface in Driver %0d is NULL", obj_id));
    end
endfunction

//drive method with packet as argument and execute the transaction
task driver::drive(ref packet pkt);
  case(pkt.kind)
    RESET : drive_reset(pkt);
    STIMULUS : drive_stimulus(pkt);
    CSR_WRITE : configure_dut_csr(pkt);
    CSR_READ : read_dut_csr(pkt);
    default : begin
      `uvm_warning("Unknown_PKT", $sformatf("[Drvr %2d] Unknown Packet received", obj_id));
    end
  endcase
endtask


//drive_reset method to apply reset to DUT
task driver::drive_reset(input packet pkt);
  `uvm_info("RESET_PKT", $sformatf("[drvr %2d] Applying Reset to DUT",obj_id), UVM_MEDIUM);
  vif.reset <= 1'b1;
  repeat(pkt.reset_cycles) @(vif.cb);
  vif.reset <= 1'b0;
  `uvm_info("RESET_PKT", $sformatf("[drvr %2d] Applying Reset ended",obj_id), UVM_MEDIUM);
endtask


//configure_dut_csr method to configre control registers in the DUT
task driver::configure_dut_csr(ref packet pkt);
  `uvm_info("CSR_WRITE", $sformatf("[drvr %2d] CSR Write Operation Started",obj_id), UVM_MEDIUM);
  @(vif.cb);
  vif.cb.wr <= 1;
  vif.cb.addr <= pkt.addr;
  vif.cb.wdata <= pkt.data;
  @(vif.cb);
  vif.cb.wr <= 0;
  `uvm_info("CSR_WRITE", $sformatf("[drvr %2d] CSR Write Operation Ended",obj_id), UVM_MEDIUM);
endtask


//read_dut_csr method to read status registers in the DUT
task driver::read_dut_csr(ref packet pkt);
  `uvm_info("CSR_READ", $sformatf("[drvr %2d] CSR Read Operation Started",obj_id), UVM_MEDIUM);
  @(vif.cb);
  vif.cb.rd <= 1;
  vif.cb.addr <= pkt.addr;
  repeat(2) @(vif.cb);
  req.data = vif.cb.rdata;
  vif.cb.rd <= 0;
  `uvm_info("CSR_READ", $sformatf("[drvr %2d] CSR Read Operation Ended",obj_id), UVM_MEDIUM);
endtask


//drive_stimulus method to drive stimulus into DUT
task driver::drive_stimulus(input packet pkt);
  @(vif.cb);
  `uvm_info($sformatf("[Drvr %2d]",obj_id), $sformatf("Driving of packet %0d (size = %0d) sa%0d->da%0d started", no_of_pkts_recvd, pkt.len, pkt.sa, pkt.da), UVM_MEDIUM);
  vif.cb.sa_valid[obj_id] <= 1;
  foreach(pkt.inp_pkt[i])
    begin
      vif.cb.sa[obj_id] <= pkt.inp_pkt[i];
      @(vif.cb);
    end
  `uvm_info($sformatf("[Drvr %2d]",obj_id), $sformatf("Driving of packet %0d (size = %0d) sa%0d->da%0d ended", no_of_pkts_recvd, pkt.len, pkt.sa, pkt.da), UVM_MEDIUM);
  vif.cb.sa_valid[obj_id] <= 0;
  vif.cb.sa[obj_id] <= 'z;
  repeat(5) @(vif.cb);
  `uvm_info($sformatf("[Drvr %2d]",obj_id), "Drive Operation Ended....", UVM_FULL);
endtask

