// Code your design here
module router_top(clk,reset,
				sa1,sa2,sa3,sa4,
				sa1_valid,sa2_valid,sa3_valid,sa4_valid,
				da1,da2,da3,da4,
				da1_valid,da2_valid,da3_valid,da4_valid,
				wr,rd,addr,wdata,rdata
				);

  input clk,reset;
  input  [7:0] sa1,sa2,sa3,sa4;
  output [7:0] da1,da2,da3,da4;
 
  input sa1_valid,sa2_valid;
  input sa3_valid,sa4_valid;
  
  input wr,rd;
  input [7:0] addr;
  input [31:0] wdata;
  output [31:0] rdata;

  output da1_valid,da2_valid;
  output da3_valid,da4_valid;
  
  
router router_dut_inst(.clk(clk),.reset(reset),
                       .dut_inp1(sa1),.inp1_valid(sa1_valid),
                       .dut_inp2(sa2),.inp2_valid(sa2_valid),
                       .dut_inp3(sa3),.inp3_valid(sa3_valid),
                       .dut_inp4(sa4),.inp4_valid(sa4_valid),
					   .dut_outp1(da1),.outp1_valid(da1_valid),
					   .dut_outp2(da2),.outp2_valid(da2_valid),
					   .dut_outp3(da3),.outp3_valid(da3_valid),
					   .dut_outp4(da4),.outp4_valid(da4_valid),
					   .wr(wr),.rd(rd),.addr(addr),.wdata(wdata),.rdata(rdata)
					);
endmodule

module router (clk,reset,
           dut_inp1,inp1_valid,
		   dut_inp2,inp2_valid,
		   dut_inp3,inp3_valid,
		   dut_inp4,inp4_valid,
		   dut_outp1,outp1_valid,
		   dut_outp2,outp2_valid,
		   dut_outp3,outp3_valid,
		   dut_outp4,outp4_valid,
		   wr,rd,addr,wdata,rdata
	           );
  input clk,reset;
  input [7:0] dut_inp1,dut_inp2;
  input [7:0] dut_inp3,dut_inp4;
  input inp1_valid,inp2_valid;
  input inp3_valid,inp4_valid;
  
  input wr,rd;
  input [7:0] addr;
  input [31:0] wdata;
  output [31:0] rdata;
  
  output [7:0] dut_outp1,dut_outp2;
  output [7:0] dut_outp3,dut_outp4;
  output outp1_valid,outp2_valid;
  output outp3_valid,outp4_valid;
  
  reg [7:0] dut_outp1,dut_outp2;
  reg [7:0] dut_outp3,dut_outp4;
  reg outp1_valid,outp2_valid;
  reg outp3_valid,outp4_valid;

bit [4:1]  csr_sa_enable;//addr='h20;
bit [4:1]  csr_da_enable;//addr='h24;

bit [31:0] csr_crc_sa1_dropped_count;//addr='h28
bit [31:0] csr_crc_sa2_dropped_count;//addr='h29
bit [31:0] csr_crc_sa3_dropped_count;//addr='h30
bit [31:0] csr_crc_sa4_dropped_count;//addr='h31

bit [31:0] csr_pkt_size_dropped_count; //addr='h32;

bit [31:0] csr_total_inp1_pkt_count;//addr='h36;
bit [31:0] csr_total_inp2_pkt_count;//addr='h40;
bit [31:0] csr_total_inp3_pkt_count;//addr='h44;
bit [31:0] csr_total_inp4_pkt_count;//addr='h48;

bit [31:0] csr_total_outp1_pkt_count;//addr='h52;
bit [31:0] csr_total_outp2_pkt_count;//addr='h56;
bit [31:0] csr_total_outp3_pkt_count;//addr='h60;
bit [31:0] csr_total_outp4_pkt_count;//addr='h64;

bit [31:0] csr_invalid_da_pkt_dropped_count;//addr='h66

bit [31:0] csr_sa1_pkt_dropped_count;//addr='h70
bit [31:0] csr_sa2_pkt_dropped_count;//addr='h72
bit [31:0] csr_sa3_pkt_dropped_count;//addr='h74
bit [31:0] csr_sa4_pkt_dropped_count;//addr='h76

