//This new_packet9 serves testcase9, please see the testplan for more info

//new_packet9 class extends from base class packet
class new_packet9 extends packet;
  
  //constraint to override base class constraint and to generate specific scenario 
  constraint valid_payload {
    //Constraint payload size should be Invalid(pkt.len should be less than 12 or greater than 2000
    payload.size == 1 || payload.size == 2000;
  }

endclass
