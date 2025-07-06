`timescale 1ns / 1ps

//
// LPDDR3 Clocking Stress Test for Lattice ECP5 (Corrected)
//
// PURPOSE:
// This is NOT a functional LPDDR3 controller. It is a placeholder module
// designed to create the same physical I/O and clocking load as a real
// LPDDR3 interface. Its only goal is to be synthesized and placed-and-routed
// to verify that the target FPGA can handle the clocking resources and pinout.
//
// HOW TO USE:
// 1. Instantiate this module in your top-level design.
// 2. Create a constraints file (.lpf) and assign EVERY port of this module
//    to the exact physical FPGA pins you intend to use for your LPDDR3 chip.
// 3. Run the full implementation flow (Synthesis, Place & Route) in Lattice Diamond.
// 4. If the design passes timing, you have high confidence that the clocking
//    scheme and pinout are viable for a real LPDDR3 IP core.
//
module lpddr3 (
    input        SYS_CLK,    // A stable system clock (e.g., 50 MHz)
    input        RESET_N,    // Active-low reset

    // --- LPDDR3 Interface ---
    // Differential Clock (FPGA -> DRAM)
    output       CK_P,
    output       CK_N,

    // Control Signals (FPGA -> DRAM)
    output       CKE,        // Clock Enable
    output       CS_N,       // Chip Select
    output       RAS_N,      // Row Address Strobe
    output       CAS_N,      // Column Address Strobe
    output       WE_N,       // Write Enable
    output [2:0] BA,         // Bank Address
    output [15:0] A,         // Address

    // Data Bus (Bidirectional)
    output [1:0] DM,         // Data Mask
    inout  [1:0] DQS_P,      // Differential Data Strobe
    inout  [1:0] DQS_N,		
    inout [15:0] DQ          // Data
);

    // --- Clock Generation ---
    wire pll_clk_out; // High-speed clock from PLL (e.g., 400 MHz)
    wire pll_locked;
    wire rst = !RESET_N;

    // Instantiate a PLL to generate the high-speed memory clock.
    // Parameters are now set using attributes, which is the correct Lattice syntax.
    // This example generates a 400 MHz clock from a 50 MHz input.
    // You MUST adjust these parameters to match your system clock and target speed.
    (* FREQUENCY_PIN_CLKI="100.0" *)
    (* FREQUENCY_PIN_CLKOP="400.0" *)
    (* FEEDBACK_PATH="CLKOP" *)
    (* CLKOP_ENABLE="ENABLED" *)
    (* CLKOS_ENABLE="ENABLED" *) // Enable the secondary differential output
	EHXPLLL #(
        .CLKI_DIV(1),
        .CLKFB_DIV(3),
        .CLKOP_DIV(1),
		.CLKOP_DIV(1)
    ) pll_inst (
        .CLKI(SYS_CLK),
        .CLKFB(pll_clk_out),
        .CLKOP(pll_clk_out),
        .LOCK(pll_locked),
        .RST(rst),
        .STDBY(1'b0),

        // --- Explicitly tie unused ports to 0 to remove warnings ---
        .PHASESEL1(1'b0),
        .PHASESEL0(1'b0),
        .PHASEDIR(1'b0),
        .PHASESTEP(1'b0),
        .PHASELOADREG(1'b0),
        .PLLWAKESYNC(1'b0),
        .ENCLKOP(1'b0),
        .ENCLKOS(1'b0),
        .ENCLKOS2(1'b0),
        .ENCLKOS3(1'b0)
    );

	
	
    // For simulation purposes, create the negative clock signal.
    // In hardware, the differential buffer handles this.
    assign CK_N = ~CK_P;


    // --- Toggling Logic ---
    // Simple counters to continuously toggle all outputs, creating activity.
    reg [7:0] toggle_counter = 8'h0;
    always @(posedge pll_clk_out) begin
        if (!pll_locked) begin
            toggle_counter <= 8'h0;
        end else begin
            toggle_counter <= toggle_counter + 1;
        end
    end


    // --- Output Drivers ---
    // Drive all single-ended control/address signals from the toggling logic.
    ODDRX1F oddr_cke_inst (.D0(toggle_counter[0]), .D1(toggle_counter[1]), .SCLK(pll_clk_out), .RST(rst), .Q(CKE));
    ODDRX1F oddr_csn_inst (.D0(toggle_counter[1]), .D1(toggle_counter[2]), .SCLK(pll_clk_out), .RST(rst), .Q(CS_N));
    ODDRX1F oddr_ras_inst (.D0(toggle_counter[2]), .D1(toggle_counter[3]), .SCLK(pll_clk_out), .RST(rst), .Q(RAS_N));
    ODDRX1F oddr_cas_inst (.D0(toggle_counter[3]), .D1(toggle_counter[4]), .SCLK(pll_clk_out), .RST(rst), .Q(CAS_N));
    ODDRX1F oddr_we_inst  (.D0(toggle_counter[4]), .D1(toggle_counter[5]), .SCLK(pll_clk_out), .RST(rst), .Q(WE_N));

    genvar i;
    generate
        for (i=0; i<3; i=i+1) begin : ba_gen
            ODDRX1F oddr_inst (.D0(toggle_counter[i]), .D1(~toggle_counter[i]), .SCLK(pll_clk_out), .RST(rst), .Q(BA[i]));
        end
        for (i=0; i<16; i=i+1) begin : a_gen
            ODDRX1F oddr_inst (.D0(toggle_counter[i%8]), .D1(~toggle_counter[i%8]), .SCLK(pll_clk_out), .RST(rst), .Q(A[i]));
        end
        for (i=0; i<2; i=i+1) begin : dm_gen
            ODDRX1F oddr_inst (.D0(toggle_counter[i]), .D1(~toggle_counter[i]), .SCLK(pll_clk_out), .RST(rst), .Q(DM[i]));
        end
    endgenerate


    // --- Bidirectional Data and Strobe Drivers ---
    // For this test, we will permanently configure them as outputs and drive them.
    wire [15:0] dq_out;
    wire [1:0] dqs_p_out, dqs_n_out;
    
    generate
        // Drive DQ (single-ended) with toggling patterns
        for (i=0; i<16; i=i+1) begin : dq_gen
            ODDRX1F oddr_inst (.D0(toggle_counter[i%8]), .D1(~toggle_counter[i%8]), .SCLK(pll_clk_out), .RST(rst), .Q(dq_out[i]));
        end
        // Drive DQS (differential) using two ODDRX1F instances
        for (i=0; i<2; i=i+1) begin : dqs_gen
             ODDRX1F oddr_dqs_p (.D0(toggle_counter[i]), .D1(~toggle_counter[i]), .SCLK(pll_clk_out), .RST(rst), .Q(dqs_p_out[i]));
             ODDRX1F oddr_dqs_n (.D0(~toggle_counter[i]), .D1(toggle_counter[i]), .SCLK(pll_clk_out), .RST(rst), .Q(dqs_n_out[i]));
        end
    endgenerate

    // Use BB (Bidirectional Buffer) primitives to connect to inout ports
    generate
        for (i=0; i<16; i=i+1) begin : dq_buf
            BB u_bb_dq (.I(dq_out[i]), .O(), .B(DQ[i]), .T(1'b0)); // T=0 means output enabled
        end
        for (i=0; i<2; i=i+1) begin : dqs_buf
            BB u_bb_dqs_p (.I(dqs_p_out[i]), .O(), .B(DQS_P[i]), .T(1'b0));
            BB u_bb_dqs_n (.I(dqs_n_out[i]), .O(), .B(DQS_N[i]), .T(1'b0));
        end
    endgenerate

endmodule