bit [31:0] csr_da1_pkt_dropped_count;//addr='h80
bit [31:0] csr_da2_pkt_dropped_count;//addr='h82
bit [31:0] csr_da3_pkt_dropped_count;//addr='h84
bit [31:0] csr_da4_pkt_dropped_count;//addr='h86

bit [31:0] csr_total_inp_pkt_count;//addr='h90
bit [31:0] csr_total_outp_pkt_count;//addr='h92
bit [31:0] csr_total_crc_dropped_pkt_count;//addr='h94

reg [31:0] rdata;

bit [31:0] dport1[$];
bit [31:0] dport2[$];
bit [31:0] dport3[$];
bit [31:0] dport4[$];

always @(posedge clk or posedge reset) begin 

if(reset) begin
csr_crc_sa1_dropped_count <=0;
csr_crc_sa2_dropped_count <= 0;
csr_crc_sa3_dropped_count <=0;
csr_crc_sa4_dropped_count <= 0;

csr_pkt_size_dropped_count<=0;
csr_invalid_da_pkt_dropped_count <=0;

csr_total_inp1_pkt_count <=0;
csr_total_inp2_pkt_count  <=0;
csr_total_inp3_pkt_count <=0;
csr_total_inp4_pkt_count <=0;

csr_total_outp1_pkt_count <=0;
csr_total_outp2_pkt_count <=0;
csr_total_outp3_pkt_count <=0;
csr_total_outp4_pkt_count <=0;

csr_sa1_pkt_dropped_count <= 0;
csr_sa2_pkt_dropped_count <= 0;
csr_sa3_pkt_dropped_count <= 0;
csr_sa4_pkt_dropped_count <= 0;

csr_da1_pkt_dropped_count <= 0;
csr_da2_pkt_dropped_count <= 0;
csr_da3_pkt_dropped_count <= 0;
csr_da4_pkt_dropped_count <= 0;

csr_total_inp_pkt_count  <= 0;
csr_total_outp_pkt_count <= 0;
csr_total_crc_dropped_pkt_count <=0;

