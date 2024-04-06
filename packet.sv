//control knob to identify transactions
typedef enum {IDLE, RESET, STIMULUS, CSR_WRITE, CSR_READ} pkt_type_t;

//Packet Class
class packet;
  rand bit [7:0] sa;
  rand bit [7:0] da;
  bit [31:0] crc;
  bit [31:0] len;
  rand bit [7:0] payload[];
  
  bit [7:0] inp_stream[$];
  bit [7:0] outp_stream[$];
  
  pkt_type_t kind;
  //reset_cycles variable
  bit [7:0] reset_cycles;
  
  //CSR signals
  bit [7:0] addr;
  bit [31:0] data;
  
  //constraints on sa to be in the range of 1 to 4
  constraint valid_sa{
    sa inside {[1:4]};
  }
  
  //constraints on da to be in the range of 1 to 4
  constraint valid_da{
    da inside {[1:4]};
  }
  
  //constraints on payload size to be in the range of 10 to 1990
  constraint valid_payload{
    payload.size inside {[10:1990]};
    foreach(payload[i])
      payload[i] inside {[0:255]};      
  }
  
  //post_randomize to caluclate crc and len and also pack stimulus into queue.
  function void post_randomize();
    len = payload.size() + 1 + 1 + 4 + 4;
    crc = payload.sum();
    post_randomize_extension();
    this.pack(inp_stream);
  endfunction 
  
  //pack method to pack the stimulus in byte order into queue.
  function void pack(ref bit [7:0] q_inp[$]);
    q_inp = {<< 8 {this.payload,this.crc,this.len,this.da,this.sa}};
  endfunction
  
  //unpack method to unpack byte order into packet
  function void unpack(ref bit [7:0] q_inp[$]);
    {<< 8 {this.payload,this.crc,this.len,this.da,this.sa}} = q_inp;
  endfunction
  
  //this is a dummy function, but this will be overrided by test8 to inject error in crc
  virtual function void post_randomize_extension();
    crc = crc;
  endfunction
  
  //Implement Copy method to the fields of packet
  function void copy(packet rhs);
    if(rhs == null)
      begin
        $display("[Error] Null handle passed to copy method");
        $finish;
      end
    this.sa = rhs.sa;
    this.da = rhs.da;
    this.len = rhs.len;
    this.crc = rhs.crc;
    this.payload = rhs.payload;
    this.inp_stream = rhs.inp_stream;
    this.outp_stream = rhs.outp_stream;
  endfunction
  
  //Compare method to compare the fields of packet 
  function bit compare(input packet dut_pkt);
  bit status = 1;

  if(this.inp_stream.size != dut_pkt.outp_stream.size) begin
    $display("[COMP_ERROR] size mismatch exp_size=%0d act_size=%0d",this.inp_stream.size(),dut_pkt.outp_stream.size());
    status = 0;
    return status;
  end
  else
    begin
      foreach(this.inp_stream[i]) begin
        if(status == 1 && (this.inp_stream[i] == dut_pkt.outp_stream[i]))
          begin
            //$display("Matched:");
          end
        else
          begin
            $display("Mismatched: exp %0h act %0h", this.inp_stream[i], dut_pkt.outp_stream[i]);
            $display(this.inp_stream);
            $display(dut_pkt.outp_stream);
            status = 0;
          end
      end          
  end
  return status;
  endfunction
  
  //print method to print the fields of packet 
  function void print();
    $display("[Packet Print] Sa = %0d, Da = %0d, Len = %0h, Crc = %0h",sa,da,len,crc);
    $write("Payload:  ");
    foreach(payload[i])
      $write("%0h ", payload[i]);
    $display("\n");
  endfunction
  
            
endclass
