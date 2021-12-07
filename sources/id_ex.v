`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: id_ex
// Description: 将译码阶段取得的运算类型、源操作数等结果，在下一个时钟传递到流水线的执行
// 阶段。
//////////////////////////////////////////////////////////////////////////////////

module id_ex(
    input clk,
    input rst,
    input [7:0] id_aluop,//译码阶段的指令要进行的运算的子类型
    input [2:0] id_alusel,//译码阶段的指令要进行的运算的类型
    input [31:0] id_reg1,//译码阶段的指令要进行的运算的操作数1
    input [31:0] id_reg2,//译码阶段的指令要进行的运算的操作数2
    input [4:0] id_wd,//译码阶段的指令要写入的目的寄存器地址
    input id_wreg,//译码阶段的指令是否有要写入的目的寄存器
    input [31:0] id_link_address,//处于译码阶段的转移指令要保存的返回地址
    input [31:0] id_inst,//当前处于译码阶段的指令
    output reg[7:0] ex_aluop,//执行阶段的指令要进行的运算的子类型
    output reg[2:0] ex_alusel,//执行阶段的指令要进行的运算的类型
    output reg[31:0] ex_reg1,//执行阶段的指令要进行的运算的操作数1
    output reg[31:0] ex_reg2,//执行阶段的指令要进行的运算的操作数2
    output reg[4:0] ex_wd,//执行阶段的指令要写入的目的寄存器地址
    output reg ex_wreg,//执行阶段的指令是否有要写入的目的寄存器
    output reg[31:0] ex_link_address,//处于执行阶段的转移指令要保存的返回地址
    output reg[31:0] ex_inst//当前处于执行阶段的指令
    );
    always @(posedge clk)begin
        if(rst==1'b1)begin
            ex_aluop<=8'b00000000;
            ex_alusel<=3'b000;
            ex_reg1<=32'h00000000;
            ex_reg2<=32'h00000000;
            ex_wd<=5'b00000;
            ex_wreg<=1'b0;
            ex_link_address<=32'h00000000;
            ex_inst<=32'h00000000;
        end else begin
            ex_aluop<=id_aluop;
            ex_alusel<=id_alusel;
            ex_reg1<=id_reg1;
            ex_reg2<=id_reg2;
            ex_wd<=id_wd;
            ex_wreg<=id_wreg;
            ex_link_address<=id_link_address;
            ex_inst<=id_inst;
        end
    end
endmodule