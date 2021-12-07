`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: regfile
// Description: 包含32个32位通用寄存器，可以同时进行两个寄存器的读操作和一个寄存器
// 的写操作
//////////////////////////////////////////////////////////////////////////////////

module regfile(
    input clk,
    input rst,
    input we,//写使能
    input [4:0] waddr,
    input [31:0] wdata,
    input re1,//读使能1
    input [4:0] raddr1,
    input re2,//读使能2
    input [4:0] raddr2,
    output reg[31:0] rdata1,
    output reg[31:0] rdata2
    );
    reg[31:0] regs[0:31];
    always @(posedge clk)begin
        if((rst==1'b0)&&(we==1'b1)&&(waddr!=5'h0)) regs[waddr]<=wdata;//$0只能为0
    end
    always @(*)begin
        if((rst==1'b1)||(raddr1==5'h0)) rdata1<=32'h00000000;//$0只能为0
        else if((raddr1==waddr)&&(we==1'b1)&&(re1==1'b1)) rdata1<=wdata;//数据前推
        else if(re1==1'b1) rdata1<=regs[raddr1];
        else rdata1<=32'h00000000;
    end
    always @(*)begin
        if((rst==1'b1)||(raddr2==5'h0)) rdata2<=32'h00000000;//$0只能为0
        else if((raddr2==waddr)&&(we==1'b1)&&(re2==1'b1)) rdata2<=wdata;//数据前推
        else if(re2==1'b1) rdata2<=regs[raddr2];
        else rdata2<=32'h00000000;
    end
endmodule