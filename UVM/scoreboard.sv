//scoreboard by extending from uvm_scoreboard.
class scoreboard #(type T = packet) extends uvm_scoreboard;
  typedef scoreboard #(T) scb_type;
  
  `uvm_component_param_utils(scb_type);
  
  //The $typename system function returns a string that represents the resolved type of its argument
  const static string type_name = $sformatf("scoreboard#(%0s)", $typename(T));
  
  virtual function string get_type_name();
    return type_name;
  endfunction
  
  `uvm_analysis_imp_decl(_inp)
  `uvm_analysis_imp_decl(_outp)
  
  uvm_analysis_imp_inp #(T, scb_type) mon_inp;
  uvm_analysis_imp_outp #(T, scb_type) mon_outp;
  
  T q_in[$];
  bit [31:0] m_matches, m_mismatches;
  bit [31:0] no_of_pkts_recvd;
  
  //custom constructor
  function new (string name = "scoreboard", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info(get_type_name(), "NEW SCOREBOARD", UVM_NONE);
  endfunction
  
  
  //build_phase to construct object for analysis ports
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //Construct object for mon_inp analysis port
    mon_inp = new("mon_inp", this);
    
    //Construct object for mon_outp analysis port
    mon_outp = new("mon_outp", this);
  
  endfunction
  
  virtual function void write_inp(T pkt);
    T pkt_in;
    $cast(pkt_in, pkt.clone());
    q_in.push_back(pkt_in);
  endfunction
  
  virtual function void write_outp(T pkt);
    T ref_pkt;
    int get_index[$];
    int index;
    bit done;
    no_of_pkts_recvd++;
    get_index = q_in.find_index() with (item.sa == pkt.sa && item.da == pkt.da);
    foreach(get_index[i]) begin
      index = get_index[i];
      ref_pkt = q_in[index];
      if(ref_pkt.compare(pkt)) begin
        m_matches++;
        q_in.delete(index);
        `uvm_info("SCB_MATCH", $sformatf("Packet %0d Matched", no_of_pkts_recvd), UVM_NONE);
        done = 1;
        break;
      end
      else
        done = 0;
    end
    if(!done)
      begin
        m_mismatches++;
        `uvm_error("SCB_NOMATCH", $sformatf("*****No matching packet found for the pkt_id=%0d*****", no_of_pkts_recvd));
        `uvm_info("SCB", $sformatf("Expected::%0p", ref_pkt.inp_pkt), UVM_NONE);
        `uvm_info("SCB", $sformatf("Received::%0p", pkt.inp_pkt), UVM_NONE);
        done = 0;
      end
  endfunction
  
  //Implement extract_phase to send matched/mis_matched count to environment
  virtual function void extract_phase(uvm_phase phase);
    //use uvm_config_db::set to send matched count to environment
    uvm_config_db#(int)::set(null,"uvm_test_top.env", "matched", m_matches);
    //use uvm_config_db::set to send mis_matched count to environment
    uvm_config_db#(int)::set(null,"uvm_test_top.env", "mis_matched", m_mismatches);
  endfunction
  
  //report_phase to print matched/mis_matched count.
  function void report_phase(uvm_phase phase);
    `uvm_info("SCB", $sformatf("Scoreboard completed with matches=%0d mismatches=%0d", m_matches, m_mismatches), UVM_NONE);
  endfunction 

endclass

