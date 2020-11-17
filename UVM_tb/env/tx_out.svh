`ifndef tx_out_exists
`define tx_out_exists

class tx_out extends tx_base;

  `uvm_object_utils(tx_out)
  function new (string name = "tx_out");
    super.new(name);
  endfunction 

  bit i = 1'b1;

  virtual function void do_copy(uvm_object rhs);
    tx_out tx_rhs;
    if (!$cast(tx_rhs, rhs))
      `uvm_fatal("TX_CAST", "Illegal do_copy argument in tx_out")

    super.do_copy(rhs);
    alu_out = tx_rhs.alu_out;

  endfunction: do_copy

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    tx_out tx_rhs;
    if (!$cast(tx_rhs, rhs))
      `uvm_fatal("TX_CAST", "Illegal do_compare argument in tx_out")

    return (/*super.do_compare(rhs, comparer) &&*/
            (alu_out === tx_rhs.alu_out));

  endfunction : do_compare

  function string convert2string();
 
    string s;
    $sformat(s, "%s\n tx_out values (dec):", s);
    $sformat(s, "%s\n  opcode = %0x (%s), operand_a, b = %0d, %0d, alu_out = %0d\n", s, instruction.opc, instruction.opc.name(), instruction.op_a, instruction.op_b, alu_out);
    return s;
  endfunction: convert2string

  bit ignore_in_scoreboard = 0;

endclass: tx_out
`endif