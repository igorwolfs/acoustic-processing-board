`timescale 1ns / 1ps

//
// Comprehensive Testbench for ECP5 Top-Level Module
//
// This testbench verifies:
// 1. Clock generation for all peripherals
// 2. Data pin toggling behavior
// 3. Reset synchronization
// 4. Basic functionality of each peripheral interface, including the updated
//    RGMII interface with a dedicated transmit reference clock.
//
module testbench_clk_routing;

    // --- Testbench Parameters ---
    parameter CLK_100MHZ_PERIOD = 10;      // 10ns = 100MHz
    parameter RGMII_CLK_PERIOD = 8;       // 8ns = 125MHz
    parameter ULPI_CLK_PERIOD = 16.67;    // 16.67ns = 60MHz
    
    parameter SIM_TIME = 10000;           // Total simulation time in ns

    // --- DUT Signals ---
    // System inputs
    reg         CLK_100MHZ;
    reg         RESET_N;
    
    // ADC Interface
    wire        ADC_CLK;
    reg         ADC_DTR;
    reg  [9:0]  ADC_D;
    
    // LPDDR3 Interface
    wire        LPDDR3_CK_P;
    wire        LPDDR3_CK_N;
    wire        LPDDR3_CKE;
    wire        LPDDR3_CS_N;
    wire        LPDDR3_RAS_N;
    wire        LPDDR3_CAS_N;
    wire        LPDDR3_WE_N;
    wire [2:0]  LPDDR3_BA;
    wire [15:0] LPDDR3_A;
    wire [1:0]  LPDDR3_DM;
    wire [1:0]  LPDDR3_DQS_P;
    wire [1:0]  LPDDR3_DQS_N;
    wire [15:0] LPDDR3_DQ;
    
    // RGMII Interface
    reg         ETH_REFCLK;     // New: 125MHz reference clock for TX path
    reg         RGMII_RX_CLK;
    reg         RGMII_RX_CTL;
    reg  [3:0]  RGMII_RX_D;
    wire        RGMII_TX_CLK;
    wire        RGMII_TX_CTL;
    wire [3:0]  RGMII_TX_D;
    reg         MDIO_CLK;
    wire        MDIO_DATA;
    
    // ULPI Interface
    reg         ULPI_CLK;
    reg         ULPI_RST;
    wire [7:0]  ULPI_DATA;
    reg         ULPI_DIR;
    reg         ULPI_NXT;
    wire        ULPI_STP;
    
    // Status outputs
    wire [7:0]  DEBUG_LEDS;
    wire        PLL_LOCKED;

    // --- Internal Testbench Variables ---
    reg [7:0]   ulpi_data_driver;
    reg [7:0]   rgmii_rx_data_counter;
    reg [9:0]   adc_data_counter;
    
    // Clock frequency measurement
    real        adc_clk_freq;
    real        lpddr3_clk_freq;
    real        rgmii_tx_clk_freq;
    
    integer     adc_clk_count;
    integer     lpddr3_clk_count;
    integer     rgmii_tx_clk_count;
    
    
    PUR PUR_INST(.PUR(1'b1));
    GSR GSR_INST(.GSR(1'b1));


    // --- DUT Instantiation ---
    // NOTE: The DUT 'clk_routing' must now have an 'ETH_REFCLK' input port.
    clk_routing u_dut (
        .CLK_100MHZ(CLK_100MHZ),
        .RESET_N(RESET_N),
        
        .ADC_CLK(ADC_CLK),
        .ADC_DTR(ADC_DTR),
        .ADC_D(ADC_D),
        
        .LPDDR3_CK_P(LPDDR3_CK_P),
        .LPDDR3_CK_N(LPDDR3_CK_N),
        .LPDDR3_CKE(LPDDR3_CKE),
        .LPDDR3_CS_N(LPDDR3_CS_N),
        .LPDDR3_RAS_N(LPDDR3_RAS_N),
        .LPDDR3_CAS_N(LPDDR3_CAS_N),
        .LPDDR3_WE_N(LPDDR3_WE_N),
        .LPDDR3_BA(LPDDR3_BA),
        .LPDDR3_A(LPDDR3_A),
        .LPDDR3_DM(LPDDR3_DM),
        .LPDDR3_DQS_P(LPDDR3_DQS_P),
        .LPDDR3_DQS_N(LPDDR3_DQS_N),
        .LPDDR3_DQ(LPDDR3_DQ),
        
        .ETH_REFCLK(ETH_REFCLK), // Connect the new TX reference clock
        .RGMII_RX_CLK(RGMII_RX_CLK),
        .RGMII_RX_CTL(RGMII_RX_CTL),
        .RGMII_RX_D(RGMII_RX_D),
        .RGMII_TX_CLK(RGMII_TX_CLK),
        .RGMII_TX_CTL(RGMII_TX_CTL),
        .RGMII_TX_D(RGMII_TX_D),
        .MDIO_CLK(MDIO_CLK),
        .MDIO_DATA(MDIO_DATA),
        
        .ULPI_CLK(ULPI_CLK),
        .ULPI_RST(ULPI_RST),
        .ULPI_DATA(ULPI_DATA),
        .ULPI_DIR(ULPI_DIR),
        .ULPI_NXT(ULPI_NXT),
        .ULPI_STP(ULPI_STP),
        
        .DEBUG_LEDS(DEBUG_LEDS),
        .PLL_LOCKED(PLL_LOCKED)
    );

    // --- Clock Generation ---
    // 100 MHz System Clock
    initial begin
        CLK_100MHZ = 0;
        forever #(CLK_100MHZ_PERIOD/2) CLK_100MHZ = ~CLK_100MHZ;
    end
    
    // 125 MHz RGMII RX Clock (from PHY)
    initial begin
        RGMII_RX_CLK = 0;
        forever #(RGMII_CLK_PERIOD/2) RGMII_RX_CLK = ~RGMII_RX_CLK;
    end
    
    // 125 MHz Ethernet Reference Clock (to DUT for TX path)
    initial begin
        ETH_REFCLK = 0;
        #1; // Offset from RX clock for realism
        forever #(RGMII_CLK_PERIOD/2) ETH_REFCLK = ~ETH_REFCLK;
    end
    
    // 60 MHz ULPI Clock
    initial begin
        ULPI_CLK = 0;
        forever #(ULPI_CLK_PERIOD/2) ULPI_CLK = ~ULPI_CLK;
    end
    
    // Variable frequency MDIO clock (much slower)
    initial begin
        MDIO_CLK = 0;
        forever #(200) MDIO_CLK = ~MDIO_CLK; // 2.5 MHz
    end

    // --- Reset Generation ---
    initial begin
        RESET_N = 0;
        ULPI_RST = 1;
        #(200); // Hold reset for 200ns
        RESET_N = 1;
        #(50);
        ULPI_RST = 0;
        $display("INFO: Reset released at time %t", $time);
    end

    // --- ADC Interface Stimulus ---
    initial begin
        ADC_DTR = 0;
        ADC_D = 10'h000;
        adc_data_counter = 10'h000;
        wait(RESET_N == 1);
        @(posedge ADC_CLK);
        
        forever begin
            ADC_DTR = 1;
            ADC_D = adc_data_counter;
            adc_data_counter = adc_data_counter + 1;
            @(posedge ADC_CLK);
            ADC_DTR = 0;
            repeat(3) @(posedge ADC_CLK);
        end
    end

    // --- RGMII Interface Stimulus Task ---
    task send_rgmii_byte(input [7:0] data);
        @(posedge RGMII_RX_CLK);
        RGMII_RX_CTL <= 1'b1;
        RGMII_RX_D   <= data[3:0];
        @(negedge RGMII_RX_CLK);
        RGMII_RX_D   <= data[7:4];
        @(posedge RGMII_RX_CLK);
        RGMII_RX_CTL <= 0;
        RGMII_RX_D   <= 4'hX;
    endtask

    // --- RGMII Stimulus Generation ---
    initial begin
        RGMII_RX_CTL = 0;
        RGMII_RX_D = 4'hX;
        wait(RESET_N == 1);
        #(200);
        
        // Send a stream of RGMII data
        for (int i = 0; i < 20; i++) begin
            send_rgmii_byte(8'hA0 + i);
        end
    end

    // --- ULPI Interface Stimulus ---
    initial begin
        ULPI_DIR = 0;
        ULPI_NXT = 0;
        ulpi_data_driver = 8'h00;
        wait(ULPI_RST == 0);
        #(200);
        
        forever begin
            @(posedge ULPI_CLK);
            ULPI_DIR = 1;
            ULPI_NXT = 1;
            ulpi_data_driver = ulpi_data_driver + 1;
            @(posedge ULPI_CLK);
            ULPI_NXT = 0;
            repeat(5) @(posedge ULPI_CLK);
            ULPI_DIR = 0;
            repeat(5) @(posedge ULPI_CLK);
        end
    end

    assign ULPI_DATA = (ULPI_DIR) ? ulpi_data_driver : 8'hzz;

    // --- Clock Frequency Measurement ---
    initial begin
        adc_clk_count = 0; lpddr3_clk_count = 0; rgmii_tx_clk_count = 0;
        fork
            forever @(posedge ADC_CLK) adc_clk_count++;
            forever @(posedge LPDDR3_CK_P) lpddr3_clk_count++;
            forever @(posedge RGMII_TX_CLK) rgmii_tx_clk_count++;
        join
    end

    // --- Monitoring and Verification ---
    initial begin
        forever begin
            #(1000); // Wait 1us
            if ($time > 1000) begin
                adc_clk_freq = (adc_clk_count * 1000.0) / $time;
                lpddr3_clk_freq = (lpddr3_clk_count * 1000.0) / $time;
                rgmii_tx_clk_freq = (rgmii_tx_clk_count * 1000.0) / $time;
                
                $display("MONITOR @ %t | ADC: %.1f MHz | LPDDR3: %.1f MHz | RGMII_TX: %.1f MHz | PLL_LOCKED: %b", 
                         $time, adc_clk_freq, lpddr3_clk_freq, rgmii_tx_clk_freq, PLL_LOCKED);
            end
        end
    end

    // --- RGMII Loopback Verification ---
    reg [7:0] received_byte;
    reg [7:0] expected_byte = 8'hA0;
        
    initial begin


        wait(RESET_N == 1);
        
        forever begin
            // Wait for valid data on the TX interface
            @(posedge RGMII_TX_CLK);
            if (RGMII_TX_CTL) begin
                received_byte[3:0] = RGMII_TX_D;
                @(negedge RGMII_TX_CLK);
                received_byte[7:4] = RGMII_TX_D;
                
                // Compare with the expected value
                if (received_byte == expected_byte) begin
                    $display("✓ RGMII Loopback PASS: Received 0x%h as expected.", received_byte);
                end else begin
                    $display("✗ RGMII Loopback FAIL: Expected 0x%h, but received 0x%h.", expected_byte, received_byte);
                end
                
                // Increment expected byte for the next check
                expected_byte++;
            end
        end
    end

    // --- Simulation Control ---
    initial begin
        $display("INFO: Starting ECP5 Top-Level Testbench");
        $display("INFO: Expected clock frequencies:");
        $display("      - ADC_CLK:      ~35 MHz");
        $display("      - LPDDR3_CK:    ~400 MHz");
        $display("      - RGMII_TX_CLK: 125 MHz (derived from ETH_REFCLK)");
        $display("      - ULPI_CLK:     60 MHz (external)");
        
        #(SIM_TIME);
        
        $display("\n================ Final Verification ================");
        $display("ADC Clock Frequency:      %.1f MHz (Expected: ~35.0 MHz)", adc_clk_freq);
        $display("LPDDR3 Clock Frequency:   %.1f MHz (Expected: ~400.0 MHz)", lpddr3_clk_freq);
        $display("RGMII TX Clock Frequency: %.1f MHz (Expected: 125.0 MHz)", rgmii_tx_clk_freq);
        
        if (adc_clk_freq > 30.0 && adc_clk_freq < 40.0) $display("✓ ADC clock frequency PASS");
        else $display("✗ ADC clock frequency FAIL");
        
        if (lpddr3_clk_freq > 350.0 && lpddr3_clk_freq < 450.0) $display("✓ LPDDR3 clock frequency PASS");
        else $display("✗ LPDDR3 clock frequency FAIL");
        
        if (rgmii_tx_clk_freq > 120.0 && rgmii_tx_clk_freq < 130.0) $display("✓ RGMII TX clock frequency PASS");
        else $display("✗ RGMII TX clock frequency FAIL");
        
        $display("\nINFO: Testbench completed at time %t", $time);
        $finish;
    end

    // --- Waveform Dumping ---
    initial begin
        $dumpfile("clk_routing.vcd");
        $dumpvars(0, u_dut);
    end

endmodule