module dac (
    input       ref_clk,
    input       reset_n,
    output [13:0] dac_data/*synthesis keep*/

);

reg [13:0] sin_mem [0:38];
reg [6:0] cnt;
initial begin
    $readmemh("sin.dat",sin_mem);
end

always @(posedge ref_clk) begin
    if (~reset_n) begin
        cnt <= 'h0;
    end
    else begin
        if (cnt == 6'd38) begin
            cnt <= 'h0;
        end
        else begin
            cnt <= cnt + 1'd1;
        end
    end
end

assign dac_data = sin_mem[cnt];



endmodule