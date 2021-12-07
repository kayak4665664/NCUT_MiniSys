`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Description: 将执行阶段取得的运算结果在下一个时钟传递到流水线访存阶段
//////////////////////////////////////////////////////////////////////////////////

module ex_mem(
    input clk,
    input rst,
    input [4:0] ex_wd,//执行阶段的指令执行后要写入的目的寄存器地址
    input ex_wreg,//执行阶段的指令执行后是否有要写入的目的寄存器
    input [31:0] ex_wdata,//执行阶段的指令执行后要写入目的寄存器的值
    input [7:0] ex_aluop,//执行阶段的指令要进行的运算的子类型
    input [31:0] ex_mem_addr,//执行阶段的加载、存储指令对应的存储器地址
    input [31:0] ex_reg2,//执行阶段的存储指令要存储的数据
    output reg[4:0] mem_wd,//访存阶段的指令要写入的目的寄存器地址
    output reg mem_wreg,//访存阶段的指令是否有要写入的目的寄存器
    output reg[31:0] mem_wdata,//访存阶段的指令要写入目的寄存器的值
    output reg[7:0] mem_aluop,//访存阶段的指令要进行的运算的子类型
    output reg[31:0] mem_mem_addr,//执行阶段的加载、存储指令对应的存储器地址
    output reg[31:0] mem_reg2//访存阶段的存储指令要存储的数据
    );
    always @(posedge clk)begin
        if(rst==1'b1)begin
            mem_wd<=5'b00000;
            mem_wreg<=1'b0;
            mem_wdata<=32'h00000000;
            mem_aluop<=8'b00000000;
            mem_mem_addr<=32'h00000000;
            mem_reg2<=32'h00000000;
        end else begin
            mem_wd<=ex_wd;
            mem_wreg<=ex_wreg;
            mem_wdata<=ex_wdata;
            mem_aluop<=ex_aluop;
            mem_mem_addr<=ex_mem_addr;
            mem_reg2<=ex_reg2;
        end
    end
endmodule