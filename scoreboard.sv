//Scoreboard Class : Implemented out of order scoreboard
class scoreboard;
  //mailbox and packet class handles
  mailbox_inst mbx_in[4:1]; //will be connected to Input Monitor
  mailbox_inst mbx_out[4:1]; //will be connected to Output Monitor
  
  packet pkt_inbox[4:1]; //Packet handle to collect from Input Monitor
  packet pkt_outbox[4:1]; //Packet handle to collect from Output Monitor
  
  packet qu_inp[$]; //Queue for input packets
  packet qu_out[$]; //Queue for output packets
  
  bit [31:0] total_input_pkts[4:1]; //To keep a count of collected packets from input monitor
  bit [31:0] total_output_pkts[4:1]; //To keep a count of collected packets from output monitor
  
  bit [31:0] m_matches; //To keep a track of scoreboard matches
  bit [31:0] m_mismatches; //To keep a track of scoreboard mismatches
  
  //custom constructor for mailbox handles as arguments
  function new(input mailbox_inst mbx_in_arg[4:1], mailbox_inst mbx_out_arg[4:1]);
    mbx_in = mbx_in_arg;
    mbx_out = mbx_out_arg;
  endfunction
  
  extern task run();
  extern function void search_and_compare();
  extern function int find_input_packet(packet pkt1);
  extern task get_inp_pkts(bit [2:0] sa);
  extern task get_out_pkts(bit [2:0] da);
  extern function void report();
  
endclass
    
//run method to start scoreboard operations
task scoreboard::run();
  $display("[Scoreboard] run started at time=%t", $realtime);
  fork
    get_inp_pkts(1);
    get_inp_pkts(2);
    get_inp_pkts(3);
    get_inp_pkts(4);
    
    get_out_pkts(1);
    get_out_pkts(2);
    get_out_pkts(3);
    get_out_pkts(4);
  join
endtask
    
//get_inp_pkts method to collect input monitor packets and push in to a queue:qu_inp
task scoreboard::get_inp_pkts(bit [2:0] sa);
  packet inp_pkt;
  while(1)
    begin
      @(mbx_in[sa].num);
      mbx_in[sa].get(pkt_inbox[sa]);
      inp_pkt = new;
      inp_pkt.copy(pkt_inbox[sa]);
      qu_inp.push_back(inp_pkt);
      //inp_pkt.print();
      total_input_pkts[sa]++;
      //$display("[Scoreboard] INP packet %0d received on SA %0d tot_pkts_collected = %0d at time=%t ",total_input_pkts[sa], sa, total_input_pkts.sum(), $realtime); 
    end
endtask
    

//get_outp_pkts method to collect output monitor packets and push in to a queue:qu_out
task scoreboard::get_out_pkts(bit [2:0] da);
  packet out_pkt;
  while(1)
    begin
      @(mbx_out[da].num);
      mbx_out[da].get(pkt_outbox[da]);
      out_pkt = new;
      out_pkt.copy(pkt_outbox[da]);
      qu_out.push_back(out_pkt);
      total_output_pkts[da]++;
      //$display("[Scoreboard] OUT packet %0d received on DA %0d tot_pkts_collected = %0d at time=%t ",total_output_pkts[da], da, total_output_pkts.sum(), $realtime); 
      //out_pkt.print();
    end
endtask
    
//Search and compare function for the inputs and output packets comparison, this function will be triggered in environment class only after collecting all packets from output monitor
function void scoreboard::search_and_compare();
  int get_inp_index;
  packet pkt1, pkt2;
  if(total_input_pkts.sum() == total_output_pkts.sum())
    begin
      $display("[Scoreboard] Comparison started at time=%t", $realtime);
      for(int i=0; i<qu_out.size(); i++)
        begin
          //pkt1 = new;
          pkt1 = qu_out[i];
          get_inp_index = find_input_packet(pkt1);
          //$display(get_inp_index);
          if(get_inp_index != -1)
            begin
              //pkt2 = new;
              pkt2 = qu_inp[get_inp_index];
              //$display("Check");
              if(pkt2.compare(pkt1))
                begin
                  m_matches++;
                  $display("[Scoreboard] Packet Matched at time=%t", $realtime);
                end
              else
                begin
                  m_mismatches++; 
                  $display("[Scoreboard] Error ***** No Matching packet found ***** at time=%0t", $realtime);
                  //$display("[Scoreboard] Expected::%0p ",pkt1.inp_stream);
                  //$display("[Scoreboard] Received::%0p ",pkt2.outp_stream);
                end
            end //end of if   
          else
            begin
              $display("[Scoreboard] Packet not found");
            end
        end //end of for
    end //end of if
  else
    begin
      $display("[Scoreboard] Comparison block did not entered");
    end
endfunction
    
//find_input_packet function finds the index of input packet with reference to output packet. The output pkt is passed as an argument and it is used in the search mechanism to capture input packet index
function int scoreboard::find_input_packet(packet pkt1);
  packet pkt3;
  for(int i=0; i<qu_inp.size(); i++)
    begin
      //pkt3 = new;
      pkt3 = qu_inp[i];
      if(pkt1.sa == pkt3.sa && 
         pkt1.da == pkt3.da && 
         pkt1.crc == pkt3.crc &&
         pkt1.payload == pkt3.payload)
        begin
          //$display("Output :: Sa = %d Da =%d, CRC=%h :: Input : Sa = %d, Da =%d, CRC = %h", pkt1.sa,pkt1.da,pkt1.crc,pkt3.sa,pkt3.da,pkt3.crc);
          return i;
        end
    end
  return -1;
endfunction
    
//report function for scoreboard matches and mismatches
function void scoreboard::report();
  $display("[Scoreboard] Report: total_packets_collected = %0d",total_output_pkts.sum()); 
  $display("[Scoreboard] Report: Matches=%0d Mis_Matches=%0d",m_matches, m_mismatches); 
endfunction


    
    
    



