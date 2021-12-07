`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: pc_reg
// Description: 给出指令地址，实现指令指针计数器PC，寄存器的值就是指令地址
//////////////////////////////////////////////////////////////////////////////////

module pc_reg(
    input clk,
    input rst,
    input branch_flag_in,//是否发生转移
    input [31:0] branch_target_address_in,//转移到的目标地址
    output reg[31:0] pc,//要读取的指令地址
    output reg ce//指令存储器使能信号
    );
    always @(posedge clk)begin
        if(rst==1'b1) ce<=1'b0;
        else ce<=1'b1;
    end
    always @(posedge clk)begin
        if(ce==1'b0) pc<=32'h00000000;
        else if(branch_flag_in==1'b1) pc<=branch_target_address_in;
        else pc<=pc+4'h4;//按字节寻址，一条指令32位，4个字节
    end
endmodule