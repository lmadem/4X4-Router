//This new_packet5 serves testcase5, please see the testplan for more info

//new_packet5 class extends from base class packet
class new_packet5 extends packet;
  
  //constraint to override base class constraint and to generate specific scenario 
  constraint valid_payload{
    //full payload size
    payload.size == 1990;
    //payload.size inside {[10:1990]};
    foreach(payload[i])
      payload[i] inside {[0:255]};
  }

endclass
