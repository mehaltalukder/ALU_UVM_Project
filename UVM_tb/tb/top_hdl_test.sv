/***********************************************************************
 * SV top-level module that connects the testbench to DUT
 * A dual-top approach has been used to make it emulation friendly
 * The top_hdl (hardware description language) includes the interface and DUT
 **********************************************************************/
module top_hdl_test();
  timeunit 1ns; timeprecision 1ns;
  import alu_opcodes_pkg::*;

  logic clk;

  tb_ifc tb_if (clk);

  alu_design dut (.clk,
                 .load_en(tb_if.load_en),
                 .reset(tb_if.reset),
                 .operand_a(tb_if.operand_a),
                 .operand_b(tb_if.operand_b),
                 .opcode(tb_if.opcode),
                 .alu_out(tb_if.alu_out),
                 .instruction_word(tb_if.instruction_word)
   );

  initial begin
    clk <= 0;
    forever #5ns clk = ~clk;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

endmodule: top_hdl_test