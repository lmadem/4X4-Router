//This generator_ext serves testcase10

//generator_ext class extends from generator class
class generator_ext extends generator;
  
  function new(input mailbox_inst mbx_arg[4:1],input bit [31:0] count_arg);
    super.new(mbx_arg[4:1], count_arg);
  endfunction
  
  virtual task run();
    super.run();
  endtask
  
  virtual task generate_stimulus(bit [3:0] sa);
    packet pkt;
    repeat(pkt_count) begin
      pkt_id[sa]++;
      assert(ref_pkt[sa].randomize() with {sa == local::sa && da == local::sa;});
      pkt = new;
      //STIMULUS packet, this will be used in driver to identify
      pkt.kind = STIMULUS;
      pkt.copy(ref_pkt[sa]);
      //Place normal stimulus packet in mailbox
      mbx[sa].put(pkt);
      //$display("[Generator] SA%0d Packet %0d (size=%0d) Sent at time=%0t",sa,pkt_id[sa],pkt.len,$time);
      ref_pkt[sa].print();
    end
  endtask
  
  virtual function void report();
    super.report();
  endfunction
  
endclass
