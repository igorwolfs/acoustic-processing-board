`timescale 1ns / 1ps

// --- Lattice Simulation Primitives ---
// These dummy modules are required to simulate Lattice primitives like
// ODDRX1F, which rely on the global set/reset (GSR) and power-up-reset (PUR)
// signals being present in the simulation hierarchy. These definitions
// satisfy the hierarchical references from the primitive models.

module testbench_rgmii;
	PUR PUR_INST(.PUR(1'b1));
	GSR GSR_INST(.GSR(1'b1));
	

    // --- Clock Parameters ---
    // RGMII and reference clocks are 125 MHz -> 8 ns period
    localparam CLK_PERIOD = 8;

    // --- Testbench signals for DUT connection ---
    logic        RESET_N;
    
    // External 125 MHz Reference Clock for TX Path
    logic        ETH_REFCLK;

    // Application Interface signals
    wire  [7:0]  RX_DATA;
    wire         RX_DV;
    logic [7:0]  TX_DATA = 8'h0;
    logic        TX_DV   = 1'b0;

    // RGMII PHY Interface signals
    logic        RGMII_RX_CLK;
    logic        RGMII_RX_CTL;
    logic [3:0]  RGMII_RX_D;
    wire         RGMII_TX_CLK; // Driven by the DUT, using ETH_REFCLK as a base
    wire         RGMII_TX_CTL;
    wire  [3:0]  RGMII_TX_D;
    
    // Management Interface signals
    logic        MDIO_CLK;
    wire         MDIO_DATA;


    rgmii dut (
        .RESET_N(RESET_N),

        // External Reference Clock
        .ETH_REFCLK(ETH_REFCLK),

        // Application Interface
        .RX_DATA(RX_DATA),
        .RX_DV(RX_DV),
        .TX_DATA(TX_DATA),
        .TX_DV(TX_DV),

        // RGMII PHY Interface
        .RGMII_RX_CLK(RGMII_RX_CLK),
        .RGMII_RX_CTL(RGMII_RX_CTL),
        .RGMII_RX_D(RGMII_RX_D),
        .RGMII_TX_CLK(RGMII_TX_CLK),
        .RGMII_TX_CTL(RGMII_TX_CTL),
        .RGMII_TX_D(RGMII_TX_D),

        // Management Interface
        .MDIO_CLK(MDIO_CLK),
        .MDIO_DATA(MDIO_DATA)
    );

    // --- Clock Generation ---
    // 1. RGMII RX Clock (from PHY to DUT)
    initial begin
        RGMII_RX_CLK = 0;
        forever #(CLK_PERIOD / 2) RGMII_RX_CLK = ~RGMII_RX_CLK;
    end
    
    // 2. External TX Reference Clock (from external oscillator to DUT)
    initial begin
        ETH_REFCLK = 0;
        // Start with a small offset to avoid perfect alignment with RX_CLK
        #1; 
        forever #(CLK_PERIOD / 2) ETH_REFCLK = ~ETH_REFCLK;
    end

    // 3. MDIO Clock
    initial begin
        MDIO_CLK = 0;
        forever #40 MDIO_CLK = ~MDIO_CLK; // ~12.5 MHz
    end

    // --- Testbench Task to send one RGMII byte (PHY simulation) ---
    task send_rgmii_byte(input [7:0] data);
        @(posedge RGMII_RX_CLK);
        $display("[TB PHY] Sending byte 0x%h at time %0t", data, $time);
        RGMII_RX_CTL <= 1'b1;
        RGMII_RX_D   <= data[3:0]; // Send lower nibble on rising edge

        @(negedge RGMII_RX_CLK);
        RGMII_RX_D   <= data[7:4]; // Send upper nibble on falling edge

        @(posedge RGMII_RX_CLK);
        RGMII_RX_CTL <= 1'b0;      // De-assert valid
        RGMII_RX_D   <= 4'hX;      // Set data to unknown
    endtask

    // --- Application Layer Loopback with Clock Domain Crossing (CDC) ---
    // This logic simulates an application that correctly handles the two
    // separate clock domains: RGMII_RX_CLK and ETH_REFCLK.
    logic [7:0] data_buffer;
    logic       data_valid_flag = 1'b0;

    // Process 1: Capture incoming data from the DUT on the RX clock domain
    always @(posedge RGMII_RX_CLK) begin
        if (RX_DV) begin
            data_buffer     <= RX_DATA;
            data_valid_flag <= 1'b1;
        end
    end

    // Process 2: Send data to the DUT on the TX (reference) clock domain
    always @(posedge ETH_REFCLK) begin
        if (!RESET_N) begin
            TX_DV <= 1'b0;
            data_valid_flag <= 1'b0; // Also reset the flag
        end else if (data_valid_flag) begin
            TX_DATA         <= data_buffer;
            TX_DV           <= 1'b1;
            data_valid_flag <= 1'b0; // Consume the data
        end else begin
            TX_DV <= 1'b0;
        end
    end

    // --- Main Test Sequence ---
    initial begin
        $display("----------------------------------------------------");
        $display("Starting RGMII Application Testbench at time %0t", $time);
        $display("----------------------------------------------------");

        // 1. Initialization and Reset (synchronized to the system's reference clock)
        RESET_N      <= 1'b0;
        RGMII_RX_CTL <= 1'b0;
        RGMII_RX_D   <= 4'hX;
        repeat(5) @(posedge ETH_REFCLK);
        
        RESET_N <= 1'b1;
        $display("[INFO] Reset released at time %0t", $time);
        @(posedge ETH_REFCLK);

        // 2. Send some data and check the full loopback path
        fork
            begin : data_sender_thread
                // Add a small delay to start sending after reset is fully propagated
                @(posedge RGMII_RX_CLK);
                send_rgmii_byte(8'hA5);
                send_rgmii_byte(8'hB6);
                send_rgmii_byte(8'hC7);
            end

            begin : data_checker_thread
                logic [7:0] received_on_tx_bus;

                // Wait for the first valid TX data on the RGMII bus
                wait (RGMII_TX_CTL === 1'b1);
                $display("[TB PHY] Detected RGMII_TX_CTL high at time %0t", $time);

                // Check first byte: A5
                @(posedge RGMII_TX_CLK);
                received_on_tx_bus[3:0] = RGMII_TX_D;
                @(negedge RGMII_TX_CLK);
                received_on_tx_bus[7:4] = RGMII_TX_D;
                if (received_on_tx_bus === 8'hA5) $display("[PASS] ✅ Correctly looped back 0x%h", received_on_tx_bus);
                else $error("[FAIL] ❌ Expected 0xA5, got 0x%h", received_on_tx_bus);

                // Check second byte: B6
                @(posedge RGMII_TX_CLK);
                received_on_tx_bus[3:0] = RGMII_TX_D;
                @(negedge RGMII_TX_CLK);
                received_on_tx_bus[7:4] = RGMII_TX_D;
                if (received_on_tx_bus === 8'hB6) $display("[PASS] ✅ Correctly looped back 0x%h", received_on_tx_bus);
                else $error("[FAIL] ❌ Expected 0xB6, got 0x%h", received_on_tx_bus);
                
                // Check third byte: C7
                @(posedge RGMII_TX_CLK);
                received_on_tx_bus[3:0] = RGMII_TX_D;
                @(negedge RGMII_TX_CLK);
                received_on_tx_bus[7:4] = RGMII_TX_D;
                if (received_on_tx_bus === 8'hC7) $display("[PASS] ✅ Correctly looped back 0x%h", received_on_tx_bus);
                else $error("[FAIL] ❌ Expected 0xC7, got 0x%h", received_on_tx_bus);
            end
        join

        // 3. End Simulation
        repeat(10) @(posedge ETH_REFCLK);
        $display("\n----------------------------------------------------");
        $display("Testbench finished at time %0t", $time);
        $display("----------------------------------------------------");
        $finish;
    end

endmodule
