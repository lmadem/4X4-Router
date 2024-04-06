//This new_packet2 serves testcase2, please see the testplan for more info

//new_packet2 class extends from base class packet
class new_packet2 extends packet;
  
  //constraints to override base class constraint and to generate specific scenario
  constraint valid_sa{
    //sa should be fixed to a single source port
    sa == 2;
  }

  constraint valid_payload{
    payload.size inside {[10:15]};
    foreach(payload[i])
      payload[i] inside {[0:255]};
    unique {payload};
  }

endclass
