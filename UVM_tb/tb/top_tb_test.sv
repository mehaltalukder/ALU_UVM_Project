module top_tb_test;
  timeunit 1ns; timeprecision 1ns;

  import uvm_pkg::*;      
  import alu_class_package::*;   


  initial begin 
    $timeformat(-9,0,"ns",6);

    
    uvm_config_db #(virtual tb_ifc)::set(null, "uvm_test_top", "vif", top_hdl_test.tb_if);
    
    run_test(); //starting the test via the testname switch passed in
  end 

endmodule: top_tb_test