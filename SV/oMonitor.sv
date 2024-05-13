//Output Monitor class
class oMonitor;
  static bit [15:0] id;//used for incrementing oMonitor id's and persistent throughout the simulation
  bit [15:0] obj_id;//oMonitor id
  //virtual interface, mailbox and packet class handles
  virtual router_if.tb_mon vif;
  mailbox_inst mbx;//will be connected to scoreboard
  packet pkt;
  
  bit [31:0] no_of_pkts_recvd;//to keep track of packets sent to scoreboard
  
  //custom constructor with mailbox and virtual interface handles as arguments
  function new(input mailbox_inst mbx_arg, input virtual router_if.tb_mon vif_arg);
    mbx = mbx_arg;
    vif = vif_arg;
    id++;
    obj_id=id;
    pkt = new;
  endfunction
  
  extern task run();
  extern function void report();

endclass

//run method to start the output monitor operation
task oMonitor::run();
  bit [7:0] outp_q[$];
  //$display("[oMonitor %4d] run started at time=%0t ",obj_id, $realtime); 
  forever 
    begin //Monitor runs forever
      //Start of Packet into DUT :Wait on outp_valid to become high
      @(posedge vif.mcb.da_valid[obj_id]);
      //$display("[oMonitor %4d] Started collecting packet %0d at time=%0t ",obj_id, no_of_pkts_recvd, $realtime); 
      while(1) 
        begin
          //End of packet into DUT: Collect untill outp_valid becomes 0
          if(vif.mcb.da_valid[obj_id] == 0) 
            begin
              pkt = new;
              //Unpack collected outp_q stream into pkt fields
              pkt.unpack(outp_q);
              pkt.outp_stream=outp_q;
              //Send collected to scoreboard
              mbx.put(pkt);
              no_of_pkts_recvd++;
              //$display("Check %t", $realtime);
              //$display(no_of_pkts_recvd);
              // Wait until scoreboard gets a copy of transactions and then Delete entries in the mailbox.
              /*
              begin
                packet temp;
                #0 while(mbx.num >= 1) void'(mbx.try_get(temp));
              end
              */
              $display("[oMonitor %4d] Sent packet %0d (sa%0d->da%0d) to scoreboard at time=%0t ",obj_id, no_of_pkts_recvd, pkt.sa, pkt.da, $realtime);
              //pkt.print();
	          outp_q.delete();
              break;
            end//end_of_if
          outp_q.push_back(vif.mcb.da[obj_id]);
          @(vif.mcb); 
        end//end_of_while
    end//end_of_forever
  //$display("[oMonitor %4d] run ended at time=%0t ",obj_id,$time);//monitor will never end 
endtask

//report method to print how many packets collected by oMonitor
function void oMonitor::report();
  $display("[oMon %4d] Report: total_packets_collected=%0d ",obj_id,no_of_pkts_recvd); 
endfunction




