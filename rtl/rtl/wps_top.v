`timescale 1ns/1ps
`define GB 1
module wps_top (
    input               mem_clk,
    input               mem_rst_n,

    input               ddr3_emif_ready,
    input [255:0]       ddr3_emif_read_data,
    input               ddr3_emif_rddata_valid,
    output              ddr3_emif_read,
    output              ddr3_emif_write,
    output  [24:0]      ddr3_emif_addr,
    output  [255:0]     ddr3_emif_write_data,
    output  [31:0]      ddr3_emif_byte_enable,
    output  [4:0]       ddr3_emif_burst_count,

    output              onchip_mem_chip_select,
    output              onchip_mem_clk_ena,
    output [12:0]       onchip_mem_addr,
    output [31:0]       onchip_mem_byte_enable,
    output [255:0]      onchip_mem_write_data,
    output              onchip_mem_write,
    input [255:0]       onchip_mem_read_data,

    output              wps_send_done,

    input               clk250m,
    input               clk250m_rst_n,

    input               clk148_5m,
    input               clk148_5m_rst_n,
    output              h_sync_out,
    output              v_sync_out,
    output              de_out,
    output  [23:0]      pix_data_out,
    output              capture_pulse_out

);
wire [31:0]     usr_start_addr;
wire [31:0]     to_read_byte;
wire [31:0]     to_read_frame_num;
wire [31:0]     one_frame_byte;
wire [31:0]     capture_pulse_cycle;

wire            ddr3_read_start;
wire            ddr3_read_done;
wire            onchip_mem_read_start;
wire            onchip_mem_read_done;
wire [1:0]      wps_send_start;
//onchip_mem_usr_logic
reg             onchip_mem_usr_logic_read_req;
wire            onchip_mem_usr_logic_data_ready;
wire [255+32:0] onchip_mem_usr_logic_read_data;
wire            onchip_mem_usr_logic_read_data_valid;
wire            onchip_mem_usr_logic_read;
reg             onchip_mem_usr_logic_read_r;
reg             onchip_mem_usr_logic_read_valid;
wire            onchip_mem_usr_logic_chip_select;
wire [12:0]     onchip_mem_usr_logic_addr;
wire            onchip_mem_usr_clk_ena;
// wps_controller
wire            onchip_mem_wps_controller_read;
reg             onchip_mem_wps_controller_read_r;
reg             onchip_mem_wps_controller_read_valid;
wire            onchip_mem_wps_controller_chip_select;
wire [12:0]     onchip_mem_wps_controller_addr;
wire            onchip_mem_wps_controller_clk_ena;

// ddr3_usr_logic signals
reg             ddr3_usr_logic_read_req;
wire            ddr3_usr_logic_data_ready;
wire [255+32:0] ddr3_usr_logic_read_data;
wire            ddr3_usr_logic_read_data_valid;

// interface_256in_24out signals
reg [255+32:0]  interface_rx_data;
reg             interface_rx_data_valid;
wire            interface_rx_ready;
wire [23:0]     interface_tx_data;
wire            interface_tx_data_valid;
wire            interface_tx_req;
wire             interface_rx_data_ready;

// pingpongFIFO signals
wire        pingpongFIFO_ready;
wire        pingpongFIFO_read;
wire [23:0] pingpongFIFO_data;
wire        pingpongFIFO_data_valid;


// wps_send signals
wire           h_sync_hdmi, v_sync_hdmi, de_hdmi;
wire           de_o_first_offset_line;
wire [23:0]    display_vedio_left_offset;
wire           frame_start_trig;
wire           frame_busy;
wire           hsync_o_with_camera_format;//active high
wire           vsync_o_with_camera_format;//active low
wire           de_o;//active high
wire           hsync_o_with_hdmi_format;
wire           vsync_o_with_hdmi_format;
wire           de_o_with_hdmi_format;
wire [10:0]    frame_count;
wire            one_frame_send_done;
wire            wps_send_done;
wire            de_first_offset_line_out;

wire            de_out_wire;
wire            de_first_offset_line_out_wire;
wire            h_sync_out_wire;
wire            v_sync_out_wire;
wire [23:0]     pix_data_out_wire;

