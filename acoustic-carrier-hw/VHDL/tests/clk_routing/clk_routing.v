`timescale 1ns / 1ps

//
// Top-Level Module for ECP5 FPGA with Multiple Peripherals
//
// This module instantiates and connects:
// - ADC Interface (35 MHz)
// - LPDDR3 Interface (400 MHz)
// - RGMII Ethernet Interface (125 MHz)
// - ULPI USB Interface (60 MHz)
//
// It provides proper clock generation and buffering for all peripherals.
//

module clk_routing (
    // --- Primary System Clock ---
    input         CLK_100MHZ,    // 100 MHz system clock input
    input         RESET_N,       // Active-low system reset

    // --- ADC Interface ---
    output        ADC_CLK,
    input         ADC_DTR,
    input  [9:0]  ADC_D,

    // --- LPDDR3 Interface ---
    output        LPDDR_CLK_P,
    output        LPDDR_CLK_N,
    output        LPDDR_CKE,
    output        LPDDR_CS_N,
    output        LPDDR_RAS_N,
    output        LPDDR_CAS_N,
    output        LPDDR_WE_N,
    output [2:0]  LPDDR_BA,
    output [15:0] LPDDR_A,
    output [1:0]  LPDDR_DM,
    inout  [1:0]  LPDDR_DQS_P,
    inout  [1:0]  LPDDR_DQS_N,
    inout  [15:0] LPDDR_DQ,

    // --- RGMII Ethernet Interface ---
    input         ETH_REFCLK,    // NEW: 125 MHz reference clock for TX
    input         RGMII_RX_CLK,
    input         RGMII_RX_CTL,
    input  [3:0]  RGMII_RX_D,
    output        RGMII_TX_CLK,
    output        RGMII_TX_CTL,
    output [3:0]  RGMII_TX_D,
    input         MDIO_CLK,
    inout         MDIO_DATA,

    // --- ULPI USB Interface ---
    input         ULPI_CLK,
    input         ULPI_RST,
    inout  [7:0]  ULPI_DATA,
    input         ULPI_DIR,
    input         ULPI_NXT,
    output        ULPI_STP
);

    // --- Clock Buffering ---
    // Buffer the primary system clock
    wire clk_100mhz_buf;
    
    // For ECP5, we can use a global clock buffer if needed
    // However, the synthesis tool will automatically infer global buffers
    // for clocks that drive many loads. We'll assign directly for simplicity.
    assign clk_100mhz_buf = CLK_100MHZ;

    // Buffer the RGMII RX clock (125 MHz from PHY)
    wire rgmii_rx_clk_buf;
    assign rgmii_rx_clk_buf = ETH_REFCLK;

    // Buffer the ULPI clock (60 MHz from PHY)
    wire ulpi_clk_buf;
    assign ulpi_clk_buf = ULPI_CLK;

    // --- Reset Synchronization ---
    // Create synchronized resets for each clock domain
    reg [2:0] reset_sync_100mhz = 3'b000;
    reg [2:0] reset_sync_rgmii = 3'b000;
    reg [2:0] reset_sync_ulpi = 3'b000;

    // Reset synchronizer for 100 MHz domain
    always @(posedge clk_100mhz_buf or negedge RESET_N) begin
        if (!RESET_N) begin
            reset_sync_100mhz <= 3'b000;
        end else begin
            reset_sync_100mhz <= {reset_sync_100mhz[1:0], 1'b1};
        end
    end
    wire reset_n_100mhz = reset_sync_100mhz[2];

    // Reset synchronizer for RGMII domain
    always @(posedge rgmii_rx_clk_buf or negedge RESET_N) begin
        if (!RESET_N) begin
            reset_sync_rgmii <= 3'b000;
        end else begin
            reset_sync_rgmii <= {reset_sync_rgmii[1:0], 1'b1};
        end
    end
    wire reset_n_rgmii = reset_sync_rgmii[2];

    // Reset synchronizer for ULPI domain
    always @(posedge ulpi_clk_buf or negedge RESET_N) begin
        if (!RESET_N) begin
            reset_sync_ulpi <= 3'b000;
        end else begin
            reset_sync_ulpi <= {reset_sync_ulpi[1:0], 1'b1};
        end
    end
    wire reset_n_ulpi = reset_sync_ulpi[2];

    // --- PLL Lock Status ---
    wire adc_pll_locked;
    wire lpddr3_pll_locked;
    
    // --- ADC Interface Instantiation ---
    wire [9:0] adc_app_data;
    wire       adc_app_data_valid;

    adc u_adc (
        .SYS_CLK(clk_100mhz_buf),
        .RESET_N(reset_n_100mhz),
        .APP_DATA(adc_app_data),
        .APP_DATA_VALID(adc_app_data_valid),
        .ADC_CLK(ADC_CLK),
        .ADC_DTR(ADC_DTR),
        .ADC_D(ADC_D)
    );

    // Extract PLL lock signal from ADC module
    // Note: This requires access to the internal PLL lock signal
    // In a real design, you might need to modify the ADC module to expose this
    assign adc_pll_locked = 1'b1; // Placeholder - modify ADC module to expose actual lock signal

    // --- LPDDR3 Interface Instantiation ---
    lpddr3 u_lpddr3 (
        .SYS_CLK(clk_100mhz_buf),
        .RESET_N(reset_n_100mhz),
        .CK_P(LPDDR_CLK_P),
        .CK_N(LPDDR_CLK_N),
        .CKE(LPDDR_CKE),
        .CS_N(LPDDR_CS_N),
        .RAS_N(LPDDR_RAS_N),
        .CAS_N(LPDDR_CAS_N),
        .WE_N(LPDDR_WE_N),
        .BA(LPDDR_BA),
        .A(LPDDR_A),
        .DM(LPDDR_DM),
        .DQS_P(LPDDR_DQS_P),
        .DQS_N(LPDDR_DQS_N),
        .DQ(LPDDR_DQ)
    );

    // Extract PLL lock signal from LPDDR3 module
    // Note: This requires access to the internal PLL lock signal
    assign lpddr3_pll_locked = 1'b1; // Placeholder - modify LPDDR3 module to expose actual lock signal

    // --- RGMII Interface Instantiation ---
    wire [7:0] rgmii_rx_data;
    wire       rgmii_rx_dv;
    wire [7:0] rgmii_tx_data;
    wire       rgmii_tx_dv;

    // Simple loopback for demonstration
    assign rgmii_tx_data = rgmii_rx_data;
    assign rgmii_tx_dv = rgmii_rx_dv;

    rgmii u_rgmii (
        .RESET_N(reset_n_rgmii),
        .RX_DATA(rgmii_rx_data),
        .RX_DV(rgmii_rx_dv),
        .TX_DATA(rgmii_tx_data),
        .TX_DV(rgmii_tx_dv),
        .RGMII_RX_CLK(rgmii_rx_clk_buf),
        .RGMII_RX_CTL(RGMII_RX_CTL),
        .RGMII_RX_D(RGMII_RX_D),
        .RGMII_TX_CLK(RGMII_TX_CLK),
        .RGMII_TX_CTL(RGMII_TX_CTL),
        .RGMII_TX_D(RGMII_TX_D),
        .MDIO_CLK(MDIO_CLK),
        .MDIO_DATA(MDIO_DATA),
		.ETH_REFCLK(ETH_REFCLK),
    );

    // --- ULPI Interface Instantiation ---
    wire [7:0] ulpi_data_from_phy;
    wire [7:0] ulpi_data_to_phy;
    wire       ulpi_tx_valid;

    // Simple test pattern generation for ULPI
    reg [7:0] ulpi_counter = 8'h00;
    always @(posedge ulpi_clk_buf) begin
        if (!reset_n_ulpi) begin
            ulpi_counter <= 8'h00;
        end else begin
            ulpi_counter <= ulpi_counter + 1;
        end
    end
    
    assign ulpi_data_to_phy = ulpi_counter;
    assign ulpi_tx_valid = ulpi_counter[0]; // Transmit every other cycle

    ulpi u_ulpi (
        .ULPI_CLK(ulpi_clk_buf),
        .ULPI_RST(ULPI_RST),
        .ULPI_DATA(ULPI_DATA),
        .ULPI_DIR(ULPI_DIR),
        .ULPI_NXT(ULPI_NXT),
        .ULPI_STP(ULPI_STP),
        .DATA_FROM_PHY(ulpi_data_from_phy),
        .DATA_TO_PHY(ulpi_data_to_phy),
        .TX_VALID(ulpi_tx_valid)
    );

    // --- Debug LED Assignments ---
    // --- Additional Clock Domain Crossing (if needed) ---
    // If you need to pass data between clock domains, implement proper
    // clock domain crossing logic here (FIFOs, synchronizers, etc.)

endmodule