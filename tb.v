`timescale 1ns / 1ps

module tb_washing_machine;
reg reset, CLOCK, START, STOP, WATER_level;
wire Finish_ALARM, Drained,Door_locked;

//Instantiation of Washing Machine Module
washing_machine dut(.clk(CLOCK),
           .rst(reset),
           .start(START),
           .stop(STOP),
           .water_level(WATER_level),
           .Finish_alarm(Finish_ALARM),
           .door_locked(Door_locked),
           .drained(Drained)
           );
           
// Clock generation
always begin
#5 CLOCK <= ~CLOCK;
end

// Initial inputs
initial begin
CLOCK <= 0;
reset <= 1;
START <= 0;
STOP <= 0;
WATER_level <= 0;
#5 reset <= 0;
end

//Definition of Inputs
initial begin
#5 START <= 1;
#10 WATER_level = 0;
#10 WATER_level = 1;
#10 STOP = 1;
#10 STOP = 1;
#10 WATER_level = 1;
#10 WATER_level = 0;
#10 STOP = 1;
#10 STOP = 1;
#40 START = 0;
#40 $finish;
end
endmodule


