//main sequence goal is to generate main stimulus to test the main functionality of the DUT
//crc_sequence by extending from uvm_sequence and typed to packet
class crc_sequence extends uvm_sequence #(packet);
  
  //Registering sequence crc_sequence into factory
  `uvm_object_utils(crc_sequence);
  
  //variable item_count , number of packets to generate
  int unsigned item_count;
  
  //custom constructor
  function new (string name = "crc_sequence");
    super.new(name);
    //Call method to raise/drop objections automatically
    set_automatic_phase_objection(1);
  endfunction
  
  //pre_start() method to receive packet count from test
  task pre_start();
    if(!uvm_config_db#(int)::get(get_sequencer(), "", "item_count", item_count))
      begin
        `uvm_warning("pkt_count", "item count is not set in crc_sequence");
        item_count = 10;
      end
  endtask
  
  //body method to start the actual sequence operation
  task body();
    bit [31:0] count;
    repeat(item_count) 
      begin
        //Construct object for req handle
        `uvm_create(req)
        
        //Start the transaction
        start_item(req);
        
        //randomize the transaction
        void'(req.randomize() with {sa inside {[1:4]}; 
                                    da inside {[1:4]};
                                    payload.size() inside {[100:150]};
                                   });
        req.kind = STIMULUS;
        
        //Finish the transaction
        finish_item(req);
        
        count++;
        `uvm_info("SEQ",$sformatf("Master Sequence : Transaction %0d DONE ",count),UVM_MEDIUM);
      end
  endtask

endclass