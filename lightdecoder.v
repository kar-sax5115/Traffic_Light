`timescale 1ns / 1ps

module lightdecoder(
    output reg [2:0] light,
    input wire [1:0] state
    );
    parameter RED =2'b00, GREEN = 2'b01, YELLOW = 2'b10, REDALL = 2'b11;
    always @ (*) begin
    case (state)
    RED: light <= 3'b001; // 1
    GREEN: light <= 3'b010; //2
    YELLOW: light <= 3'b100; //4
    REDALL: light <= 3'b011; //3
    endcase
    end
endmodule
