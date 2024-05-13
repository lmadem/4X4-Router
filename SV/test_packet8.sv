//This new_packet8 serves testcase8, please see the testplan for more info

//new_packet8 class extends from base class packet
class new_packet8 extends packet;
  
  //constraint to override base class constraint and to generate specific scenario 
  constraint valid_payload {
    payload.size inside {[10:50]};
  }
  
  virtual function void post_randomize_extension();
    crc = crc - 1;
  endfunction

endclass
