`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: NCUT_MiniSys
//////////////////////////////////////////////////////////////////////////////////

module NCUT_MiniSys(
    input clk,
    input rst
    );
    //连接指令存储器
    wire[31:0] inst_addr;
    wire[31:0] inst;
    wire rom_ce;
    wire[31:0] mem_data_out;
    wire[31:0] mem_addr_in;
    wire[31:0] mem_data_in;
    wire mem_we_in;
    wire mem_ce_in;
    cpu cpu0(
        .clk(clk),
        .rst(rst),
        .rom_data_in(inst),//从指令存储器取得的指令
        .ram_data_in(mem_data_out),//从数据存储器读取的数据
        .rom_addr_out(inst_addr),//输出到指令存储器的地址
        .rom_ce_out(rom_ce),//指令存储器使能信号
        .ram_addr_out(mem_addr_in),//要访问的数据存储器地址
        .ram_data_out(mem_data_in),//要写入数据存储器的数据
        .ram_we_out(mem_we_in),//是否对数据存储器的写操作
        .ram_ce_out(mem_ce_in)//数据存储器使能信号
    );
    inst_rom inst_rom0(
        .ce(rom_ce),//使能
        .addr(inst_addr),//要读取的指令地址
        .inst(inst)//读出的指令
    );
    data_ram data_ram0(
        .clk(clk),
        .ce(mem_ce_in),//数据存储器使能信号
        .we(mem_we_in),//是否写操作
        .addr(mem_addr_in),//要访问的地址
        .data_in(mem_data_in),//要写入的数据
        .data_out(mem_data_out)//读出的数据
    );
endmodule