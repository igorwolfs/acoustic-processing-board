`timescale 1ns / 1ps

module rgmii_testbench;

    // RGMII clock is 125 MHz -> 8 ns period
    localparam CLK_PERIOD = 8;

    // --- Testbench signals ---
    logic        RESET_N;
    logic        RGMII_RX_CLK;
    logic        RGMII_RX_CTL;
    logic [3:0]  RGMII_RX_D;
    logic        RGMII_TX_CLK;
    wire         RGMII_TX_CTL; // DUT output
    wire  [3:0]  RGMII_TX_D;   // DUT output
    logic        MDIO_CLK;
    wire         MDIO_DATA;    // inout port

    // --- Instantiate the Device Under Test (DUT) ---
    rgmii dut (
        .RESET_N,
        .RGMII_RX_CLK,
        .RGMII_RX_CTL,
        .RGMII_RX_D,
        .RGMII_TX_CLK,
        .RGMII_TX_CTL,
        .RGMII_TX_D,
        .MDIO_CLK,
        .MDIO_DATA
    );

    // --- Clock Generation ---
    initial begin
        RGMII_RX_CLK = 0;
        RGMII_TX_CLK = 0;
        // In a real system TX and RX clocks might be asynchronous.
        // For this testbench, we'll keep them synchronous for simplicity.
        forever #(CLK_PERIOD / 2) begin
            RGMII_RX_CLK = ~RGMII_RX_CLK;
            RGMII_TX_CLK = ~RGMII_TX_CLK;
        end
    end
    
    // MDIO clock (not critical for this test)
    initial begin
        MDIO_CLK = 0;
        forever #40 MDIO_CLK = ~MDIO_CLK; // ~12.5 MHz
    end

    // --- Testbench Task to send one RGMII byte ---
    task send_rgmii_byte(input [7:0] data);
        @(posedge RGMII_RX_CLK);
        $display("[TB] Sending byte 0x%h at time %0t", data, $time);
        RGMII_RX_CTL <= 1'b1;
        RGMII_RX_D   <= data[3:0]; // Send lower nibble on rising edge

        @(negedge RGMII_RX_CLK);
        RGMII_RX_D   <= data[7:4]; // Send upper nibble on falling edge

        @(posedge RGMII_RX_CLK);
        RGMII_RX_CTL <= 1'b0;      // De-assert valid
        RGMII_RX_D   <= 4'hX;      // Set data to unknown
    endtask

    // --- Main Test Sequence ---
    initial begin
        $display("----------------------------------------------------");
        $display("Starting RGMII Interface Testbench at time %0t", $time);
        $display("----------------------------------------------------");

        // 1. Initialization and Reset
        RESET_N      <= 1'b0;
        RGMII_RX_CTL <= 1'b0;
        RGMII_RX_D   <= 4'hX;
        repeat(5) @(posedge RGMII_RX_CLK);
        
        RESET_N <= 1'b1;
        $display("[INFO] Reset released at time %0t", $time);
        @(posedge RGMII_RX_CLK);

        // 2. Send some data and check the loopback
        fork
            begin : data_sender
                // Send a sequence of bytes
                send_rgmii_byte(8'hA5);
                send_rgmii_byte(8'hB6);
                send_rgmii_byte(8'hC7);
            end

            begin : data_checker
                logic [7:0] expected_byte;
                logic [7:0] received_byte;

                // Wait for the first valid TX data (accounts for DUT latency)
                wait (RGMII_TX_CTL === 1'b1);
                $display("[TB] Detected RGMII_TX_CTL high at time %0t", $time);

                // Check first byte: A5
                expected_byte = 8'hA5;
                @(posedge RGMII_TX_CLK);
                received_byte[3:0] = RGMII_TX_D;
                @(negedge RGMII_TX_CLK);
                received_byte[7:4] = RGMII_TX_D;
                if (received_byte === expected_byte) $display("[PASS] Correctly looped back 0x%h", received_byte);
                else $error("[FAIL] Expected 0x%h, got 0x%h", expected_byte, received_byte);

                // Check second byte: B6
                expected_byte = 8'hB6;
                @(posedge RGMII_TX_CLK);
                received_byte[3:0] = RGMII_TX_D;
                @(negedge RGMII_TX_CLK);
                received_byte[7:4] = RGMII_TX_D;
                if (received_byte === expected_byte) $display("[PASS] Correctly looped back 0x%h", received_byte);
                else $error("[FAIL] Expected 0x%h, got 0x%h", expected_byte, received_byte);
                
                // Check third byte: C7
                expected_byte = 8'hC7;
                @(posedge RGMII_TX_CLK);
                received_byte[3:0] = RGMII_TX_D;
                @(negedge RGMII_TX_CLK);
                received_byte[7:4] = RGMII_TX_D;
                if (received_byte === expected_byte) $display("[PASS] Correctly looped back 0x%h", received_byte);
                else $error("[FAIL] Expected 0x%h, got 0x%h", expected_byte, received_byte);
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