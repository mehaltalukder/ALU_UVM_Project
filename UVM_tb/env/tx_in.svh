`ifndef tx_in_exists
`define tx_in_exists

class tx_in extends tx_base;

`uvm_object_utils(tx_in)
function new (string name = "tx_in");
  super.new(name);
endfunction

constraint c_reset   { reset == 1'b1; }
constraint c_load_en { load_en == 1'b1;}
constraint c_operand_a {
    operand_a dist {
        8'h00           :/ 1,
        8'h01           :/ 1,
        [8'h02:8'hfd]   :/ 10,
        8'hfe           :/ 1,
        8'hff           :/ 1
    };
}
constraint c_operand_b {
    operand_b dist {
        8'h00           :/ 1,
        8'h01           :/ 1,
        [8'h02:8'hfd]   :/ 10,
        8'hfe           :/ 1,
        8'hff           :/ 1
    };
}
//constraint c_opcode { opcode == A_ROTATED_B;}


endclass: tx_in
`endif