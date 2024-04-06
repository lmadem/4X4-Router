//This new_packet3 serves testcase3, please see the testplan for more info

//new_packet3 class extends from base class packet
class new_packet3 extends packet;
  
  //constraints to override base class constraint and to generate specific scenario
  constraint valid_da{
    //da should be fixed to a single destination port
    da == 3;
  }
  
  constraint valid_payload{
    payload.size inside {[15:20]};
    foreach(payload[i])
      payload[i] inside {[0:255]};
    unique {payload};
  }

endclass