ddr3_usr_logic ddr3_usr_logic_inst (
    .ddr3_emif_clk         (mem_clk),
    .ddr3_emif_rst_n       (mem_rst_n),
    .ddr3_emif_ready       (ddr3_emif_ready),
    .ddr3_emif_read_data   (ddr3_emif_read_data),
    .ddr3_emif_rddata_valid(ddr3_emif_rddata_valid),
    .ddr3_emif_read        (ddr3_emif_read),
    .ddr3_emif_write       (ddr3_emif_write),
    .ddr3_emif_addr        (ddr3_emif_addr),
    .ddr3_emif_write_data  (ddr3_emif_write_data),
    .ddr3_emif_byte_enable (ddr3_emif_byte_enable),
    .ddr3_emif_burst_count (ddr3_emif_burst_count),

    // To wps_controller.v
    .ddr3_usr_start_addr_in(usr_start_addr),
    .to_read_frame_num_in  (to_read_frame_num),
    .to_read_byte_in       (to_read_byte),
    .one_frame_byte_in     (one_frame_byte),
    .ddr3_read_start       (ddr3_read_start),
    .ddr3_read_done_out    (ddr3_read_done),

    //interface_256in_24out.v
    .read_req_in           (ddr3_usr_logic_read_req),
    .data_ready_out        (ddr3_usr_logic_data_ready),
    .read_data_out         (ddr3_usr_logic_read_data),
    .read_data_valid_out   (ddr3_usr_logic_read_data_valid)
);

assign onchip_mem_clk_ena = 1'b1;
onchip_mem_usr_logic onchip_mem_usr_logic_inst (
    .clk                     (mem_clk),
    .rst_n                   (mem_rst_n),
    .onchip_mem_chip_select  (onchip_mem_usr_logic_chip_select),
    .onchip_mem_clk_ena      (),
    .onchip_mem_addr         (onchip_mem_usr_logic_addr),
    .onchip_mem_read         (onchip_mem_usr_logic_read),
    .onchip_mem_read_valid   (onchip_mem_usr_logic_read_valid),
    .onchip_mem_read_data    (onchip_mem_read_data),

    .onchip_mem_start_addr_in(usr_start_addr[17:0]),
    .to_read_byte_in         (to_read_byte),
    .onchip_mem_read_start_in (onchip_mem_read_start),
    .onchip_mem_read_done_out (onchip_mem_read_done),

    .read_req_in             (onchip_mem_usr_logic_read_req),
    .data_ready_out          (onchip_mem_usr_logic_data_ready),
    .read_data_out           (onchip_mem_usr_logic_read_data),
    .read_data_valid_out     (onchip_mem_usr_logic_read_data_valid)


);

wps_controller wps_controller_inst (
    .clk                      (mem_clk),
    .rst_n                    (mem_rst_n),

    .usr_start_addr_out       (usr_start_addr),
    .to_read_byte_out         (to_read_byte),
    .to_read_frame_num_out    (to_read_frame_num),
    .one_frame_byte_out       (one_frame_byte),
    .capture_pulse_cycle_out  (capture_pulse_cycle),

    .ddr3_read_start_out      (ddr3_read_start),
    .ddr3_read_done_in        (ddr3_read_done),
    .onchip_mem_read_start_out(onchip_mem_read_start),
    .onchip_mem_read_done_in  (onchip_mem_read_done),
    .wps_send_start_out       (wps_send_start),
    .wps_send_done            (wps_send_done),

    .onchip_mem_chip_select   (onchip_mem_wps_controller_chip_select),
    .onchip_mem_clk_ena       (),
    .onchip_mem_read_valid    (onchip_mem_wps_controller_read_valid),
    .onchip_mem_chip_read     (onchip_mem_wps_controller_read),
    .onchip_mem_addr          (onchip_mem_wps_controller_addr),
    .onchip_mem_read_data     (onchip_mem_read_data),

    .onchip_mem_byte_enable   (onchip_mem_byte_enable),
    .onchip_mem_write_data    (onchip_mem_write_data),
    .onchip_mem_write         (onchip_mem_write)

    );

