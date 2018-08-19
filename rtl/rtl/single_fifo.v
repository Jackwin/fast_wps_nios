`timescale 1ns/1ps

module single_FIFO (
    input           rx_clk,
    input           rx_rst_n,

    input [23:0]    rx_data,
    input           rx_data_valid,
    output reg      rx_ready_out,

    input           tx_clk,
    input           tx_rst_n,
    input           tx_read_in,
    input           wps_send_done_in,
    output          tx_data_ready_out,
    output reg [23:0]   tx_data,
    output reg         tx_valid
);

// ping_fifo signals
wire            ping_fifo_wr_clk;
wire            ping_fifo_arst;
wire             ping_fifo_wr_ena;
wire [23:0]      ping_fifo_din, pong_fifo_dout;
wire            ping_fifo_prefull/*synthesis keep*/;
wire            ping_fifo_rd_clk;
wire             ping_fifo_rd_ena;
wire [23:0]      ping_fifo_dout;
wire            ping_fifo_empty/*synthesis keep*/;
reg             ping_fifo_dout_valid;
reg             ping_fifo_rx_ready;
wire             ping_fifo_tx_ready;
reg 		    pong_fifo_dout_valid;
wire [8:0]      ping_fifo_wr_used/*synthesis keep*/;


reg [31:0]     rd_line_cnt;
reg            tx_read_r1, tx_read_p;
assign ping_fifo_arst = ~rx_rst_n;
assign ping_fifo_wr_clk = rx_clk;
assign ping_fifo_wr_ena = rx_data_valid;
assign ping_fifo_din = rx_data;
assign ping_fifo_prefull = (ping_fifo_wr_used > 9'd500);

assign tx_data_ready_out = ~ping_fifo_empty;
assign ping_fifo_rd_ena = tx_read_in;

assign ping_fifo_rd_clk = tx_clk;

always @(posedge  rx_clk) begin
    rx_ready_out <= ~ping_fifo_prefull;
end

// debug

reg [31:0]  rx_data_cnt;
reg         wps_send_done_sync;
always @(posedge rx_clk) begin
    wps_send_done_sync <= wps_send_done_in;
end

always @(posedge rx_clk) begin
    if(~rx_rst_n | wps_send_done_sync) begin
         rx_data_cnt <= 0;
    end else begin
         if (rx_data_valid) begin
            rx_data_cnt <= rx_data_cnt + 1'd1;
        end
    end
end

altsource_probe #(
    .sld_auto_instance_index ("YES"),
    .sld_instance_index      (0),
    .instance_id             ("RDC"),
    .probe_width             (32),
    .source_width            (0),
    .source_initial_value    ("0"),
    .enable_metastability    ("NO")
) rx_data_cnt_inst (
    .probe (rx_data_cnt)
);

//----------------------------------

always @(posedge tx_clk) begin
    ping_fifo_dout_valid <= ping_fifo_rd_ena;
end

always @(posedge tx_clk) begin
    if (ping_fifo_dout_valid) begin
        tx_valid <= ping_fifo_dout_valid;
        tx_data <= ping_fifo_dout;
    end
    else begin
        tx_valid <= 1'b0;
    end
end
always @(posedge tx_clk) begin
    tx_read_r1 <= tx_read_in;
    tx_read_p <= ~tx_read_r1 & tx_read_in;
end
always @(posedge tx_clk) begin
    if(~tx_rst_n | wps_send_done_in) begin
         rd_line_cnt <= 0;
    end else begin
         if (tx_read_p) begin
            rd_line_cnt <= rd_line_cnt + 1'd1;
        end
    end
end

altsource_probe #(
    .sld_auto_instance_index ("YES"),
    .sld_instance_index      (0),
    .instance_id             ("LIN"),
    .probe_width             (32),
    .source_width            (0),
    .source_initial_value    ("0"),
    .enable_metastability    ("NO")
) ena_inst (
    .probe (rd_line_cnt)
);

dcfifo_24inx512 ping_fifo (
    .data    (ping_fifo_din),    //  fifo_input.datain
    .wrreq   (ping_fifo_wr_ena),   //            .wrreq
    .aclr   (ping_fifo_arst),
    .wrusedw (ping_fifo_wr_used),
    .rdreq   (ping_fifo_rd_ena),   //            .rdreq
    .rdusedw (),
    .wrclk   (ping_fifo_wr_clk),   //            .wrclk
    .rdclk   (ping_fifo_rd_clk),   //            .rdclk
    .q       (ping_fifo_dout),       // fifo_output.dataout
    .rdempty (ping_fifo_empty), //            .rdempty
    .wrfull  ()   //            .wrfull
);



endmodule // singleFIFO