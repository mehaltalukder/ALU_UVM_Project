`ifndef tx_base_exists
`define tx_base_exists

class tx_base extends uvm_sequence_item;

  `uvm_object_utils(tx_base)
  function new (string name = "tx_base");
    super.new(name);
  endfunction

  rand bit               reset;
  rand bit               load_en;
  randc operand_bit_t    operand_a;
  randc operand_bit_t    operand_b;
  rand opcode_t          opcode;
  operand_logic_t        result; 
  operand_logic_t        alu_out;
  instruction_t          instruction;

  virtual function void do_copy(uvm_object rhs);
    tx_base tx_rhs;
    if (!$cast(tx_rhs, rhs))
      `uvm_fatal(get_type_name(), "Wrong rhs argument")
    
    super.do_copy(rhs);

    reset     = tx_rhs.reset;
    load_en   = tx_rhs.load_en;
    operand_a = tx_rhs.operand_a;
    operand_b = tx_rhs.operand_b;
    opcode    = tx_rhs.opcode;
    alu_out   = tx_rhs.alu_out;
    instruction = tx_rhs.instruction;
  endfunction 

  virtual function bit do_compare (uvm_object rhs, uvm_comparer comparer);
    tx_base tx_rhs;
    if (!$cast(tx_rhs, rhs))
      `uvm_fatal(get_type_name(), "Wrong rhs argument")

    return (super.do_compare(rhs, comparer) &&
           (operand_a === tx_rhs.operand_a) &&
           (operand_b === tx_rhs.operand_b) &&
           (opcode    === tx_rhs.opcode));
  endfunction

  virtual function void do_print (uvm_printer printer);
    printer.m_string = convert2string();
  endfunction

  virtual function string convert2string();
        string s = super.convert2string();
        $sformat(s, "%s\n tx_in (dec):", s);
        $sformat(s, "%s\n reset = %b, load_en = %b", s, reset, load_en);
        $sformat(s, "%s\n opcode = %0x (%s), operand_a = %0d, operand_b = %0d\n", s, opcode, opcode.name(), operand_a, operand_b);
        return s;
  endfunction

endclass: tx_base
`endif