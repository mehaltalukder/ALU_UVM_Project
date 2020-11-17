`ifndef alu_scoreboard_exists
`define alu_scoreboard_exists

  `uvm_analysis_imp_decl(_dut_in)
  `uvm_analysis_imp_decl(_dut_out)

class alu_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(alu_scoreboard)
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction: new

  uvm_analysis_imp_dut_in  #(tx_in, alu_scoreboard) dut_in_imp_export;
  uvm_analysis_imp_dut_out #(tx_out,  alu_scoreboard) dut_out_imp_export;

  int match, mismatch;
  int max;
  operand_logic_t rr;
  
  tx_out expect_aa[operand_bit_t]; 

  virtual function void build_phase(uvm_phase phase);
 
    dut_in_imp_export  = new("dut_in_imp_export", this);
    dut_out_imp_export = new("dut_out_imp_export", this);

  endfunction

  function void write_dut_in(tx_in t);

  tx_out exp;
 
  if (t.reset == 0) begin
    expect_aa.delete();
  end

  else if (t.load_en===1) begin 
    
  max = t.operand_b[1:0];
  exp = tx_out::type_id::create("exp");

  case (t.opcode)
        INVERT_A   :  t.alu_out = ~t.operand_a;
        NEGATE_A   :  t.alu_out = -t.operand_a;
        INCREMENT_A:  t.alu_out = t.operand_a + 1'b1;
        A_PLUS_B   :  t.alu_out = t.operand_a + t.operand_b;
        A_MINUS_B  :  t.alu_out = t.operand_a - t.operand_b;
        A_XORED_B  :  t.alu_out = t.operand_a ^ t.operand_b;
        A_SHIFTED_B:  t.alu_out = t.operand_a >> max;      // shift operand_b times; max of 3
        A_ROTATED_B:  t.alu_out = {t.operand_a,t.operand_a} >> max;  // rotate operand_b times; max of 3
        default      : $error ("Unexpected opcode = %operand_b", t.opcode);
        endcase
    exp.operand_a = t.operand_a;
    exp.reset     = t.reset;
    exp.operand_b = t.operand_b; 
    exp.opcode    = t.opcode;   
    exp.alu_out   = t.alu_out;
    expect_aa[exp.i]  = exp;
  end
 
  endfunction: write_dut_in

  function void write_dut_out(tx_out t);
 
    if (t.reset === 0) begin
    return;
    end

    if (!expect_aa.exists(t.i)) begin
       `uvm_error("SCOREBOARD", $sformatf("read_pointer value  is an address that has not been written\n"))
    end
    
    else if (t.compare(expect_aa[t.i])) begin
      match++;
      expect_aa.delete(t.i);
    end

    else begin

      `uvm_error("SCOREBOARD", $sformatf("Expected and actual did not match at address "))
      `uvm_info("SCOREBOARD",  $sformatf("DUT out is:%s\nExpected",
                               t.convert2string(), expect_aa[t.i].convert2string()), UVM_NONE)
      mismatch++;
    end 
    
  endfunction: write_dut_out

    virtual function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", $sformatf("\n\n\t Test score: passed=%0d  failed=%0d\n", match, mismatch), UVM_NONE)

  endfunction: report_phase




endclass
`endif