rdata<=0;
end
else if (wr===1'b1) begin
case (addr) 
 'h20 : csr_sa_enable <= wdata[3:0];
 'h24 : csr_da_enable <= wdata[3:0];
 default: begin 
			$display("[DUT_ERROR] invalid csr write address(%0h) received at time=%0t",addr,$time);
		end
endcase
end
else if (rd===1'b1) begin
case (addr) 
 'h28 : rdata <= csr_crc_sa1_dropped_count;
 'h29 : rdata <= csr_crc_sa2_dropped_count;
 'h30 : rdata <= csr_crc_sa3_dropped_count;
 'h31 : rdata <= csr_crc_sa4_dropped_count;
 
 'h32 : rdata <= csr_pkt_size_dropped_count;
 
 'h36 : rdata <= csr_total_inp1_pkt_count;
 'h40 : rdata <= csr_total_inp2_pkt_count;
 'h44 : rdata <= csr_total_inp3_pkt_count;
 'h48 : rdata <= csr_total_inp4_pkt_count;
 
 'h52 : rdata <= csr_total_outp1_pkt_count;
 'h56 : rdata <= csr_total_outp2_pkt_count;
 'h60 : rdata <= csr_total_outp3_pkt_count;
 'h64 : rdata <= csr_total_outp4_pkt_count;
 
 'h66 : rdata <= csr_invalid_da_pkt_dropped_count;
 
 'h70 : rdata <= csr_sa1_pkt_dropped_count;
 'h72 : rdata <= csr_sa2_pkt_dropped_count;
 'h74 : rdata <= csr_sa3_pkt_dropped_count;
 'h76 : rdata <= csr_sa4_pkt_dropped_count;
 
 'h80 : rdata <= csr_da1_pkt_dropped_count;
 'h82 : rdata <= csr_da2_pkt_dropped_count;
 'h84 : rdata <= csr_da3_pkt_dropped_count;
 'h86 : rdata <= csr_da4_pkt_dropped_count;
 
 'h90 : rdata <= get_inp_full_count(csr_total_inp_pkt_count);
 'h92 : rdata <= get_outp_full_count(csr_total_outp_pkt_count);
 'h94 : rdata <= get_crc_drop_full_count(csr_total_crc_dropped_pkt_count);
 
 default: begin 
			$display("[DUT_ERROR] Invalid CSR Read Address(%0h) received at time=%0t",addr,$time);
		  end
endcase
end
end//end_of_always


//sa0 da1 len2 len3 len4 len5
logic [7:0] inp1_pkt[$];
bit [31:0] len_recv1; 

typedef logic [7:0] q1[$];
q1 q_inp1[$];

always@(posedge clk or posedge reset) begin 
if(reset) begin
inp1_pkt.delete();
len_recv1=0;
end
else begin
while(inp1_valid && csr_sa_enable[1]) begin
  
 inp1_pkt.push_back(dut_inp1);
 if($test$plusargs("dut_debug_input"))
    $display("[DUT_SA1]  dut_inp1=%0d time=%0t",dut_inp1,$time);
 @(posedge clk);
 if(inp1_pkt.size() == 6) begin
     len_recv1={inp1_pkt[5],inp1_pkt[4],inp1_pkt[3],inp1_pkt[2]};
     //$display("[DUT_SA1 LEN1] len1=%0d time=%0d",len_recv1,$time);
 end
 if (inp1_pkt.size() == len_recv1) begin
      csr_total_inp1_pkt_count++;
	  
   if($test$plusargs("dut_debug") )
      $display("[DUT_SA1]  Total Packet %0d collected size=%0d time=%0t",csr_total_inp1_pkt_count,inp1_pkt.size(),$time);
	  
	  if(is_packet_not_ok(inp1_pkt)) begin
		inp1_pkt.delete();
        len_recv1=0;
		break;//drop the packet as size is not ok
	  end
	  if(is_da_not_ok(inp1_pkt[1],1)) begin
		inp1_pkt.delete();
        len_recv1=0;
		break;//drop the packet as da is invalid
	  end
	  
	 if(is_sa_not_ok(inp1_pkt[0],1)) begin
		inp1_pkt.delete();
        len_recv1=0;
		break;//drop the packet as sa is invalid
	  end
	  
   if(calc_crc(inp1_pkt)) begin
      len_recv1<=0;
      case (inp1_pkt[1])
	  1 : dport1.push_back(1);
	  2 : dport2.push_back(1);
	  3 : dport3.push_back(1);
	  4 : dport4.push_back(1);
	  default : $display("[DUT Error] Not a Valid destinatoion Port ");
      endcase
      q_inp1.push_back(inp1_pkt);
      inp1_pkt.delete();
      break; 
   end//end_of_crc_if
   else begin
    csr_crc_sa1_dropped_count++;
    if($test$plusargs("dut_debug_crc")) begin
    $display("[DUT_SA1_CRC] Packet %0d Dropped in DUT due to CRC Mismatch time=%0t",csr_total_inp1_pkt_count,$time);
    end
    inp1_pkt.delete();
    len_recv1<=0;
    break;
   end
  end//end_of_if
end//end_of_while
end//end_of_main_if_else
end//end_of_always

logic [7:0] inp2_pkt[$];
bit [31:0] len_recv2; 


typedef logic [7:0] q2[$];
q2 q_inp2[$];

always@(posedge clk or posedge reset) begin 
if(reset) begin
inp2_pkt.delete();
len_recv2=0;
end
else begin
while(inp2_valid && csr_sa_enable[2]) begin

 inp2_pkt.push_back(dut_inp2);
 if($test$plusargs("dut_debug_input"))
    $display("[DUT_SA2]  dut_inp2=%0d time=%0t",dut_inp2,$time);
 @(posedge clk);
 if(inp2_pkt.size() == 6) begin
     len_recv2={inp2_pkt[5],inp2_pkt[4],inp2_pkt[3],inp2_pkt[2]};
      //$display("[DUT_SA2 LEN2] len2=%0d time=%0d",len_recv2,$time);
 end

 if (inp2_pkt.size() == len_recv2) begin
      csr_total_inp2_pkt_count++;
   if($test$plusargs("dut_debug") )
      $display("[DUT_SA2]  Total Packet %0d collected size=%0d time=%0t",csr_total_inp2_pkt_count,inp2_pkt.size(),$time);
	  
   	  if(is_packet_not_ok(inp2_pkt)) begin
		inp2_pkt.delete();
          len_recv2=0;
		break;//drop the packet as size is not ok
	  end
	  if(is_da_not_ok(inp2_pkt[1],2)) begin
		inp2_pkt.delete();
          len_recv2=0;
		break;//drop the packet as da is invalid
	  end
	  
	  if(is_sa_not_ok(inp2_pkt[0],2)) begin
		inp2_pkt.delete();
          len_recv2=0;
		break;//drop the packet as da is invalid
	  end
	  
   if(calc_crc(inp2_pkt)) begin
      len_recv2<=0;
      case (inp2_pkt[1])
	  1 : dport1.push_back(2);
	  2 : dport2.push_back(2);
	  3 : dport3.push_back(2);
	  4 : dport4.push_back(2);
	  default : $display("[DUT Error] Not a Valid destinatoion Port ");
      endcase
      q_inp2.push_back(inp2_pkt);
      inp2_pkt.delete();
      break; 
   end//end_of_crc_if
   else begin
    csr_crc_sa2_dropped_count++;
    if($test$plusargs("dut_debug_crc")) begin
    $display("[DUT_SA2_CRC] Packet %0d Dropped in DUT due to CRC Mismatch time=%0t",csr_total_inp2_pkt_count,$time);
    end
    inp2_pkt.delete();
    len_recv2<=0;
    break;
   end
  end//end_of_if
end//end_of_while
end//end_of_main_if_else
end//end_of_always

//sa0 da1 len2 len3 len4 len5
logic [7:0] inp3_pkt[$];
bit [31:0] len_recv3; 


typedef logic [7:0] q3[$];
q3 q_inp3[$];

always@(posedge clk or posedge reset) begin 
if(reset) begin
inp3_pkt.delete();
len_recv3=0;
end
else begin
while(inp3_valid && csr_sa_enable[3]) begin

 inp3_pkt.push_back(dut_inp3);
 if($test$plusargs("dut_debug_input"))
    $display("[DUT_SA3]  dut_inp3=%0d time=%0t",dut_inp3,$time);
 @(posedge clk);
 if(inp3_pkt.size() == 6) begin
     len_recv3={inp3_pkt[5],inp3_pkt[4],inp3_pkt[3],inp3_pkt[2]};
     //$display("[DUT_SA3 Len3] len3=%0d time=%0d",len_recv3,$time);
 end
 if (inp3_pkt.size() == len_recv3) begin
      csr_total_inp3_pkt_count++;
   if($test$plusargs("dut_debug") )
      $display("[DUT_SA3]  Total Packet %0d collected size=%0d time=%0t",csr_total_inp3_pkt_count,inp3_pkt.size(),$time);
	  
   	  if(is_packet_not_ok(inp3_pkt)) begin
		inp3_pkt.delete();
          len_recv3=0;
		break;//drop the packet as size is not ok
	  end
	  if(is_da_not_ok(inp3_pkt[1],3)) begin
		inp3_pkt.delete();
          len_recv3=0;
		break;//drop the packet as da is invalid
	  end
	  
	  if(is_sa_not_ok(inp3_pkt[0],3)) begin
		inp3_pkt.delete();
          len_recv3=0;
		break;//drop the packet as sa is invalid
	  end	 
	  
   if(calc_crc(inp3_pkt)) begin
      len_recv3<=0;
       case (inp3_pkt[1])
	  1 : dport1.push_back(3);
	  2 : dport2.push_back(3);
	  3 : dport3.push_back(3);
	  4 : dport4.push_back(3);
	  default : $display("[DUT Error] Not a Valid destinatoion Port ");
      endcase
      q_inp3.push_back(inp3_pkt);
      inp3_pkt.delete();
      break; 
   end//end_of_crc_if
   else begin
    csr_crc_sa3_dropped_count++;
    if($test$plusargs("dut_debug_crc")) begin
    $display("[DUT_SA3_CRC] Packet %0d Dropped in DUT due to CRC Mismatch time=%0t",csr_total_inp3_pkt_count,$time);
    end
    inp3_pkt.delete();
    len_recv3<=0;
    break;
   end
  end//end_of_if
end//end_of_while
end//end_of_main_if_else
end//end_of_always

//sa0 da1 len2 len3 len4 len5
logic [7:0] inp4_pkt[$];
bit [31:0] len_recv4; 

typedef logic [7:0] q4[$];
q4 q_inp4[$];

always@(posedge clk or posedge reset) begin 
if(reset) begin
inp4_pkt.delete();
len_recv4=0;
end
else begin
while(inp4_valid && csr_sa_enable[4]) begin

 inp4_pkt.push_back(dut_inp4);
 if($test$plusargs("dut_debug_input"))
    $display("[DUT_SA4]  dut_inp4=%0d time=%0t",dut_inp4,$time);
 @(posedge clk);
 if(inp4_pkt.size() == 6) begin
     len_recv4={inp4_pkt[5],inp4_pkt[4],inp4_pkt[3],inp4_pkt[2]};
     //$display("[DUT_SA4 LEN4] len4=%0d time=%0d",len_recv4,$time);
 end
 if (inp4_pkt.size() == len_recv4) begin
      csr_total_inp4_pkt_count++;
   if($test$plusargs("dut_debug") )
      $display("[DUT_SA4]  Total Packet %0d collected size=%0d time=%0t",csr_total_inp4_pkt_count,inp4_pkt.size(),$time);
	  
	  if(is_packet_not_ok(inp4_pkt)) begin
		inp4_pkt.delete();
          len_recv4=0;
		break;//drop the packet as size is not ok
	  end
	  if(is_da_not_ok(inp4_pkt[1],4)) begin
		inp4_pkt.delete();
          len_recv4=0;
		break;//drop the packet as da is invalid
	  end

	  if(is_sa_not_ok(inp4_pkt[0],4)) begin
		inp4_pkt.delete();
          len_recv4=0;
		break;//drop the packet as sa is invalid
	  end
	  
   if(calc_crc(inp4_pkt)) begin
      len_recv4<=0;
      case (inp4_pkt[1])
	  1 : dport1.push_back(4);
	  2 : dport2.push_back(4);
	  3 : dport3.push_back(4);
	  4 : dport4.push_back(4);
	  default : $display("[DUT Error] Not a Valid destinatoion Port ");
      endcase
     q_inp4.push_back(inp4_pkt);
     inp4_pkt.delete();
      break; 
   end//end_of_crc_if
   else begin
    csr_crc_sa4_dropped_count++;
    if($test$plusargs("dut_debug_crc")) begin
    $display("[DUT_SA4_CRC] Packet %0d Dropped in DUT due to CRC Mismatch time=%0t",csr_total_inp4_pkt_count,$time);
    end
    inp4_pkt.delete();
    len_recv4<=0;
    break;
   end
  end//end_of_if
end//end_of_while
end//end_of_main_if_else
end//end_of_always

logic [7:0] t_pkt1[$];
bit [3:0] port1;

always @(posedge clk) begin
wait(dport1.size() > 0);
port1=dport1.pop_front();
case(port1)
    1: t_pkt1=q_inp1.pop_front();//sa1->da1
    2: t_pkt1=q_inp2.pop_front();//sa2->da1
    3: t_pkt1=q_inp3.pop_front();//sa3->da1
    4: t_pkt1=q_inp4.pop_front();//sa4->da1
endcase

while(1) begin
@(posedge clk);
outp1_valid <=1;
dut_outp1   <= t_pkt1.pop_front();
if($test$plusargs("dut_debug_output"))
    $strobe("[DUT_DA1_Output] dut_outp1=%0d time=%0t",dut_outp1,$time);
if(t_pkt1.size() ==0) begin
      csr_total_outp1_pkt_count++;
   if($test$plusargs("dut_debug") )
      $display("[DUT_DA1_Output] Total Packet %0d Driving completed at time=%0t",csr_total_outp1_pkt_count,$time);
  
  @(posedge clk);
  outp1_valid <= 1'b0;
  dut_outp1 <= 'z;
  break;
end//end_of_if;

end//end_of_while

end//end_of_always


logic [7:0] t_pkt2[$];
bit [3:0] port2;

always @(posedge clk) begin
wait(dport2.size() > 0);
port2=dport2.pop_front();
case(port2)
    1: t_pkt2=q_inp1.pop_front();//sa1->da2
    2: t_pkt2=q_inp2.pop_front();//sa2->da2
    3: t_pkt2=q_inp3.pop_front();//sa3->da2
    4: t_pkt2=q_inp4.pop_front();//sa4->da2
endcase

while(1) begin
@(posedge clk);
outp2_valid <=1;
dut_outp2   <= t_pkt2.pop_front();
if($test$plusargs("dut_debug_output"))
    $strobe("[DUT_DA2_Output] dut_outp2=%0d time=%0t",dut_outp2,$time);
if(t_pkt2.size() ==0) begin
      csr_total_outp2_pkt_count++;
   if($test$plusargs("dut_debug") )
      $display("[DUT_DA2_Output] Total Packet %0d Driving completed at time=%0t",csr_total_outp2_pkt_count,$time);
  
  @(posedge clk);
  outp2_valid <= 1'b0;
  dut_outp2 <= 'z;
  break;
end//end_of_if;

end//end_of_while

end//end_of_always


logic [7:0] t_pkt3[$];
bit [3:0] port3;

always @(posedge clk) begin
wait(dport3.size() > 0);
port3=dport3.pop_front();
case(port3)
    1: t_pkt3=q_inp1.pop_front();//sa1->da3
    2: t_pkt3=q_inp2.pop_front();//sa2->da3
    3: t_pkt3=q_inp3.pop_front();//sa3->da3
    4: t_pkt3=q_inp4.pop_front();//sa4->da3
endcase

while(1) begin
@(posedge clk);
outp3_valid <=1;
dut_outp3   <= t_pkt3.pop_front();
if($test$plusargs("dut_debug_output"))
    $strobe("[DUT_DA3_Output] dut_outp3=%0d time=%0t",dut_outp3,$time);
if(t_pkt3.size() ==0) begin
      csr_total_outp3_pkt_count++;
   if($test$plusargs("dut_debug") )
      $display("[DUT_DA3_Output] Total Packet %0d Driving completed at time=%0t",csr_total_outp3_pkt_count,$time);
  
  @(posedge clk);
  outp3_valid <= 1'b0;
  dut_outp3 <= 'z;
  break;
end//end_of_if;

end//end_of_while

end//end_of_always

logic [7:0] t_pkt4[$];
bit [3:0] port4;

always @(posedge clk) begin
wait(dport4.size() > 0);
port4=dport4.pop_front();
case(port4)
    1: t_pkt4=q_inp1.pop_front();//sa1->da4
    2: t_pkt4=q_inp2.pop_front();//sa2->da4
    3: t_pkt4=q_inp3.pop_front();//sa3->da4
    4: t_pkt4=q_inp4.pop_front();//sa4->da4
endcase

while(1) begin
@(posedge clk);
outp4_valid <=1;
dut_outp4   <= t_pkt4.pop_front();
if($test$plusargs("dut_debug_output"))
    $strobe("[DUT_DA4_Output] dut_outp4=%0d time=%0t",dut_outp4,$time);
if(t_pkt4.size() ==0) begin
      csr_total_outp4_pkt_count++;
   if($test$plusargs("dut_debug") )
      $display("[DUT_DA4_Output] Total Packet %0d Driving completed at time=%0t",csr_total_outp4_pkt_count,$time);
  
  @(posedge clk);
  outp4_valid <= 1'b0;
  dut_outp4 <= 'z;
  break;
end//end_of_if;

end//end_of_while

end//end_of_always


function automatic bit calc_crc(const ref logic [7:0] pkt[$]);
bit [31:0] crc,new_crc;
bit [7:0] payload[$];
crc={pkt[9],pkt[8],pkt[7],pkt[6]};
for(int i=10;i < pkt.size(); i++) begin
    payload.push_back(pkt[i]);
end
new_crc=payload.sum();
payload.delete();
    if($test$plusargs("dut_debug_crc"))
       	$display("[DUT_SA%0d_CRC] Received crc=%0d caluclated crc=%0d time=%0t",pkt[0],crc,new_crc,$time);
return (crc == new_crc);
endfunction

function automatic bit [31:0] get_inp_count(bit [7:0] sa);
 case(sa)
 'd1 : return csr_total_inp1_pkt_count;
 'd2 : return csr_total_inp2_pkt_count;
 'd3 : return csr_total_inp3_pkt_count;
 'd4 : return csr_total_inp4_pkt_count;
 default:return 0;
endcase
endfunction

function automatic bit [31:0] get_inp_full_count(ref bit [31:0] outp);
outp=csr_total_inp1_pkt_count+csr_total_inp2_pkt_count+csr_total_inp3_pkt_count+csr_total_inp4_pkt_count;
return outp;
endfunction

function automatic bit [31:0] get_outp_full_count(ref bit [31:0] outp);
outp=csr_total_outp1_pkt_count+csr_total_outp2_pkt_count+csr_total_outp3_pkt_count+csr_total_outp4_pkt_count;
return outp;
endfunction

function automatic bit [31:0] get_crc_drop_full_count(ref bit [31:0] outp);
outp=csr_crc_sa1_dropped_count+csr_crc_sa2_dropped_count+csr_crc_sa3_dropped_count+csr_crc_sa4_dropped_count;
return outp;
endfunction

function automatic bit is_packet_not_ok(const ref logic [7:0] pkt[$]);
if(pkt.size() <= 13 || pkt.size() >= 2001) begin
csr_pkt_size_dropped_count++; //Drop the packet as its not satisfying minimum or maximux size of packet
 if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet %0d Dropped in DUT due to size mismatch at time=%0t",get_inp_count(pkt[0]),$time);
	$display("[DUT_ERROR] Received packet size=%0d , Allowed range 12Bytes ->to-> 2000 Bytes ",pkt.size());
 end
return 1;
end else return 0;
endfunction

function automatic bit is_da_not_ok(bit [7:0] da,port);
if(! (da inside {[1:4]})) begin
//Drop the packet as da port does not exists
csr_invalid_da_pkt_dropped_count++;

 if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet %0d Dropped in DUT due to invalid da(%0d) port received at time=%0t",get_inp_count(port),da,$time);
	$display("[DUT_ERROR] SA Port %0d Received packet with illegal da=%0d , Allowed da values {1,2,3,4} ",port,da);
 end

return 1;
end 
else if (csr_da_enable[da])
	       return 0;
else begin
//Drop the packet as da port is not enabled
case (da)
'd1 : csr_da1_pkt_dropped_count++;
'd2 : csr_da2_pkt_dropped_count++;
'd3 : csr_da3_pkt_dropped_count++;
'd4 : csr_da4_pkt_dropped_count++;
endcase
if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet %0d Dropped in DUT due to da(%0d) port is not enabled at time=%0t",get_inp_count(port),da,$time);
end
return 1;
end
endfunction

function automatic bit is_sa_not_ok(bit [7:0] sa,port);
  if( (! (sa inside {[1:4]})) || (!csr_sa_enable[sa]) ) begin
//Drop the packet as sa port does not exists or not enabled
case (port)
'd1 : csr_sa1_pkt_dropped_count++;
'd2 : csr_sa2_pkt_dropped_count++;
'd3 : csr_sa3_pkt_dropped_count++;
'd4 : csr_sa4_pkt_dropped_count++;
endcase

 if($test$plusargs("dut_debug")) begin
	$display("[DUT_ERROR] Packet %0d Dropped in DUT due to invalid sa(%0d) port received at time=%0t",get_inp_count(port),sa,$time);
	$display("[DUT_ERROR] SA Port %0d Received packet with illegal sa=%0d , Allowed sa values {1,2,3,4} ",port,sa);
 end

return 1;
end 
endfunction

endmodule



