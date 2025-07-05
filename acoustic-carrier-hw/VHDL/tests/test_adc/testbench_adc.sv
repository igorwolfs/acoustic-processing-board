`timescale 1ns / 1ps

// --- Lattice Simulation Primitives ---
// Dummy modules required to simulate Lattice primitives like EHXPLLL.

module testbench_adc;
	PUR PUR_INST(.PUR(1'b1));
	GSR GSR_INST(.GSR(1'b1));
	
    // --- Testbench signals ---
    logic SYS_CLK = 1'b0;
    logic RESET_N = 1'b0;

    // Application Interface wires
    wire [9:0] APP_DATA;
    wire       APP_DATA_VALID;

    // ADC Physical Interface wires/regs
    wire       ADC_CLK;
    logic      ADC_DTR = 1'b0;
    logic [9:0] ADC_D = 10'h0;

    // --- Instantiate the Device Under Test (DUT) ---
    adc_interface dut (
        .SYS_CLK(SYS_CLK),
        .RESET_N(RESET_N),
        .APP_DATA(APP_DATA),
        .APP_DATA_VALID(APP_DATA_VALID),
        .ADC_CLK(ADC_CLK),
        .ADC_DTR(ADC_DTR),
        .ADC_D(ADC_D)
    );

    // --- System Clock Generation (50 MHz) ---
    always #10 SYS_CLK = ~SYS_CLK;

    // --- ADC Emulation Logic ---
    // This block acts as the ADC. It is clocked by the ADC_CLK signal
    // That the DUT generates, and it sends a simple counter value as data.
    always @(posedge ADC_CLK) begin
        // The ADC is only active after the FPGA releases reset
        if (RESET_N == 1'b1) begin
            ADC_DTR <= 1'b1; // Indicate data is valid
            ADC_D   <= ADC_D + 1; // Send a simple incrementing pattern
        end else begin
            ADC_DTR <= 1'b0;
            ADC_D   <= 10'h0;
        end
    end

    // --- Main Test Sequence ---
    initial begin
        $display("----------------------------------------------------");
        $display("Starting ADC Interface Testbench at time %0t", $time);
        $display("----------------------------------------------------");

        // 1. Initialization and Reset
        RESET_N <= 1'b0;
        #100; // Wait for clocks to stabilize
        
        RESET_N <= 1'b1;
        $display("[INFO] Reset released at time %0t", $time);

        // 2. Verification
        // Wait for the DUT to indicate it has received valid data
        wait (APP_DATA_VALID === 1'b1);
        @(posedge ADC_CLK); // Wait one more cycle for data to be stable
        
        $display("[INFO] DUT has captured first valid data at time %0t", $time);

        // Check a few consecutive data points
        for (int i = 0; i < 5; i++) begin
            @(posedge ADC_CLK);
            // We check ADC_D - 1 because the checker is one cycle behind the ADC driver
            if (APP_DATA === (ADC_D - 1)) begin
                $display("[PASS] Correctly received data 0x%h", APP_DATA);
            end else begin
                $error("[FAIL] Expected 0x%h, but got 0x%h", (ADC_D - 1), APP_DATA);
            end
        end

        // 3. End Simulation
        $display("\n----------------------------------------------------");
        $display("Testbench finished at time %0t", $time);
        $display("----------------------------------------------------");
        $finish;
    end

endmodule
