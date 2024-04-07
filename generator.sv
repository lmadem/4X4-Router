//Generator Class
class generator;
  bit [31:0] pkt_count;
  bit [31:0] pkt_id[4:1];
  packet pkt;
  
  //mailbox and packet class handles
  mailbox_inst mbx[4:1];
  packet ref_pkt[4:1];
  
  //custom constructor with mailbox and packet class handles as arguments
  function new(input mailbox_inst mbx_arg[4:1],input bit [31:0] count_arg);
    pkt_count=count_arg;
    for(bit [2:0] i=1; i<=4; i++)
      begin
        mbx[i] = mbx_arg[i];
        ref_pkt[i] = new;
      end
  endfunction
  
  
  virtual task run ();    
    //Generate First packet as Reset packet
    pkt = new;
    //Reset packet, this will be used in driver to identify
    pkt.kind = RESET;
    pkt.reset_cycles = 3;
    
    //Place the Reset packet in mailbox
    for(bit [2:0] i=1; i<=4; i++)
      begin
        mbx[i].put(pkt);
      end
    //$display("[Generator] Sent %0s packet to driver at time=%0t",pkt.kind.name(),$realtime); 
 
    
    //Generate Second packet(Control Register stimulus) as CSR WRITE packet
    pkt = new;
    //CSR_WRITE packet, this will be used in driver to identify
    pkt.kind = CSR_WRITE;
    pkt.addr = 'h20;  //csr_sa_enable;//addr='h20;
    pkt.data = 31'hf;

    //Place the CSR WRITE packet in mailbox
    for(bit [2:0] i=1; i<=4; i++)
      begin
        mbx[i].put(pkt);
      end
    //$display("[Generator] Sent %0s packet to driver at time=%0t",pkt.kind.name(),$realtime); 

  
    //Generate Third packet (Control Register stimulus) as CSR WRITE packet
    pkt = new;
    //CSR_WRITE packet, this will be used in driver to identify
    pkt.kind = CSR_WRITE;
    pkt.addr = 'h24; //csr_da_enable;//addr='h24;
    pkt.data = 31'hf;
    //Place the CSR WRITE packet in mailbox
    for(bit [2:0] i=1; i<=4; i++)
      begin
        mbx[i].put(pkt);
      end
    //$display("[Generator] Sent %0s packet to driver at time=%0t",pkt.kind.name(),$realtime); 
    
  
    //Generate Stimulus packets for all sa ports
    fork
      generate_stimulus(1);
      generate_stimulus(2);
      generate_stimulus(3);
      generate_stimulus(4);
    join


    //Generate Status Register READ stimulus as CSR READ packet
    pkt = new;
    //CSR_READ packet, this will be used in driver to identify
    pkt.kind = CSR_READ;
    pkt.addr = 'h90;  //csr_total_inp_pkt_count;//addr='h90
    //Place the CSR READ packet in mailbox
    mbx[4].put(pkt);
    //$display("[Generator] Sent %0s packet to driver at time=%0t",pkt.kind.name(),$time);

    
    //Generate Status Register READ stimulus as CSR READ packet
    pkt = new;
    //CSR_READ packet, this will be used in driver to identify
    pkt.kind = CSR_READ;
    pkt.addr = 'h92;  //csr_total_outp_pkt_count;//addr='h92
    //Place the CSR READ packet in mailbox
    mbx[4].put(pkt);
    //$display("[Generator] Sent %0s packet to driver at time=%0t",pkt.kind.name(),$time);
  endtask
  
  
  virtual task generate_stimulus(bit [3:0] sa);
    packet pkt;
    repeat(pkt_count) begin
      pkt_id[sa]++;
      assert(ref_pkt[sa].randomize());
      pkt = new;
      //STIMULUS packet, this will be used in driver to identify
      pkt.kind = STIMULUS;
      pkt.copy(ref_pkt[sa]);
      //Place normal stimulus packet in mailbox
      mbx[sa].put(pkt);
      $display("[Generator] SA%0d Packet %0d (size=%0d) Sent at time=%0t",sa,pkt_id[sa],pkt.len,$time);
      //ref_pkt[sa].print();
    end
  endtask
  
  //report function to display number of packets generated by generator
  virtual function void report();
    $display("[Generated] Report: total_packets_generated = %0d", pkt_id.sum());
  endfunction

endclass