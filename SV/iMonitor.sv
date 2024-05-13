//Input Monitor Class
class iMonitor;
  static bit [15:0] id;//used for incrementing iMonitor id's and persistent throughout the simulation
  bit [15:0] obj_id; //iMonitor id
  
  //virtual interface, packet class and mailbox handles
  
  virtual router_if.tb_mon vif;
  packet pkt;
  mailbox_inst mbx; //will be connected to scoreboard
  
  bit [31:0] no_of_pkts_recvd; //to keep track of packets sent to scoreboard
  
  //custom constructor with mailbox and virtual interface handles as arguments
  function new (input mailbox_inst mbx_arg, input virtual router_if.tb_mon vif_arg );
    mbx = mbx_arg;
    vif = vif_arg;
    id++;
    obj_id=id;
  endfunction
  
  extern task run();
  extern function void report();
  
endclass
    
//run method to capture packets driven into DUT    
task iMonitor::run();
  bit [7:0] inp_q[$];
  //$display("[iMonitor %4d] run started at time=%0t ",obj_id, $realtime); 
  forever
    begin //Monitor runs forever
      //Start of Packet into DUT :Wait on inp_valid to become high
      @(posedge vif.mcb.sa_valid[obj_id]);
      //$display("[iMonitor %4d] Started collecting packet %0d at time=%0t ",obj_id, no_of_pkts_recvd, $realtime); 
      // Capture complete packet driven into DUT
      while(1) 
        begin
          //End of packet into DUT: Collect until inp_valid becomes 0
          if(vif.mcb.sa_valid[obj_id] == 0) 
            begin
              pkt=new;
              //Unpack collected inp_q stream into pkt fields
              pkt.unpack(inp_q);
              pkt.inp_stream=inp_q;
              //Send to scoreboard
              mbx.put(pkt);
              no_of_pkts_recvd++;
              
              // Wait until scoreboard and coverage components gets a copy of transactions and then Delete entries in the mailbox.
              
              begin
                packet temp;
                #0 while(mbx.num >= 1) void'(mbx.try_get(temp));
              end

              $display("[iMonitor %4d] Sent packet %0d (sa%0d->da%0d) to scoreboard at time=%0t ",obj_id, no_of_pkts_recvd, pkt.sa, pkt.da, $realtime);
              //pkt.print();
              inp_q.delete();
              break;
            end//end_of_if
          inp_q.push_back(vif.mcb.sa[obj_id]);
          @(vif.mcb); 
        end//end_of_while
    end//end_of_forever

  //$display("[iMonitor %4d] run ended at time=%0t ",obj_id, $realtime);
endtask
    
//report function to display the number of sent packets to scoreboard inbox    
function void iMonitor::report();
  $display("[iMonitor %4d] Report: total_packets_collected = %0d ",obj_id, no_of_pkts_recvd); 
endfunction
