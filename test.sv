//Linear SV testbench to check the basic design functionality
module test;
  reg clk, reset;
  reg [7:0] sa1,sa2,sa3,sa4;
  reg sa1_valid, sa2_valid, sa3_valid, sa4_valid;
  wire [7:0] da1,da2,da3,da4;
  wire da1_valid, da2_valid, da3_valid, da4_valid;
  
  //CSR Related Signals
  reg wr,rd;
  reg [7:0] addr;
  reg [31:0] wdata;
  wire [31:0] rdata;
  
  router_top dut_inst(.clk(clk),
                      .reset(reset),
                      .sa1(sa1),.sa2(sa2),.sa3(sa3),.sa4(sa4),
                      .sa1_valid(sa1_valid),.sa2_valid(sa2_valid),
                      .sa3_valid(sa3_valid),.sa4_valid(sa4_valid),
                      .da1(da1),.da2(da2),.da3(da3),.da4(da4),
                      .da1_valid(da1_valid),.da2_valid(da2_valid),
                      .da3_valid(da3_valid),.da4_valid(da4_valid),
                      .wr(wr),
                      .rd(rd),
                      .addr(addr),
                      .wdata(wdata),
                      .rdata(rdata)
                     );
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  task apply_reset();
    reset <= 1'b1;
    repeat(3) @(posedge clk);
    reset <= 1'b0;
  endtask
  
  task write_config();
    //Write
    //csr_sa_enable
    @(posedge clk);
    wr <= 1'b1;
    addr <= 'h20;
    wdata <= 31'hf;
    @(posedge clk);
    wr <= 1'b0;
    
    //write
    //csr_da_enable
    @(posedge clk);
    wr <= 1'b1;
    addr <= 'h24;
    wdata <= 31'hf;
    @(posedge clk);
    wr <= 1'b0;
  endtask
  
  
  task read_config();
    //read only
    @(posedge clk);
    rd <= 1'b1;
    addr <= 'h90;
    //rdata <= 31'hf;
    @(posedge clk);
    rd <= 1'b0;
    
    
    //read only
    @(posedge clk);
    rd <= 1'b1;
    addr <= 'h92;
    //rdata <= 31'hf;
    @(posedge clk);
    rd <= 1'b0;
  endtask
  
  
  typedef struct {
    bit [7:0] sa;
    bit [7:0] da;
    bit [31:0] len;
    bit [31:0] crc;
    bit [7:0] payload [];
  } packet;
  
  
  function automatic void generate_stimulus(ref packet pkt);
    pkt.sa = $urandom_range(1,4);
    pkt.da = $urandom_range(1,4);
    pkt.payload = new[10];
    foreach(pkt.payload[i])
      pkt.payload[i] = $urandom;
    pkt.len = pkt.payload.size() + 4 + 4 + 1 + 1;
    pkt.crc = pkt.payload.sum();
    
  endfunction
  
  function void print(input packet pkt);
    $display("[TB Print] Sa=%0h Da=%0h Len=%0h Crc=%0h",pkt.sa,pkt.da,pkt.len,pkt.crc);
    foreach(pkt.payload[k])
      $display("[TB Print] Payload[%0h]=%0h",k,pkt.payload[k]);
  endfunction
  
  
  task apply_stimulus();
    packet pkt1,pkt2,pkt3,pkt4;
    write_config();
    fork
      generate_stimulus(pkt1);
      print(pkt1);
      
      begin
      $display("Driving first packet started at time=%t", $realtime);
      @(posedge clk);
      sa1_valid <= 1'b1;
      sa1 <= pkt1.sa;
      @(posedge clk);
      sa1 <= pkt1.da;
      @(posedge clk);
      sa1 <= pkt1.len[7:0];
      @(posedge clk);
      sa1 <= pkt1.len[15:8];
      @(posedge clk);
      sa1 <= pkt1.len[23:16];
      @(posedge clk);
      sa1 <= pkt1.len[31:24];
      @(posedge clk);
      sa1 <= pkt1.crc[7:0];
      @(posedge clk);
      sa1 <= pkt1.crc[15:8];
      @(posedge clk);
      sa1 <= pkt1.crc[23:16];
      @(posedge clk);
      sa1 <= pkt1.crc[31:24];
      foreach(pkt1.payload[i])
        begin
          @(posedge clk);
          sa1 <= pkt1.payload[i];
        end
      @(posedge clk);
      sa1_valid <= 1'b0;
      $display("Driving first packet ended at time=%t", $realtime);
      end
      
      generate_stimulus(pkt2);
      print(pkt2);
      
      begin
        $display("Driving second packet started at time=%t", $realtime);
        @(posedge clk);
        sa2_valid <= 1'b1;
        sa2 <= pkt2.sa;
        @(posedge clk);
        sa2 <= pkt2.da;
        @(posedge clk);
        sa2 <= pkt2.len[7:0];
        @(posedge clk);
        sa2 <= pkt2.len[15:8];
        @(posedge clk);
        sa2 <= pkt2.len[23:16];
        @(posedge clk);
        sa2 <= pkt2.len[31:24];
        @(posedge clk);
        sa2 <= pkt2.crc[7:0];
        @(posedge clk);
        sa2 <= pkt2.crc[15:8];
        @(posedge clk);
        sa2 <= pkt2.crc[23:16];
        @(posedge clk);
        sa2 <= pkt2.crc[31:24];
        foreach(pkt2.payload[i])
          begin
            @(posedge clk);
            sa2 <= pkt2.payload[i];
          end
        @(posedge clk);
        sa2_valid <= 1'b0;
        $display("Driving second packet ended at time=%t", $realtime);
      end
      
      generate_stimulus(pkt3);
      print(pkt3);
      
      begin
        $display("Driving third packet started at time=%t", $realtime);
        @(posedge clk);
        sa3_valid <= 1'b1;
        sa3 <= pkt3.sa;
        @(posedge clk);
        sa3 <= pkt3.da;
        @(posedge clk);
        sa3 <= pkt3.len[7:0];
        @(posedge clk);
        sa3 <= pkt3.len[15:8];
        @(posedge clk);
        sa3 <= pkt3.len[23:16];
        @(posedge clk);
        sa3 <= pkt3.len[31:24];
        @(posedge clk);
        sa3 <= pkt3.crc[7:0];
        @(posedge clk);
        sa3 <= pkt3.crc[15:8];
        @(posedge clk);
        sa3 <= pkt3.crc[23:16];
        @(posedge clk);
        sa3 <= pkt3.crc[31:24];
        foreach(pkt3.payload[i])
          begin
            @(posedge clk);
            sa3 <= pkt3.payload[i];
          end
        @(posedge clk);
        sa3_valid <= 1'b0;
        $display("Driving third packet ended at time=%t", $realtime);
      end
      
      
      generate_stimulus(pkt4);
      print(pkt4);
      
      begin
        $display("Driving fourth packet started at time=%t", $realtime);
        @(posedge clk);
        sa4_valid <= 1'b1;
        sa4 <= pkt4.sa;
        @(posedge clk);
        sa4 <= pkt4.da;
        @(posedge clk);
        sa4 <= pkt4.len[7:0];
        @(posedge clk);
        sa4 <= pkt4.len[15:8];
        @(posedge clk);
        sa4 <= pkt4.len[23:16];
        @(posedge clk);
        sa4 <= pkt4.len[31:24];
        @(posedge clk);
        sa4 <= pkt4.crc[7:0];
        @(posedge clk);
        sa4 <= pkt4.crc[15:8];
        @(posedge clk);
        sa4 <= pkt4.crc[23:16];
        @(posedge clk);
        sa4 <= pkt4.crc[31:24];
        foreach(pkt4.payload[i])
          begin
            @(posedge clk);
            sa4 <= pkt4.payload[i];
          end
        @(posedge clk);
        sa4_valid <= 1'b0;
        $display("Driving fourth packet ended at time=%t", $realtime);
      end
    join
    read_config();
  endtask
  
  initial
    begin
      apply_reset();
      repeat(2) begin
      apply_stimulus();
      repeat(50) @(posedge clk);
      end
      $finish;
    end
  
  initial 
    begin
    $dumpfile("dump.vcd");
      $dumpvars(0,test.dut_inst); 
  end
endmodule
