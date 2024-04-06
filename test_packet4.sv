//This new_packet4 serves testcase4, please see the testplan for more info

//new_packet4 class extends from base class packet
class new_packet4 extends packet;
  
  //constraint to override base class constraint and to generate specific scenario 
  constraint valid_payload{
    //payload size is fixed
    payload.size == 200;
    foreach(payload[i])
      payload[i] inside {[0:255]};
    unique {payload};
  }

endclass
