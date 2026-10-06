`timescale 1ns / 1ps

module trafficlighttop(
    input wire clk_50mhz,
    input wire rst_n,
    output wire [2:0] light
    );
    wire clk_1hz;
    wire [1:0] state;
    
    clk_divider clk1 (.clk(clk_50mhz), .rst_n(rst_n), .clk_1hz(clk_1hz));
    trafficfsm t1 (.clk(clk_1hz), .rst_n(rst_n), .state(state));
    lightdecoder light1 (.state(state), .light(light));
endmodule
