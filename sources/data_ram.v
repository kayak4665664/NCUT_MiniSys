`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: data_ram
// Description: 数据存储器
//////////////////////////////////////////////////////////////////////////////////

module data_ram(
    input clk,
    input ce,//数据存储器使能信号
    input we,//是否写操作
    input [31:0] addr,//要访问的地址
    input [31:0] data_in,//要写入的数据
    output reg[31:0] data_out//读出的数据
    );
    reg[31:0] data_mem[0:131070];
    always @(posedge clk)begin
        if((ce!=1'b0)&&(we==1'b1)) data_mem[addr[18:2]]<=data_in;
        //需要将cpu给出的数据地址除以4,即右移2位
    end
    always @(*)begin
        if(ce==1'b0) data_out<=32'h00000000;
        else if(we==1'b0) data_out<=data_mem[addr[18:2]];
        else data_out<=32'h00000000;
    end
endmodule