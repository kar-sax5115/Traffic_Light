`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2026 02:04:39 AM
// Design Name: 
// Module Name: trafficfsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module trafficfsm(
    input wire clk,
    input wire rst_n,
    output reg [1:0] state
    );
    integer timer;
    parameter RED = 2'b00,GREEN = 2'b01,YELLOW = 2'b10,REDALL =2'b11;
    parameter RED_TIME = 10, GREEN_TIME =8, YELLOW_TIME = 3, REDALL_TIME =1;
    
    always @ (posedge clk or negedge rst_n)
    if (!rst_n)
    begin timer <= 0;
    state <= 0;
    end 
    else begin 
    timer <= timer +1;
    case (state)
    RED: if(timer == RED_TIME-1) begin
    state<=GREEN;
    timer<=0;
    end
    GREEN: if(timer == GREEN_TIME-1) begin
    state<=YELLOW;
    timer<=0;
    end
    YELLOW: if(timer ==YELLOW_TIME-1) begin
    state<=REDALL;
    timer<=0;
    end
    REDALL: if(timer == REDALL_TIME-1) begin
    state<=RED;
    timer<=0;
    end
    default: begin state <= RED; timer <= 0; end
    endcase
    end   
    
endmodule
