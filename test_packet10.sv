//This new_packet10 serves testcase10, please see the testplan for more info

//new_packet10 class extends from base class packet
class new_packet10 extends packet;
  
  //constraint to override base class constraint and to generate specific scenario 
  constraint valid_payload {
    payload.size == 30;
  }

endclass

