`timescale 1ns/1ps
module data_verify (
    input           clk,
    input           rst_n,

    input           de_in,
    input           de_first_offset_line_in,
    input           h_sync_in,
    input           v_sync_in,
    input[23:0]     data_in,

    output [31:0]   total_frame_num_out,
    output [31:0]   error_frame_num_out,
    output          error_out
);

reg [31:0]      frame_cnt;
reg [31:0]      error_frame_cnt;
reg [31:0]      last_error_frame;
reg             error;
reg [15:0]      line_cnt;

reg             de_r;
reg [23:0]      data_r1, data_r2;

reg             valid_r, valid_p, valid_p_r;

reg [1:0]       state;
localparam IDLE = 2'b00;
localparam HEAD = 2'b01;
localparam DATA = 2'b10;

//output
assign total_frame_num_out = frame_cnt;
assign error_frame_num_out = error_frame_cnt;
assign error_out = error;

always @(posedge clk) begin
    data_r1 <= data_in;
    data_r2 <= data_r1;

    valid_r <= de_in;
    valid_p <= ~valid_r & de_in;
    valid_p_r <= valid_p;
end

always @(posedge clk) begin
    if(~rst_n | v_sync_in) begin
        line_cnt <= 0;
    end else begin
        if (valid_p & ~de_first_offset_line_in) begin
            line_cnt <= line_cnt + 1'd1;
        end // if (valid_p)
    end
end

always @(posedge clk) begin
    if(~rst_n) begin
        frame_cnt <= 0;
    end else begin
        if (valid_p & de_first_offset_line_in) begin
            frame_cnt <= frame_cnt + 1'd1;
        end // if (valid_p & de_first_offset_line_in)
    end
end

always @(posedge clk) begin
    if(~rst_n) begin
        last_error_frame <= 0;
        error_frame_cnt <= 0;
    end else begin
        if (error) begin
            last_error_frame <= frame_cnt;
        end // if (error)

        if (error && (last_error_frame != frame_cnt)) begin
            error_frame_cnt <= error_frame_cnt + 1'd1;
        end // if (error && (last_error_frame != frame_cnt))
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= IDLE;
        error <= 1'b0;
    end else begin
        error <= 1'b0;
        case(state)
            IDLE: begin
                if (de_in & de_first_offset_line_in) begin
                    state <= HEAD;
                end // if (de_in & de_first_offset_line_in)
            end // IDLE:
            HEAD: begin
                if (data_r2[23:8] != 16'h8000 && valid_p_r) begin
                    error <= 1'b1;
                end // if (data_r2 != 24'h800000 && valid_p)

                if (h_sync_in) begin
                    state <= DATA;
                end // if (h_sync_in)
            end // HEAD:
            DATA: begin
                if (data_r2[15:0] != line_cnt && valid_p_r) begin
                    error <= 1'b1;
                end // if (data_r2 != line_cnt && valid_p)
                if (v_sync_in) begin
                    state <= IDLE;
                end // if (v_sync_in)
            end // DATA:
            default: begin
                state <= IDLE;
            end // default:
        endcase // state
    end // end else
end // always @(posedge clk or negedge rst_n)


endmodule