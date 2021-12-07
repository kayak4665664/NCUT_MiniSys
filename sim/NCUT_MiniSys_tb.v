`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Create Date: 2020/07/25 14:29:44
// Module Name: NCUT_MiniSys_tb
//////////////////////////////////////////////////////////////////////////////////

`include "C:/Users/kayak.WORKSTATION-WX/Documents/Verilog/Projects/project_5/project_5.srcs/sources_1/new/define.v"

module NCUT_MiniSys_tb();
    reg CLOCK_50;
    reg rst;
    initial begin
        CLOCK_50=1'b0;
        forever #10 CLOCK_50=~CLOCK_50;
    end
    initial begin
        rst=`RstEnable;
        #20 rst=`RstDisable;
    end
    NCUT_MiniSys NCUT_MiniSys0(
        .clk(CLOCK_50),
        .rst(rst)
    );
endmodule