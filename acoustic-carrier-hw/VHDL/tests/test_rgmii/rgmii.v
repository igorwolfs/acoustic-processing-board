`timescale 1ns / 1ps

//
// RGMII Functional Interface Driver (Lattice ECP5 Verilog)
//
// This module provides a functional RGMII interface, converting the DDR PHY
// signals to a simpler, SDR application interface. This version is specifically
// adapted for Lattice ECP5 FPGAs and uses a dedicated reference clock for the
// transmit path, which is the correct approach for a source-synchronous interface.
//
// It uses IDDRX1F and ODDRX1F primitives to manage the double-data-rate conversion.
//

module rgmii (
    // --- System Inputs ---
    input        RESET_N,        // Active-low reset
    input        ETH_REFCLK,     // 125 MHz reference clock for the TX path

    // --- Application Interface (SDR) ---
    // Note: This interface is synchronous to two different clocks.
    // RX signals are synchronous to RGMII_RX_CLK.
    // TX signals must be synchronous to ETH_REFCLK.
    output [7:0] RX_DATA,        // Received data byte (sync to RGMII_RX_CLK)
    output       RX_DV,          // Received data valid (sync to RGMII_RX_CLK)
    input  [7:0] TX_DATA,        // Transmit data byte (sync to ETH_REFCLK)
    input        TX_DV,          // Transmit data valid (sync to ETH_REFCLK)

    // --- RGMII PHY Interface (DDR) ---
    input        RGMII_RX_CLK,   // 125 MHz clock from PHY
    input        RGMII_RX_CTL,   // Contains RX_DV
    input  [3:0] RGMII_RX_D,

    output       RGMII_TX_CLK,   // 125 MHz clock to PHY (generated from ETH_REFCLK)
    output       RGMII_TX_CTL,   // Contains TX_EN
    output [3:0] RGMII_TX_D,

    // --- Management Interface (Stubbed) ---
    input        MDIO_CLK,
    inout        MDIO_DATA
);

    // --- Internal Signals ---
    wire rst_sync = !RESET_N; // ECP5 primitives use active-high reset


    // --- RX Path (PHY -> FPGA Application, Synchronous to RGMII_RX_CLK) ---
    // Deserialize the DDR RGMII input to an 8-bit SDR bus for the application.
    wire rx_ctl_sdr;
    wire [7:0] rx_data_sdr;

    // Capture RX_CTL (Data Valid) signal using an IDDRX1F primitive.
    IDDRX1F iddrx1f_rx_ctl (
        .D(RGMII_RX_CTL),
        .SCLK(RGMII_RX_CLK), // Clocked by the clock from the PHY
        .RST(rst_sync),
        .Q0(rx_ctl_sdr),     // Data from rising edge
        .Q1()                // Data from falling edge (unused for RX_CTL)
    );

    // Capture the 4-bit DDR data bus into an 8-bit SDR register.
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_iddr_rx
            IDDRX1F iddrx1f_rx_data (
                .D(RGMII_RX_D[i]),
                .SCLK(RGMII_RX_CLK), // Clocked by the clock from the PHY
                .RST(rst_sync),
                .Q0(rx_data_sdr[i]),   // Rising edge data
                .Q1(rx_data_sdr[i+4])  // Falling edge data
            );
        end
    endgenerate

    // Assign deserialized signals to the application interface
    assign RX_DV   = rx_ctl_sdr;
    assign RX_DATA = rx_data_sdr;


    // --- TX Path (FPGA Application -> PHY, Synchronous to ETH_REFCLK) ---
    // Serialize the 8-bit SDR data from the application to the DDR RGMII output.
    // The entire TX path, including the output clock, is driven by ETH_REFCLK.

    // Generate the RGMII_TX_CLK output by forwarding ETH_REFCLK through an ODDR.
    // This ensures the output clock is edge-aligned with the output data at the pins.
    ODDRX1F oddrx1f_tx_clk (
        .D0(1'b1),          // Drive high on rising edge of ETH_REFCLK
        .D1(1'b0),          // Drive low on falling edge of ETH_REFCLK
        .SCLK(ETH_REFCLK),
        .RST(rst_sync),
        .Q(RGMII_TX_CLK)
    );

    // Drive TX_CTL (Transmit Enable) using an ODDRX1F primitive.
    ODDRX1F oddrx1f_tx_ctl (
        .D0(TX_DV),
        .D1(TX_DV),
        .SCLK(ETH_REFCLK),  // Clocked by the internal reference clock
        .RST(rst_sync),
        .Q(RGMII_TX_CTL)
    );

    // Drive the 4-bit DDR data bus from the 8-bit SDR application data.
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_oddr_tx
            ODDRX1F oddrx1f_tx_data (
                .D0(TX_DATA[i]),      // Lower nibble on rising edge
                .D1(TX_DATA[i+4]),    // Upper nibble on falling edge
                .SCLK(ETH_REFCLK),    // Clocked by the internal reference clock
                .RST(rst_sync),
                .Q(RGMII_TX_D[i])
            );
        end
    endgenerate


    // --- MDIO Interface Stub ---
    // Assign to high-impedance as we are not implementing MDIO logic.
    assign MDIO_DATA = 1'bz;

endmodule