assign onchip_mem_chip_select = (onchip_mem_wps_controller_read | onchip_mem_write) ? onchip_mem_wps_controller_chip_select :
                                (onchip_mem_usr_logic_read ? onchip_mem_usr_logic_read : 1'b0);
assign onchip_mem_addr = (onchip_mem_wps_controller_read | onchip_mem_write) ? onchip_mem_wps_controller_addr[12:0] :
                            (onchip_mem_usr_logic_read ? onchip_mem_usr_logic_addr[12:0] : 13'h0);

always @(posedge mem_clk) begin
    onchip_mem_wps_controller_read_r <= onchip_mem_wps_controller_read;
    onchip_mem_wps_controller_read_valid <= onchip_mem_wps_controller_read_r;

    onchip_mem_usr_logic_read_r <= onchip_mem_usr_logic_read;
    onchip_mem_usr_logic_read_valid <= onchip_mem_usr_logic_read_r;
end

// Mux data from DDR3 or onchip memory for interface_256in_24out
reg     data_mux; //0 from DDR3, 1 from onchip memory
reg 	  wps_send_done_r;

always @(posedge mem_clk) begin
	wps_send_done_r <= wps_send_done;
end

always @(posedge mem_clk) begin
    if (~mem_rst_n) begin
        data_mux <= 1'b0;
    end
    else begin
        if (onchip_mem_read_start) begin
            data_mux <= 1'b1;
        end
        // wps_send_done in clk_148_5 clock domain
        else if (wps_send_done_r) begin
            data_mux <= 1'b0;
        end
    end
end

/*
always @* begin
    interface_rx_data = ddr3_usr_logic_read_data;
    interface_rx_data_valid = ddr3_usr_logic_read_data_valid;
    ddr3_usr_logic_read_req = interface_rx_ready;
    onchip_mem_usr_logic_read_req = 1'b0;
    interface_rx_data_ready  = ddr3_usr_logic_data_ready;
    case(data_mux)
        1'b0: begin
            interface_rx_data = ddr3_usr_logic_read_data;
            interface_rx_data_valid = ddr3_usr_logic_read_data_valid;
            interface_rx_data_ready  = ddr3_usr_logic_data_ready;
            ddr3_usr_logic_read_req = interface_rx_ready;
        end
        1'b1: begin
            interface_rx_data = onchip_mem_usr_logic_read_data;
            interface_rx_data_valid = onchip_mem_usr_logic_read_data_valid;
            interface_rx_data_ready  = onchip_mem_usr_logic_data_ready;
            onchip_mem_usr_logic_read_req = interface_rx_ready;
        end
    endcase
end
*/
always @(posedge mem_clk) begin
    case(data_mux)
        1'b0: begin
            interface_rx_data <= ddr3_usr_logic_read_data;
            interface_rx_data_valid <= ddr3_usr_logic_read_data_valid;
            ddr3_usr_logic_read_req <= interface_rx_ready;
        end
        1'b1: begin
            interface_rx_data <= onchip_mem_usr_logic_read_data;
            interface_rx_data_valid <= onchip_mem_usr_logic_read_data_valid;
            onchip_mem_usr_logic_read_req <= interface_rx_ready;
        end
    endcase
end // always @(posedge mem_clk)

assign interface_rx_data_ready = data_mux ? onchip_mem_usr_logic_data_ready : ddr3_usr_logic_data_ready;

`ifdef GB
interface_256in_24out_gb interface_256in_24out_gb_inst (
    .rx_clock     (mem_clk),
    .rx_rst_n     (mem_rst_n),
    .rx_data_ready_in(interface_rx_data_ready),
    .rx_data      (interface_rx_data),
    .rx_data_valid(interface_rx_data_valid),
    .rx_ready_out (interface_rx_ready),


    .tx_clock     (clk250m),
    .tx_rst_n     (clk250m_rst_n),
    .wps_send_done_in(wps_send_done),
    .tx_data      (interface_tx_data),
    .tx_data_valid(interface_tx_data_valid),
    .tx_req_in   (interface_tx_req)
    );
`else
interface_256in_24out interface_256in_24out_inst (
    .rx_clock     (mem_clk),
    .rx_rst_n     (mem_rst_n),
    .rx_data_ready_in(interface_rx_data_ready),
    .rx_data      (interface_rx_data),
    .rx_data_valid(interface_rx_data_valid),
    .rx_ready_out (interface_rx_ready),


    .tx_clock     (clk250m),
    .tx_rst_n     (clk250m_rst_n),
    .wps_send_done_in(wps_send_done),
    .tx_data      (interface_tx_data),
    .tx_data_valid(interface_tx_data_valid),
    .tx_req_in   (interface_tx_req)
);
`endif

single_FIFO singleFIFO_inst (
    .rx_clk           (clk250m),
    .rx_rst_n         (clk250m_rst_n),
    .rx_data          (interface_tx_data),
    .rx_data_valid     (interface_tx_data_valid),
    .rx_ready_out     (interface_tx_req),

    .tx_clk           (clk148_5m),
    .tx_rst_n         (clk148_5m_rst_n),
    .tx_read_in       (pingpongFIFO_read),
    .wps_send_done_in (wps_send_done),
    .tx_data_ready_out(pingpongFIFO_ready),
    .tx_data          (pingpongFIFO_data),
    .tx_valid         (pingpongFIFO_data_valid)
);


wps_send wps_send_inst (
    .clk (clk148_5m),
    .rst_n (clk148_5m_rst_n),

    .to_send_frame_num_in  (to_read_frame_num),
    .to_send_byte_in       (to_read_byte),
    .one_frame_byte_in     (one_frame_byte),
    .pulse_cycle_in        (capture_pulse_cycle),
    .start                 (wps_send_start),

    .frame_trig            (frame_start_trig),
    .frame_busy            (frame_busy),
    .de_first_offset_line_in     (de_o_first_offset_line),
    .display_video_left_offset_in(display_vedio_left_offset),
    .h_sync_in             (h_sync_hdmi),
    .v_sync_in             (v_sync_hdmi),
    .de_in                 (de_hdmi),
    .h_sync_out            (h_sync_out_wire),
    .v_sync_out            (v_sync_out_wire),
    .de_out                (de_out_wire),
    .de_first_offset_line_out (de_first_offset_line_out_wire),
    .pix_data_out          (pix_data_out_wire),
    .capture_pulse_out     (capture_pulse_out),
    .one_frame_send_done_out(one_frame_send_done),
    .wps_send_done_out     (wps_send_done),

    .pingpong_ready_in      (pingpongFIFO_ready),
    .read_pingpong_out      (pingpongFIFO_read),
    .pingpong_data_in       (pingpongFIFO_data),
    .pingpong_data_valid_in (pingpongFIFO_data_valid)
);

assign de_out = de_out_wire;
assign de_first_offset_line_out = de_first_offset_line_out_wire;
assign pix_data_out = pix_data_out_wire;
assign h_sync_out = h_sync_out_wire;
assign v_sync_out = v_sync_out_wire;

display_vedio_generate_DMD_specific_faster display_vedio_generate_DMD_specific_faster_inst (
    .clk_i(clk148_5m),
    .rst_ni(clk148_5m_rst_n),
    .hsync_o_with_camera_format(hsync_o_with_camera_format),//active high
    .vsync_o_with_camera_format(vsync_o_with_camera_format),//active low
    .de_o(de_o),//active high

    .hsync_o_with_hdmi_format(h_sync_hdmi),
    .vsync_o_with_hdmi_format(v_sync_hdmi),
    .de_o_with_hdmi_format(de_hdmi),

    .de_o_first_offset_line(de_o_first_offset_line),
    .display_vedio_left_offset(display_vedio_left_offset),

    .frame_start_trig(frame_start_trig),//a
    .frame_busy(frame_busy),

    .frame_all_zeros('h0),//we have to send all zero frame during acqisitaion, high active (captured at the edge of frame_start_trig)
    .de_with_all_zeros(),

    .dmd_correct_15_pixles_slope('h0),//added by wdf @2014/11/03 dmd_correct_15_pixles_slope==1'b1 the display will compensate the slope
    .dmd_flip_left_and_right('h0),//flip left and right //left right flip: flip first, the correct the 15 pixels == correct the -15 pixels and then flip

    .frame_count(frame_count)
);

wire [31:0]         total_frame_num_out/*synthesis keep*/;
wire [31:0]         error_frame_num_out/*synthesis keep*/;
wire                error_out/*synthesis keep*/;
data_verify data_verify_inst (
    .clk                    (clk148_5m),
    .rst_n                  (clk148_5m_rst_n),
    .de_in                  (de_out_wire),
    .de_first_offset_line_in(de_first_offset_line_out_wire),
    .h_sync_in              (h_sync_out_wire),
    .v_sync_in              (v_sync_out_wire),
    .data_in                (pix_data_out_wire),
    .total_frame_num_out    (total_frame_num_out),
    .error_frame_num_out    (error_frame_num_out),
    .error_out              (error_out)
    );

altsource_probe #(
    .sld_auto_instance_index ("YES"),
    .sld_instance_index      (0),
    .instance_id             ("ERR"),
    .probe_width             (65),
    .source_width            (0),
    .source_initial_value    ("0"),
    .enable_metastability    ("NO")
) data_verify_vio (
    .probe({total_frame_num_out, error_frame_num_out, error_out})
);

endmodule