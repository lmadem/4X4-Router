//This new_packet6 serves testcase6, please see the testplan for more info

//new_packet6 class extends from base class packet
class new_packet6 extends packet;
  
  //constraint to override base class constraint and to generate specific scenario 
  constraint valid_payload{
    payload.size inside {[10:1990]};
    foreach(payload[i])
      payload[i] inside {[0:255]};
  }

endclass
