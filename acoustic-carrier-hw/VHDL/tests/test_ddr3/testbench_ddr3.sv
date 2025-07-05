`timescale 1ns / 1ps


module testbench_ddr3;

    // --- Testbench Signals ---
    reg  SYS_CLK = 1'b0;
    reg  RESET_N = 1'b0;

    // --- Wires for DUT connections ---
    wire CK_P, CK_N;
    wire CKE, CS_N, RAS_N, CAS_N, WE_N;
    wire [2:0]  BA;
    wire [15:0] A;
    wire [1:0]  DM;
    // inout ports are wires
    wire [1:0]  DQS_P, DQS_N;
    wire [15:0] DQ;


    PUR PUR_INST(.PUR(1'b1));
	GSR GSR_INST(.GSR(1'b1));

    // --- Instantiate the DUT ---
    lpddr3 dut (
        .SYS_CLK(SYS_CLK),
        .RESET_N(RESET_N),
        .CK_P(CK_P), .CK_N(CK_N),
        .CKE(CKE), .CS_N(CS_N), .RAS_N(RAS_N), .CAS_N(CAS_N), .WE_N(WE_N),
        .BA(BA), .A(A), .DM(DM),
        .DQS_P(DQS_P), .DQS_N(DQS_N),
        .DQ(DQ)
    );

    // --- Clock Generation ---
    // 50 MHz system clock
    always #10 SYS_CLK = ~SYS_CLK;

    // --- Main Sequence ---
    initial begin
        $display("Starting LPDDR3 Stress Test Simulation...");
        
        // Apply reset
        RESET_N = 1'b0;
        #100;
        
        // Release reset
        RESET_N = 1'b1;
        $display("Reset released. Module is running.");
        
        // Let it run for a bit. The real test is not simulation
        // but synthesis and place-and-route.
        #2000;
        
        $display("Simulation finished.");
        $finish;
    end

endmodule
