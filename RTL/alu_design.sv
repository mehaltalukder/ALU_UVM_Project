/***********************************************************************
 * This file contains an 8-bit ALU design
***********************************************************************/

module alu_design 
  import alu_opcodes_pkg::*;                
  (input logic clk, load_en, reset,
   input   operand_logic_t operand_a, operand_b,
   input   opcode_t opcode,
   output  operand_logic_t alu_out,
   output  instruction_t instruction_word
  );
  timeunit 1ns; timeprecision 1ns;
  operand_logic_t result;
  instruction_t input_store;
  int max;  
  always @ (posedge clk, negedge reset) begin
    max = operand_b[1:0];
    if (!reset) begin 
      result = 8'b0; 
    end
    else if (load_en) begin
      input_store.opc = opcode;
      input_store.op_a = operand_a;
      input_store.op_b = operand_b;

        case (opcode)
          INVERT_A   :  result = ~operand_a;
          NEGATE_A   :  result = -operand_a;
          INCREMENT_A:  result = operand_a + 1'b1;
          A_PLUS_B   :  result = operand_a + operand_b;
          A_MINUS_B  :  result = operand_a - operand_b;
          A_XORED_B  :  result = operand_a ^ operand_b;
          A_SHIFTED_B:  result = operand_a >> max;      // shift operand_b times; max of 3
          A_ROTATED_B:  result = {operand_a,operand_a} >> max;  // rotate operand_b times; max of 3
          default      : $error ("Unexpected opcode = %operand_b", opcode);
        endcase
    end
    
    end
    assign instruction_word = input_store;
    assign alu_out = result;

endmodule: alu_design