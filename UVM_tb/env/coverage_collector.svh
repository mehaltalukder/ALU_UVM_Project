`ifndef alu_coverage_collector_exists
`define alu_coverage_collector_exists

class alu_coverage extends uvm_subscriber #(tx_in);

  tx_in tx; 

  covergroup cg_alu_inputs;
    option.per_instance = 1;
    option.name = "cg_alu_inputs";

    op_a: coverpoint tx.operand_a {
          option.weight = 0;
          option.at_least = 64;
          bins quad1  = { [0:63] };
          bins quad2 = { [64:127] };
          bins quad3 = { [128:191] };
          bins quad4 = { [192:255] };
 
    }

    op_b: coverpoint tx.operand_b {
          option.weight = 0;
          option.at_least = 64;
          bins quad1  = { [0:63] };
          bins quad2 = { [64:127] };
          bins quad3 = { [128:191] };
          bins quad4 = { [192:255] };
    }
    
    opc_cov: coverpoint tx.opcode {      
    option.weight = 0;
    }
    AxBxOPC: cross op_a, op_b, opc_cov {

    }
  endgroup: cg_alu_inputs

  `uvm_component_utils(alu_coverage)
  function new(string name, uvm_component parent );
    super.new(name, parent);
    cg_alu_inputs = new();  
  endfunction: new

  function void write(tx_in t);
    tx = t;  
    cg_alu_inputs.sample();
  endfunction: write

  virtual function void report_phase(uvm_phase phase);
    `uvm_info("COVERAGE", $sformatf("\n\n\t Functional coverage = %2.2f%%\n",
                                         cg_alu_inputs.get_inst_coverage()), UVM_NONE)
  endfunction: report_phase

endclass: alu_coverage
`endif