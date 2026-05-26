module clk_divider #(
    parameter CLK_FREQ = 50_000_000  // 50 MHz board clock
)(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_1hz
);
    localparam HALF = CLK_FREQ / 2;   // 25_000_000
    integer count;
    
    always @(posedge clk or negedge rst_n)
    begin
    if (!rst_n)
    begin
    count <= 0;
    clk_1hz <= 0;
    end
    else begin
    if (count == HALF - 1)begin
    clk_1hz <= ~clk_1hz;
    count <= 0;
    end
    else begin
    count <=count + 1;
    end
    end
    end
    
endmodule