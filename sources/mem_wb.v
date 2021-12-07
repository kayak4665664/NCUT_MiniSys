`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: mem_wb
// Description: 将访存阶段的运算结果在下一个时钟传递到回写阶段
//////////////////////////////////////////////////////////////////////////////////

module mem_wb(
    input clk,
    input rst,
    input [4:0] mem_wd,//访存阶段的指令最终要写入的目的寄存器地址
    input mem_wreg,//访存阶段的指令最终是否有要写入的目的寄存器
    input [31:0] mem_wdata,//访存阶段的指令最终要写入目的寄存器的值
    output reg[4:0] wb_wd,//回写阶段的指令要写入的目的寄存器地址
    output reg wb_wreg,//回写阶段的指令是否有要写入的目的寄存器
    output reg[31:0] wb_wdata//回写阶段的指令要写入目的寄存器的值
    );
    always @(posedge clk)begin
        if(rst==1'b1)begin
            wb_wd<=5'b00000;
            wb_wreg<=1'b0;
          wb_wdata<=32'h00000000;
        end else begin
            wb_wd<=mem_wd;
            wb_wreg<=mem_wreg;
            wb_wdata<=mem_wdata;
        end
    end
endmodule