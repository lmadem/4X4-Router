//main sequence goal is to generate main stimulus to test the main functionality of the DUT
//full_size_sequence by extending from uvm_sequence and typed to packet
class full_size_sequence extends uvm_sequence #(packet);
  
  //Registering sequence full_size_sequence into factory
  `uvm_object_utils(full_size_sequence);
  
  //variable item_count , number of packets to generate
  int unsigned item_count;
  
  //custom constructor
  function new (string name = "full_size_sequence");
    super.new(name);
    //Call method to raise/drop objections automatically
    set_automatic_phase_objection(1);
  endfunction
  
  //extern methods 
  extern virtual task pre_start();
  extern virtual task body();
    
endclass
    
//pre_start() method to receive packet count from test
task full_size_sequence::pre_start();
  if(!uvm_config_db#(int)::get(get_sequencer(), "", "item_count", item_count))
    begin
      `uvm_warning("pkt_count", "item count is not set in test_sequence");
      item_count = 10;
    end
endtask
  
//body method to start the actual sequence operation
task full_size_sequence::body();
  bit [31:0] count;
  REQ ref_pkt;
  ref_pkt = packet::type_id::create("ref_pkt",,get_full_name());
  repeat(item_count) 
    begin
      //Construct object for req handle
      `uvm_create(req)
      //randomize the transaction
      assert(ref_pkt.randomize() with {sa inside {[2:4]};
                                       da inside {[2:4]};
                                       payload.size() == 1990;
                                      });
      req.copy(ref_pkt);
      req.kind = STIMULUS;
        
      //Start the transaction
      start_item(req);
      //Finish the transaction
      finish_item(req);
      count++;
      `uvm_info("SEQ",$sformatf("Master Sequence : Transaction %0d DONE ",count),UVM_MEDIUM);
      end
endtask

