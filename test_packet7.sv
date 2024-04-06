//This new_packet7 serves testcase7, please see the testplan for more info

//new_packet7 class extends from base class packet
class new_packet7 extends packet;
  
  //constraint to override base class constraint and to generate specific scenario 
   constraint valid_da {
    da inside {[5:8]};
  }
  
  constraint valid_payload {
    payload.size inside {[20:100]};
  }

endclass
