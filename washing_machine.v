`timescale 1ns / 1ps

module washing_machine(
input rst,
input clk,
input water_level, 
input start, 
input stop, // Output of Timer in Washing Machine
output reg Finish_alarm, door_locked, drained
);
//State Definition
parameter START = 3'b000;
parameter Fill_water = 3'b001;
parameter add_detergent = 3'b010;
parameter Wash = 3'b011;
parameter Drain_water = 3'b100;
parameter Spin_mode = 3'b101;
parameter Finish = 3'b110;

reg [2:0] next_state, present_state;

//Initial Conditions
always @(posedge clk or posedge rst) begin
    if(rst) begin 
        present_state <= START;
        door_locked <= 1'b0;
        Finish_alarm <= 1'b0;
        drained <= 1'b0;
    end
    else begin
        present_state <= next_state;
        door_locked <= 1'b0;
        Finish_alarm <= 1'b0;
        drained <= 1'b0;
    end   
end

//Transition Logic (combinational)
always @(present_state) begin
case (present_state)
    START: begin 
        if(start) begin 
            door_locked <= 1'b0;
            next_state <= Fill_water;
            end
        else next_state <= START;
        end
    Fill_water: begin
        if(start) begin
            door_locked <= 1'b0;
            if(water_level) next_state <= add_detergent;
            else next_state <= Fill_water;
        end
        else next_state <= START; end
    add_detergent: begin
        if(start) begin
            door_locked <= 1'b0;
            if(stop) next_state <= Wash;
            else next_state <= add_detergent;
            end
        else next_state <= START; end
    Wash: begin
        if(start) begin
            door_locked <= 1'b1;
            if(stop) next_state <= Drain_water;
            else next_state <= Wash;
            end
        else next_state <= START; end
    Drain_water: begin
        if(start) begin
            door_locked <= 1'b1;
            if(!water_level) next_state <= Spin_mode;
            else next_state <= Drain_water;
            end
        else next_state <= START; end
    Spin_mode: begin
        if(start) begin
            door_locked <= 1'b1;
            drained <= 1'b1;
            if(stop) next_state <= Finish;
            else next_state <= Spin_mode;
            end
        else next_state <= START; end
    Finish: begin
        if(start) begin
            door_locked <= 1'b0;
            Finish_alarm <= 1'b1;
                if(drained) next_state <= START;
                else next_state <= Finish;
            next_state <= START;
            end
        else next_state <= START; end
    default: begin 
        next_state <= START;
        end
endcase
end

// Sequential Logic
always @(posedge clk) begin
case (present_state)
    START: begin 
        if(start) begin 
            door_locked <= 1'b0;
            next_state <= Fill_water;
            end
        else next_state <= START;
        end
    Fill_water: begin
        if(start) begin
            door_locked <= 1'b0;
            if(water_level) next_state <= add_detergent;
            else next_state <= Fill_water;
        end
        else next_state <= START; end
    add_detergent: begin
        if(start) begin
            door_locked <= 1'b0;
            if(stop) next_state <= Wash;
            else next_state <= add_detergent;
            end
        else next_state <= START; end
    Wash: begin
        if(start) begin
            door_locked <= 1'b1;
            if(stop) next_state <= Drain_water;
            else next_state <= Wash;
            end
        else next_state <= START; end
    Drain_water: begin
        if(start) begin
            door_locked <= 1'b1;
            if(!water_level) next_state <= Spin_mode;
            else next_state <= Drain_water;
            end
        else next_state <= START; end
    Spin_mode: begin
        if(start) begin
            door_locked <= 1'b1;
            drained <= 1'b1;
            if(stop) next_state <= Finish;
            else next_state <= Spin_mode;
            end
        else next_state <= START; end
    Finish: begin
        if(start) begin
            door_locked <= 1'b0;
            Finish_alarm <= 1'b1;
                if(drained) next_state <= START;
                else next_state <= Finish;
            next_state <= START;
            end
        else next_state <= START; end
    default: begin 
        next_state <= START;
        end
endcase
end
  
endmodule

