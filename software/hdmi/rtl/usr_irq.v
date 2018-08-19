module usr_irq (
    input               clk,    // Clock
    input               rst_n,
    input               usr_irq_in,

    output reg         irq_avalon_master_chipselect,
    output reg [3:0]   irq_avalon_master_address,
    output reg         irq_avalon_master_read,
    output reg         irq_avalon_master_write,
    output reg [31:0]  irq_avalon_master_writedata,
    input wire          irq_avalon_master_waitrequest,
    input wire [31:0]   irq_avalon_master_readdata

);
reg usr_irq_r;

always @(posedge clk) begin
    usr_irq_r <= usr_irq_in;
end // always @(posedge clk)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        irq_avalon_master_chipselect <= 1'b0;
        irq_avalon_master_write <= 1'b0;
  
        irq_avalon_master_writedata <= 'h0;
    end // if (~rst_n)
    else begin
        if (~usr_irq_r & usr_irq_in) begin
            irq_avalon_master_chipselect <= 1'b1;
            irq_avalon_master_writedata <= 32'h1;
            irq_avalon_master_write <= 1'b1;
        end // if (~usr_irq_r & usr_irq_in)
        else begin
            irq_avalon_master_chipselect <= 1'b0;
            irq_avalon_master_writedata <= 'h0;
            irq_avalon_master_write <= 1'b0;
        end // else
    end // else
end // always @(posedge clk)

endmodule