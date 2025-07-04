// ULPI interface

module ulpi (
    // --- ULPI PHY Interface ---
    input  wire       ULPI_CLK,   // Clock from PHY (typically 60 MHz)
    input  wire       ULPI_RST,   // Reset from PHY
    inout  wire [7:0] ULPI_DATA,  // Bidirectional data bus
    input  wire       ULPI_DIR,   // Data bus direction (1: PHY->FPGA, 0: FPGA->PHY)
    input  wire       ULPI_NXT,   // Next data indicator from PHY
    output wire       ULPI_STP,   // Stop signal to PHY

    // --- Application Interface (Example) ---
    output reg [7:0]  DATA_FROM_PHY, // Data received from the PHY
    input  wire [7:0] DATA_TO_PHY,   // Data to be sent to the PHY
    input  wire       TX_VALID       // Assert to send DATA_TO_PHY
);

    // Internal register to hold data that will be driven onto the data bus.
    reg [7:0] data_out_reg;

    // Internal signal to control the tri-state buffer enable.
    // We drive the bus when direction is from FPGA to PHY (dir = 0).
    wire drive_enable;
    assign drive_enable = ~ULPI_DIR;

    // Tri-state buffer for the bidirectional data bus.
    // When drive_enable is high, we drive data_out_reg onto ULPI_DATA.
    // When drive_enable is low, the buffer is high-impedance (Z), allowing the PHY to drive the bus.

    assign ULPI_DATA = (drive_enable) ? data_out_reg : 8'hZZ;

    // Logic to handle data transmission (FPGA -> PHY)
    always @(posedge ULPI_CLK or posedge ULPI_RST) begin
        if (ULPI_RST) begin
            data_out_reg <= 8'h00;
        end else begin
            // When the application layer provides valid data to transmit,
            // we latch it into our output register.
            if (TX_VALID && ~ULPI_DIR) begin
                data_out_reg <= DATA_TO_PHY;
            end
        end
    end

    // Logic to handle data reception (PHY -> FPGA)
    always @(posedge ULPI_CLK or posedge ULPI_RST) begin
        if (ULPI_RST) begin
            DATA_FROM_PHY <= 8'h00;
        end else begin
            // When the PHY is driving the bus (dir=1) and indicates new data (nxt=1),
            // we capture the value from the data bus.
            if (ULPI_DIR && ULPI_NXT) begin
                DATA_FROM_PHY <= ULPI_DATA;
            end
        end
    end

    // Example logic for the 'stp' signal. A real implementation would have
    // a more complex state machine to decide when to assert this.
    // For this example, we will not stop the PHY.
    assign ULPI_STP = 1'b0;

endmodule