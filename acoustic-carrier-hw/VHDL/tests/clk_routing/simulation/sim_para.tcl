lappend auto_path "/home/iwolfs/lscc/diamond/3.14/data/script"
package require simulation_generation
set ::bali::simulation::Para(DEVICEFAMILYNAME) {ECP5U}
set ::bali::simulation::Para(PROJECT) {simulation}
set ::bali::simulation::Para(PROJECTPATH) {/home/iwolfs/Work/Projects/electromechanical/acoustic-material-characterization/acoustic-carrier-hw/VHDL/tests/clk_routing}
set ::bali::simulation::Para(FILELIST) {"/home/iwolfs/Work/Projects/electromechanical/acoustic-material-characterization/acoustic-carrier-hw/VHDL/tests/test_ulpi/ulpi.v" "/home/iwolfs/Work/Projects/electromechanical/acoustic-material-characterization/acoustic-carrier-hw/VHDL/tests/test_rgmii/rgmii.v" "/home/iwolfs/Work/Projects/electromechanical/acoustic-material-characterization/acoustic-carrier-hw/VHDL/tests/test_ddr3/ddr3.v" "/home/iwolfs/Work/Projects/electromechanical/acoustic-material-characterization/acoustic-carrier-hw/VHDL/tests/test_adc/adc.v" "/home/iwolfs/Work/Projects/electromechanical/acoustic-material-characterization/acoustic-carrier-hw/VHDL/tests/clk_routing/clk_routing.v" "/home/iwolfs/Work/Projects/electromechanical/acoustic-material-characterization/acoustic-carrier-hw/VHDL/tests/clk_routing/testbench_clk_routing.sv" }
set ::bali::simulation::Para(GLBINCLIST) {}
set ::bali::simulation::Para(INCLIST) {"none" "none" "none" "none" "none" "none"}
set ::bali::simulation::Para(WORKLIBLIST) {"work" "work" "work" "work" "work" "work" }
set ::bali::simulation::Para(COMPLIST) {"VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" "VERILOG" }
set ::bali::simulation::Para(LANGSTDLIST) {"Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "Verilog 2001" "System Verilog" }
set ::bali::simulation::Para(SIMLIBLIST) {pmi_work ovi_ecp5u}
set ::bali::simulation::Para(MACROLIST) {}
set ::bali::simulation::Para(SIMULATIONTOPMODULE) {testbench_clk_routing}
set ::bali::simulation::Para(SIMULATIONINSTANCE) {}
set ::bali::simulation::Para(LANGUAGE) {}
set ::bali::simulation::Para(SDFPATH)  {}
set ::bali::simulation::Para(INSTALLATIONPATH) {/home/iwolfs/lscc/diamond/3.14}
set ::bali::simulation::Para(ADDTOPLEVELSIGNALSTOWAVEFORM)  {1}
set ::bali::simulation::Para(RUNSIMULATION)  {1}
set ::bali::simulation::Para(SIMULATION_RESOLUTION)  {default}
set ::bali::simulation::Para(HDLPARAMETERS) {}
set ::bali::simulation::Para(POJO2LIBREFRESH)    {}
set ::bali::simulation::Para(POJO2MODELSIMLIB)   {}
set ::bali::simulation::Para(OPTIMIZEARGS)  {+acc}
set ::bali::simulation::Para(OPTIMIZATION_DEBUG)  {1}
::bali::simulation::QuestaSim_Run
