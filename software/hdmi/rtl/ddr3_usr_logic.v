`timescale 1ns/1ps
// Function:
// 1. According the received command/parameter from wps_controller.v to read DDR3
// Dataflow: DDR3 -> Logic -> DDR3 FIFO -> output
/*

*/

module ddr3_usr_logic (
    // DDR3 signals
    input               ddr3_emif_clk,
    input               ddr3_emif_rst_n,
    input               ddr3_emif_ready,
    input [255:0]       ddr3_emif_read_data,
    input               ddr3_emif_rddata_valid,
    output reg          ddr3_emif_read,
    output reg          ddr3_emif_write,
    output reg [24:0]   ddr3_emif_addr,
    output reg [255:0]  ddr3_emif_write_data,
    output reg [31:0]   ddr3_emif_byte_enable,
    output reg [4:0]    ddr3_emif_burst_count,

    // command/paramter
    input [31:0]        ddr3_usr_start_addr_in,
    input [31:0]        to_read_frame_num_in,
    input [31:0]        to_read_byte_in,
    input [31:0]        one_frame_byte_in,
    input               ddr3_read_start,
    output              ddr3_read_done_out,

    // Output interface
    input               read_req_in,
    output              data_ready_out,
    output [255+32:0]   read_data_out,
    output              read_data_valid_out
);

localparam  IDLE = 3'd0,
            FIRST_READ = 3'd1,
            READ = 3'd2,
            WAIT = 3'd3,
            LAST_READ = 3'd4;
reg [2:0]   state;
//Register
reg [31:0]  to_read_frame_reg;
reg [31:0]  to_read_byte_reg;
reg [4:0]   ddr3_usr_offset_addr_reg;
reg [31:0]  one_frame_byte_reg;
reg [31:0]  one_frame_left_byte_reg;

// DDR3 signals
reg [31:0]  ddr3_data_byte_valid;
reg [24:0]  ddr3_emif_start_addr_reg;
reg [12:0]  ddr3_read_valid_r;
wire        ddr3_read_data_valid;
reg         ddr3_read_start_reg;
reg         read_done;
wire[255:0] ddr3_read_data_swap;
wire [31:0] ddr3_data_byte_valid_swap;

reg [255+32:0]    fifo_din;
reg                 fifo_wr_ena;
wire                fifo_full/*synthesis keep*/;
wire                fifo_clk;
wire                fifo_rd_ena;
wire                fifo_empty/*synthesis keep*/;
wire [255+32:0]   fifo_dout;
reg                 fifo_dout_valid;

// Output
assign ddr3_read_done_out = read_done;
assign data_ready_out = ~fifo_empty;
assign read_data_out = fifo_dout;
assign read_data_valid_out = fifo_dout_valid;
//Generate ddr3 read valid signal and the delay is 13 clock cycles
always @(posedge ddr3_emif_clk) begin
    ddr3_read_valid_r[12:0] <= {ddr3_read_valid_r[11:0], ddr3_emif_read};
end
assign ddr3_read_data_valid = ddr3_read_valid_r[12];

// FIFO
assign fifo_clk = ddr3_emif_clk;
assign fifo_rd_ena = read_req_in;

always @(posedge ddr3_emif_clk) begin
    if (~ddr3_emif_rst_n) begin
        fifo_dout_valid <= 1'b0;
    end
    else begin
        fifo_dout_valid <= fifo_rd_ena & ~fifo_empty;
    end
end

// Convert little-endian to big-endian

assign ddr3_read_data_swap[255:224] = ddr3_emif_read_data[31:0];
assign ddr3_read_data_swap[223:192] = ddr3_emif_read_data[63:32];
assign ddr3_read_data_swap[191:160] = ddr3_emif_read_data[95:64];
assign ddr3_read_data_swap[159:128] = ddr3_emif_read_data[127:96];
assign ddr3_read_data_swap[127:96] = ddr3_emif_read_data[159:128];
assign ddr3_read_data_swap[95:64] = ddr3_emif_read_data[191:160];
assign ddr3_read_data_swap[63:32] = ddr3_emif_read_data[223:192];
assign ddr3_read_data_swap[31:0] = ddr3_emif_read_data[255:224];

assign ddr3_data_byte_valid_swap[31:28] = ddr3_data_byte_valid[3:0];
assign ddr3_data_byte_valid_swap[27:24] = ddr3_data_byte_valid[7:4];
assign ddr3_data_byte_valid_swap[23:20] = ddr3_data_byte_valid[11:8];
assign ddr3_data_byte_valid_swap[19:16] = ddr3_data_byte_valid[15:12];
assign ddr3_data_byte_valid_swap[15:12] = ddr3_data_byte_valid[19:16];
assign ddr3_data_byte_valid_swap[11:8] = ddr3_data_byte_valid[23:20];
assign ddr3_data_byte_valid_swap[7:4] = ddr3_data_byte_valid[27:24];
assign ddr3_data_byte_valid_swap[3:0] = ddr3_data_byte_valid[31:28];


// 256-bit DDR3 data
// Byte address: 0 -> 31
always @(posedge ddr3_emif_clk) begin
    if(~ddr3_emif_rst_n) begin
        to_read_frame_reg <= 0;
        ddr3_usr_offset_addr_reg <= 'h0;
        ddr3_emif_start_addr_reg <= 'h0;
        one_frame_byte_reg <= 'h0;
        read_done <= 1'b0;
        ddr3_emif_addr <= 0;
        ddr3_emif_read <= 0;
        ddr3_emif_write <= 0;
        fifo_wr_ena <= 1'b0;
        state <= IDLE;
        ddr3_read_start_reg <= 1'b0;
    end else begin
        ddr3_emif_read <= 1'b0;
        fifo_wr_ena <= 1'b0;
        read_done <= 1'b0;
        case(state)
            IDLE: begin
                if (ddr3_read_start) begin
                    ddr3_read_start_reg <= 1'b1;
                    $display("ddr3_usr_logic: start to read DDR3");
                    to_read_frame_reg <= to_read_frame_num_in;
                    to_read_byte_reg <= to_read_byte_in;
                    one_frame_byte_reg <= one_frame_byte_in;
                    one_frame_left_byte_reg <= one_frame_byte_in;
                    ddr3_emif_start_addr_reg <= ddr3_usr_start_addr_in[29:5];
                    ddr3_usr_offset_addr_reg <= ddr3_usr_start_addr_in[4:0];
                    case(ddr3_usr_start_addr_in[4:0])
                        5'd0:ddr3_data_byte_valid <= 32'hffffffff;
                        5'd1:ddr3_data_byte_valid <= 32'h7fffffff;
                        5'd2:ddr3_data_byte_valid <= 32'h3fffffff;
                        5'd3:ddr3_data_byte_valid <= 32'h1fffffff;
                        5'd4:ddr3_data_byte_valid <= 32'h0fffffff;
                        5'd5:ddr3_data_byte_valid <= 32'h07ffffff;
                        5'd6:ddr3_data_byte_valid <= 32'h03ffffff;
                        5'd7:ddr3_data_byte_valid <= 32'h01ffffff;
                        5'd8:ddr3_data_byte_valid <= 32'h00ffffff;
                        5'd9:ddr3_data_byte_valid <= 32'h007fffff;
                        5'd10:ddr3_data_byte_valid <= 32'h003fffff;
                        5'd11:ddr3_data_byte_valid <= 32'h001fffff;
                        5'd12:ddr3_data_byte_valid <= 32'h000fffff;
                        5'd13:ddr3_data_byte_valid <= 32'h0007ffff;
                        5'd14:ddr3_data_byte_valid <= 32'h0003ffff;
                        5'd15:ddr3_data_byte_valid <= 32'h0001ffff;
                        5'd16:ddr3_data_byte_valid <= 32'h0000ffff;
                        5'd17:ddr3_data_byte_valid <= 32'h00007fff;
                        5'd18:ddr3_data_byte_valid <= 32'h00003fff;
                        5'd19:ddr3_data_byte_valid <= 32'h00001fff;
                        5'd20:ddr3_data_byte_valid <= 32'h00000fff;
                        5'd21:ddr3_data_byte_valid <= 32'h000007ff;
                        5'd22:ddr3_data_byte_valid <= 32'h000003ff;
                        5'd23:ddr3_data_byte_valid <= 32'h000001ff;
                        5'd24:ddr3_data_byte_valid <= 32'h000000ff;
                        5'd25:ddr3_data_byte_valid <= 32'h0000007f;
                        5'd26:ddr3_data_byte_valid <= 32'h0000003f;
                        5'd27:ddr3_data_byte_valid <= 32'h0000001f;
                        5'd28:ddr3_data_byte_valid <= 32'h0000000f;
                        5'd29:ddr3_data_byte_valid <= 32'h7;
                        5'd30:ddr3_data_byte_valid <= 32'h3;
                        5'd31:ddr3_data_byte_valid <= 32'h1;
                    endcase // ddr3_usr_start_addr_in[4:0]
                end

                if (ddr3_read_start_reg & ddr3_emif_ready) begin
                    state <= FIRST_READ;
                    ddr3_read_start_reg <= 1'b0;
                end
            end
            FIRST_READ: begin
                if (~fifo_full) begin
                    ddr3_emif_read <= 1'b1;
                    ddr3_emif_addr <= ddr3_emif_start_addr_reg;
                    one_frame_left_byte_reg <= one_frame_left_byte_reg - 6'd32 + ddr3_usr_start_addr_in[4:0];
                    to_read_byte_reg <= to_read_byte_reg - 6'd32 + ddr3_usr_start_addr_in[4:0];
                    if (ddr3_emif_ready)
                        state <= WAIT;
                end
            end
            /*
            FIRST_WAIT: begin
                if (ddr3_read_data_valid) begin
                    fifo_wr_ena <= 1'b1;
                    fifo_din <= {ddr3_emif_read_data, ddr3_data_byte_valid};
                    ddr3_emif_addr <= ddr3_emif_addr + 1'd1;
                    if (to_read_byte_reg == 'h0) begin
                        read_done <= 1'b1;
                        state <= IDLE;
                    end
                    else if (to_read_byte_reg < 6'd32) begin
                        state <= LAST_READ;
                    end
                    else begin
                        state <= READ;
                    end
                end
            end
            */
            READ: begin
                if (~fifo_full) begin
                    ddr3_data_byte_valid <= 32'hffffffff;
                    ddr3_emif_read <= 1'b1;
                    one_frame_left_byte_reg <= one_frame_left_byte_reg - 6'd32;
                    to_read_byte_reg <= to_read_byte_reg - 6'd32;
                    if (ddr3_emif_ready)
                        state <= WAIT;
                end
            end
            WAIT: begin
                if (ddr3_emif_rddata_valid) begin
                    fifo_wr_ena <= 1'b1;
                    //fifo_din <= {ddr3_emif_read_data, ddr3_data_byte_valid};
                    fifo_din <= {ddr3_read_data_swap, ddr3_data_byte_valid_swap};

                    // Deal with the boundary of two sectors
                    if (ddr3_emif_addr[20:0] == 21'h1fa3ff) begin
                        ddr3_emif_addr[20:0] <= 'h0;
                        ddr3_emif_addr[24:21] <= ddr3_emif_addr[24:21] + 1'd1;
                    end // if (ddr3_emif_addr[20:0] == 21'h1fa3ff)
                    else
                        ddr3_emif_addr <= ddr3_emif_addr + 1'd1;

                    if (to_read_byte_reg == 'h0) begin
                        read_done <= 1'b1;
                        state <= IDLE;
                    end
                    else if (to_read_byte_reg < 6'd32) begin
                        state <= LAST_READ;
                    end
                    else begin
                        state <= READ;
                    end
                end
            end
            LAST_READ: begin
                if (~fifo_full) begin
                    ddr3_emif_read <= 1'b1;
                    $display("ddr3_usr_logic: start to last read DDR3");
                    //ddr3_emif_addr <= ddr3_emif_addr + 1'd1;
                    case(to_read_byte_reg[4:0])
                        5'd0: ddr3_data_byte_valid <= 32'h0;
                        5'd1: ddr3_data_byte_valid <= 32'h80000000;
                        5'd2: ddr3_data_byte_valid <= 32'hc0000000;
                        5'd3: ddr3_data_byte_valid <= 32'he0000000;
                        5'd4: ddr3_data_byte_valid <= 32'hf0000000;
                        5'd5: ddr3_data_byte_valid <= 32'hf8000000;
                        5'd6: ddr3_data_byte_valid <= 32'hfc000000;
                        5'd7: ddr3_data_byte_valid <= 32'hfe000000;
                        5'd8: ddr3_data_byte_valid <= 32'hff000000;
                        5'd9: ddr3_data_byte_valid <= 32'hff800000;
                        5'd10:ddr3_data_byte_valid <= 32'hffc00000;
                        5'd11:ddr3_data_byte_valid <= 32'hffe00000;
                        5'd12:ddr3_data_byte_valid <= 32'hfff00000;
                        5'd13:ddr3_data_byte_valid <= 32'hfff80000;
                        5'd14:ddr3_data_byte_valid <= 32'hfffc0000;
                        5'd15:ddr3_data_byte_valid <= 32'hfffe0000;
                        5'd16:ddr3_data_byte_valid <= 32'hffff0000;
                        5'd17:ddr3_data_byte_valid <= 32'hffff8000;
                        5'd18:ddr3_data_byte_valid <= 32'hffffc000;
                        5'd19:ddr3_data_byte_valid <= 32'hffffe000;
                        5'd20:ddr3_data_byte_valid <= 32'hfffff000;
                        5'd21:ddr3_data_byte_valid <= 32'hfffff800;
                        5'd22:ddr3_data_byte_valid <= 32'hfffffc00;
                        5'd23:ddr3_data_byte_valid <= 32'hfffffe00;
                        5'd24:ddr3_data_byte_valid <= 32'hffffff00;
                        5'd25:ddr3_data_byte_valid <= 32'hffffff80;
                        5'd26:ddr3_data_byte_valid <= 32'hffffffc0;
                        5'd27:ddr3_data_byte_valid <= 32'hffffffe0;
                        5'd28:ddr3_data_byte_valid <= 32'hfffffff0;
                        5'd29:ddr3_data_byte_valid <= 32'hfffffff8;
                        5'd30:ddr3_data_byte_valid <= 32'hfffffffc;
                        5'd31:ddr3_data_byte_valid <= 32'hfffffffe;
                    endcase
                    to_read_byte_reg <= 'h0;
                    if (ddr3_emif_ready)
                        state <= WAIT;
                end
            end
            default: state <= IDLE;
        endcase // to_read_byte_reg[4:0]
    end
end

scfifo_288inx128 ddr3_fifo (
    .data  (fifo_din),  //  fifo_input.datain
    .wrreq (fifo_wr_ena), //            .wrreq
    .sclr  (~ddr3_emif_rst_n),
    .rdreq (fifo_rd_ena), //            .rdreq
    .clock (fifo_clk), //            .clk
    .q     (fifo_dout),     // fifo_output.dataout
    //.usedw (), //            .usedw
    //.full  (),  //            .full
    .almost_full(fifo_full),
    .empty (fifo_empty)  //            .empty
);



endmodule