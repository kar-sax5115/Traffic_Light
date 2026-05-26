`timescale 1ns/1ps

module tb_traffic_light;

    reg        clk_50mhz;
    reg        rst_n;
    wire [2:0] light;           
    
    trafficlighttop dut (
        .clk_50mhz (clk_50mhz),
        .rst_n     (rst_n),
        .light     (light)      
    );

    defparam dut.clk1.CLK_FREQ = 50;  

    initial clk_50mhz = 0;
    always #10 clk_50mhz = ~clk_50mhz;

    initial begin
        $monitor("t=%0t | rst=%b | light(RGY)=%b", $time, rst_n, light);

        rst_n = 0;    
        #100;         
        rst_n = 1;    
        
        #500000;      

        $display("Simulation complete.");
        $finish;
    end

endmodule