//shutdown sequence goal is to read the status registers in the DUT
//shutdown_sequence by extending from uvm_sequence and typed to packet
class shutdown_sequence extends uvm_sequence #(packet); 
  //Register sequence shutdown_sequence into factory
  `uvm_object_utils(shutdown_sequence);
  
  //custom constructor
  function new (string name = "shutdown_sequence");
	super.new(name);
    //Call method to raise/drop objections automatically
    set_automatic_phase_objection(1);
  endfunction
  
  //body method to start the actual sequence operation
  task body();
    //Construct object for req handle
    `uvm_create(req);
 
    //Start the transaction
    start_item(req);
    
    //Fill the fields of transaction to generate CSR Read stimulus
    req.kind = CSR_READ;
    req.addr = 'h90; //csr_total_inp_pkt_count
    
    //Finish the transaction
    finish_item(req);
    `uvm_info("SHTDWN_SEQ", "ShutDown Sequence : DONE", UVM_MEDIUM);
    
    //Construct object for req handle
    `uvm_create(req);
    
    //Start the transaction
    start_item(req);
    
    //Fill the fields of transaction to generate CSR Read stimulus
    req.kind = CSR_READ;
    req.addr = 'h92; //csr_total_outp_pkt_count
    
    //Finish the transaction
    finish_item(req);
    `uvm_info("SHTDWN_SEQ", "ShutDown Sequence : DONE", UVM_MEDIUM);
  
  endtask
  
endclass