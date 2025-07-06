`timescale 1ns / 1ps

//
// ADC Functional Interface for Lattice ECP5
//
// PURPOSE:
// This module provides a functional interface to an external parallel ADC.
// It generates the required 35 MHz clock and captures the incoming SDR data.
// Its primary purpose is to serve as a realistic placeholder for verifying
// the clocking and I/O capabilities of the FPGA for this specific interface.
//
module adc (
    // --- System Inputs ---
    input        SYS_CLK,    // A stable system clock (e.g., 100 MHz)
    input        RESET_N,    // Active-low reset

    // --- Application Interface ---
    output [9:0] APP_DATA,       // Data captured from the ADC
    output       APP_DATA_VALID, // Indicates APP_DATA is valid

    // --- ADC Physical Interface ---
    output       ADC_CLK,      // 35 MHz clock generated for the ADC
    input        ADC_DTR,      // Data ready / Out-of-range signal from ADC
    input  [9:0] ADC_D         // 10-bit data bus from ADC
);

    // --- Clock Generation ---
    wire pll_clk_out; // 35 MHz clock from PLL
    wire pll_locked;
    wire rst = !RESET_N;

    // Instantiate a PLL to generate the 35 MHz ADC clock from a 50 MHz system clock.
    // The (*...*) attributes are for SYNTHESIS.
    // The #(...) parameters are for SIMULATION ONLY. The synthesis tool will ignore them.
    // F_OUT = F_IN * (CLKFB_DIV / CLKI_DIV) / CLKOP_DIV
    // 35MHz = 50MHz * (7 / 10) / 1
    (* FREQUENCY_PIN_CLKI="100.0" *)
    (* FREQUENCY_PIN_CLKOP="35.0" *)
    (* FEEDBACK_PATH="CLKOP" *)
    (* CLKOP_ENABLE="ENABLED" *)

    // EHXPLLL #(
    //    .CLKI_DIV(20),
    //    .CLKFB_DIV(7),
    //    .CLKOP_DIV(1)
    //) pll_inst (
    //    .CLKI(SYS_CLK),
    //    .CLKFB(pll_clk_out),
    //    .CLKOP(pll_clk_out),
    //    .LOCK(pll_locked),
    //    .RST(rst),
    //    .STDBY(1'b0)
    //);
	
	    EHXPLLL #(
        .CLKI_DIV(20),
        .CLKFB_DIV(7),
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

    // Assign the generated clock to the output port
    assign ADC_CLK = pll_clk_out;


    // --- Output Control Signal ---
    // --- Input Data Capture ---
    // Register the incoming data from the ADC on the rising edge of the
    // clock we provide to it. This is a standard SDR capture.
    reg [9:0] app_data_reg;
    reg       app_data_valid_reg;

    always @(posedge ADC_CLK) begin
        if (!pll_locked) begin
            app_data_reg       <= 10'h0;
            app_data_valid_reg <= 1'b0;
        end else begin
            // We assume the ADC data is valid on the same cycle as ADC_DTR is high.
            // A real implementation might need to account for specific timing diagrams.
            app_data_reg       <= ADC_D;
            app_data_valid_reg <= ADC_DTR;
        end
    end

    // Assign registered values to the application interface
    assign APP_DATA       = app_data_reg;
    assign APP_DATA_VALID = app_data_valid_reg;

endmodule