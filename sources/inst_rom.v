`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: inst_rom
// Description: 指令存储器
//////////////////////////////////////////////////////////////////////////////////

module inst_rom(
    input ce,//使能
    input [31:0] addr,//要读取的指令地址
    output reg[31:0] inst//读出的指令
    );
    reg[31:0] inst_mem[0:131070];
    initial $readmemh("C:/Users/kayak.WORKSTATION-WX/Documents/Verilog/Projects/project_5/project_5.srcs/sources_1/new/inst_rom.data",inst_mem);//使用文件初始化指令存储器
    always @(*)begin
        if(ce==1'b0) inst<=32'h00000000;
        else inst<=inst_mem[addr[18:2]];//因为cpu是按字节寻址的，
    end                               //需要将cpu给出的指令地址除以4,即右移2位
endmodule