`timescale 1ns / 1ps

// --- Lattice Simulation Primitives ---
// These dummy modules are required to simulate Lattice primitives like
// ODDRX1F, which rely on the global set/reset (GSR) and power-up-reset (PUR)
// signals being present in the simulation hierarchy. These definitions
// satisfy the hierarchical references from the primitive models.

module testbench_rgmii;

    // RGMII clock is 125 MHz -> 8 ns period
    localparam CLK_PERIOD = 8;

    // --- Testbench signals for DUT connection ---
    logic        RESET_N;

    // Application Interface signals
    wire  [7:0]  RX_DATA;
    wire         RX_DV;
    logic [7:0]  TX_DATA = 8'h0;
    logic        TX_DV   = 1'b0;

    // RGMII PHY Interface signals
    logic        RGMII_RX_CLK;
    logic        RGMII_RX_CTL;
    logic [3:0]  RGMII_RX_D;
    wire         RGMII_TX_CLK;
    wire         RGMII_TX_CTL;
    wire  [3:0]  RGMII_TX_D;
    
    // Management Interface signals
    logic        MDIO_CLK;
    wire         MDIO_DATA;

    // --- Instantiate required global primitives for simulation ---
    // The instance names 'GSR_INST' and 'PUR_INST' are often hard-coded
    // in the vendor's simulation models.
	PUR PUR_INST(.PUR(1'b1));
	GSR GSR_INST(.GSR(1'b1));


    // --- Instantiate the Device Under Test (DUT) ---
    // The module name is 'rgmii' as per your provided code
    rgmii dut (
        .RESET_N(RESET_N),

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
    initial begin
        RGMII_RX_CLK = 0;
        forever #(CLK_PERIOD / 2) RGMII_RX_CLK = ~RGMII_RX_CLK;
    end
    
    initial begin
        MDIO_CLK = 0;
        forever #40 MDIO_CLK = ~MDIO_CLK; // ~12.5 MHz
    end

    // --- Testbench Task to send one RGMII byte ---
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

    // --- Application Layer Loopback ---
    // This block emulates the application logic. It waits for valid data from the
    // DUT's RX path and immediately sends it back to the DUT's TX path.
    always @(posedge RGMII_RX_CLK) begin
        if (!RESET_N) begin
            TX_DATA <= 8'h0;
            TX_DV   <= 1'b0;
        end else begin
            TX_DATA <= RX_DATA;
            TX_DV   <= RX_DV;
        end
    end

    // --- Main Test Sequence ---
    initial begin
        $display("----------------------------------------------------");
        $display("Starting RGMII Application Testbench at time %0t", $time);
        $display("----------------------------------------------------");

        // 1. Initialization and Reset
        RESET_N      <= 1'b0;
        RGMII_RX_CTL <= 1'b0;
        RGMII_RX_D   <= 4'hX;
        repeat(5) @(posedge RGMII_RX_CLK);
        
        RESET_N <= 1'b1;
        $display("[INFO] Reset released at time %0t", $time);
        @(posedge RGMII_RX_CLK);

        // 2. Send some data and check the full loopback path
        fork
            begin : data_sender_thread
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
                if (received_on_tx_bus === 8'hA5) $display("[PASS] Correctly looped back 0x%h", received_on_tx_bus);
                else $error("[FAIL] Expected 0xA5, got 0x%h", received_on_tx_bus);

                // Check second byte: B6
                @(posedge RGMII_TX_CLK);
                received_on_tx_bus[3:0] = RGMII_TX_D;
                @(negedge RGMII_TX_CLK);
                received_on_tx_bus[7:4] = RGMII_TX_D;
                if (received_on_tx_bus === 8'hB6) $display("[PASS] Correctly looped back 0x%h", received_on_tx_bus);
                else $error("[FAIL] Expected 0xB6, got 0x%h", received_on_tx_bus);
                
                // Check third byte: C7
                @(posedge RGMII_TX_CLK);
                received_on_tx_bus[3:0] = RGMII_TX_D;
                @(negedge RGMII_TX_CLK);
                received_on_tx_bus[7:4] = RGMII_TX_D;
                if (received_on_tx_bus === 8'hC7) $display("[PASS] Correctly looped back 0x%h", received_on_tx_bus);
                else $error("[FAIL] Expected 0xC7, got 0x%h", received_on_tx_bus);
            end
        join

        // 3. End Simulation
        repeat(10) @(posedge RGMII_RX_CLK);
        $display("\n----------------------------------------------------");
        $display("Testbench finished at time %0t", $time);
        $display("----------------------------------------------------");
        $finish;
    end

endmodule
