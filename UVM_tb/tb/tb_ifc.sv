/***********************************************************************
 * The interface is used to connect the testbench to the DUT
 **********************************************************************/
 
interface tb_ifc (input logic clk);
  timeunit 1ns; timeprecision 1ns;

  import alu_opcodes_pkg::*;

  bit              load_en, reset;       // DUT input
  operand_bit_t    operand_a, operand_b; // DUT input
  opcode_t         opcode;               // DUT input
  operand_logic_t  alu_out;              // DUT output
  instruction_t    instruction_word;     // DUT output


  task transfer(alu_class_package::tx_in tx);
    @(posedge clk);
    #1ns;
    reset       <= tx.reset;
    load_en       <= tx.load_en;
    operand_a     <= tx.operand_a;
    operand_b     <= tx.operand_b;
    opcode        <= tx.opcode;
  endtask

  task get_an_input(alu_class_package::tx_in tx_input);

    @(posedge clk);
    tx_input.reset         = reset;
    tx_input.load_en       = load_en;
    tx_input.operand_a     = operand_a;
    tx_input.operand_b     = operand_b;
    tx_input.opcode        = opcode;
  endtask

  task get_an_output(alu_class_package::tx_out tx_output);
  
      @(posedge clk);
      #2ns;
      tx_output.instruction = instruction_word;
      
      tx_output.alu_out          = alu_out;
      tx_output.reset            = reset;
      tx_output.opcode           = opcode;
      tx_output.operand_a        = operand_a;
      tx_output.operand_b        = operand_b;
  endtask

endinterface: tb_ifc