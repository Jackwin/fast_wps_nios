`timescale 1ns/1ps
//Function:
//          1. Adjust the 256-bit input width to 16-bit output width
//          2. The clock at 256-bit side is 125MHz, and the clock at 16-bit side is 250MHz
module interface_256in_24out_gb (
    input               rx_clock,
    input               rx_rst_n,

    input               rx_data_ready_in,
    input [255+32:0]    rx_data,
    input               rx_data_valid,
    output              rx_ready_out,

    input               tx_clock,
    input               tx_rst_n,
    input               wps_send_done_in,
    output reg [23:0]   tx_data,
    output reg          tx_data_valid/*synthesis keep*/,
    input               tx_req_in
);

// l1_fifo signals
wire            l1_fifo_wr_clk;
wire            l1_fifo_wr_ena;
wire [255+32:0] l1_fifo_din/*synthesis keep*/;
wire            l1_fifo_full/*synthesis keep*/;
wire            l1_fifo_pre_full;
wire            l1_fifo_rd_clk;
wire            l1_fifo_rd_ena;
//wire [8:0]      l1_fifo_dout;
wire [17:0]      l1_fifo_dout/*synthesis keep*/;

wire            l1_fifo_empty/*synthesis keep*/;
wire            l1_fifo_rst;
wire [6:0]      l1_fifo_wr_used;
wire [10:0]     l1_fifo_rd_used;
reg             l1_fifo_rd_valid;
wire [255:0]    rx_data_256bit;
wire [31:0]     rx_data_byte_valid;

//output preset_full
assign rx_ready_out = (l1_fifo_wr_used < 7'd120 & ~l1_fifo_full) & rx_data_ready_in;

assign rx_data_256bit = rx_data[287:32];
assign rx_data_byte_valid = rx_data[31:0];

genvar var_i;
generate
    for (var_i = 0; var_i < 16; var_i = var_i + 1) begin :l1_fifo_din_assignment
        assign l1_fifo_din[((var_i + 1)*18 - 1) -: 18] = {rx_data_256bit[((32 - var_i * 2)*8 - 1) -: 8], rx_data_byte_valid[31 - var_i * 2],
                                                          rx_data_256bit[((32 - var_i * 2 - 1)*8 - 1) -: 8], rx_data_byte_valid[31 - var_i * 2 - 1]};
    end

endgenerate

assign l1_fifo_rst = ~rx_rst_n;
assign l1_fifo_wr_ena = rx_data_valid;
assign l1_fifo_wr_clk = rx_clock;

// l1_fifo read logics
assign l1_fifo_rd_clk = tx_clock;
assign l1_fifo_rd_ena = ~l1_fifo_empty & tx_req_in;

always @(posedge tx_clock) begin
    if (~tx_rst_n) begin
        l1_fifo_rd_valid <= 1'b0;
    end
    else begin
        l1_fifo_rd_valid <= l1_fifo_rd_ena;
    end
end

always @(posedge tx_clock) begin
    tx_data_valid <= l1_fifo_rd_valid ? (l1_fifo_dout[0] & l1_fifo_dout[9]): 1'b0;
    tx_data <= {8'h0, l1_fifo_dout[17:10], l1_fifo_dout[8:1]};
end

//dcfifo_288inx128_18out
dcfifo_288inx128_18out l1_fifo (
    .data    (l1_fifo_din),    //  fifo_input.datain
    .wrreq   (l1_fifo_wr_ena),   //            .wrreq
    .aclr    (l1_fifo_rst),
    .wrusedw (l1_fifo_wr_used),
    .rdreq   (l1_fifo_rd_ena),   //            .rdreq
    .wrclk   (l1_fifo_wr_clk),   //            .wrclk
    .rdclk   (l1_fifo_rd_clk),   //            .rdclk
    .q       (l1_fifo_dout),       // fifo_output.dataout
    .rdempty (l1_fifo_empty), //            .rdempty
    .rdusedw (l1_fifo_rd_used),
    .wrfull  (l1_fifo_full)   //            .wrfull
);


endmodule