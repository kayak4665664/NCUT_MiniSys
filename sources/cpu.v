`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: cpu
//////////////////////////////////////////////////////////////////////////////////

module cpu(
    input clk,
    input rst,
    input [31:0] rom_data_in,//从指令存储器取得的指令
    input [31:0] ram_data_in,//从数据存储器读取的数据
    output wire[31:0] rom_addr_out,//输出到指令存储器的地址
    output wire rom_ce_out,//指令存储器使能信号
    output wire[31:0] ram_addr_out,//要访问的数据存储器地址
    output wire[31:0] ram_data_out,//要写入数据存储器的数据
    output wire ram_we_out,//是否对数据存储器的写操作
    output wire ram_ce_out//数据存储器使能信号
    );
    //连接IF/ID模块与译码阶段ID模块的变量
    wire[31:0] pc;
    wire[31:0] id_pc_in;
    wire[31:0] id_inst_in;
    //连接译码阶段ID模块的输出与ID/EX模块的输入的变量
    wire[7:0] id_aluop_out;
    wire[2:0] id_alusel_out;
    wire[31:0] id_reg1_out;
    wire[31:0] id_reg2_out;
    wire id_wreg_out;
    wire[4:0] id_wd_out;
    wire[31:0] id_link_address_out;
    wire[31:0] id_inst_out;
    //连接ID/EX模块的输出与执行阶段EX模块的输入的变量
    wire[7:0] ex_aluop_in;
    wire[2:0] ex_alusel_in;
    wire[31:0] ex_reg1_in;
    wire[31:0] ex_reg2_in;
    wire ex_wreg_in;
    wire[4:0] ex_wd_in;
    wire[31:0] ex_link_address_in;
    wire[31:0] ex_inst_in;
    //连接执行阶段EX模块的输出与EX/MEM模块的输入的变量
    wire ex_wreg_out;
    wire[4:0] ex_wd_out;
    wire[31:0] ex_wdata_out;
    wire[7:0] ex_aluop_out;
    wire[31:0] ex_mem_addr_out;
    wire[31:0] ex_reg2_out;
    //连接EX/MEM模块的输出与访存阶段MEM模块的输入的变量
    wire mem_wreg_in;
    wire[4:0] mem_wd_in;
    wire[31:0] mem_wdata_in;
    wire[7:0] mem_aluop_in;
    wire[31:0] mem_mem_addr_in;
    wire[31:0] mem_reg2_in;
    //连接访存阶段MEM模块的输出与MEM/WB模块的输入的变量
    wire mem_wreg_out;
    wire[4:0] mem_wd_out;
    wire[31:0] mem_wdata_out;
    //连接MEM/WB模块的输出与回写阶段的输入的变量
    wire wb_wreg_in;
    wire[4:0] wb_wd_in;
    wire[31:0] wb_wdata_in;
    //连接译码阶段ID模块与通用寄存器Regfile模块的变量
    wire reg1_read;
    wire reg2_read;
    wire[31:0] reg1_data;
    wire[31:0] reg2_data;
    wire[4:0] reg1_addr;
    wire[4:0] reg2_addr;
    //连接译码阶段ID模块与PC模块的变量
    wire id_branch_flag_out;
    wire[31:0] branch_target_address;
    //pc_reg例化
    pc_reg pc_reg0(
        .clk(clk),
        .rst(rst),
        .branch_flag_in(id_branch_flag_out),//是否发生转移
        .branch_target_address_in(branch_target_address),//转移到的目标地址
        .pc(pc),//要读取的指令地址
        .ce(rom_ce_out)//指令存储器使能信号
    );
    assign rom_addr_out=pc;//输出到指令存储器的地址
    //IF/ID模块例化
    if_id if_id0(
        .clk(clk),
        .rst(rst),
        .if_pc(pc),//取指令阶段取得的指令对应的地址
        .if_inst(rom_data_in),//取指令阶段取得的指令
        .id_pc(id_pc_in),//译码阶段的指令对应的地址
        .id_inst(id_inst_in)//译码阶段的指令
    );
    //译码阶段ID模块
    id id0(
        .rst(rst),
        .pc_in(id_pc_in),//译码阶段的指令对应的地址
        .inst_in(id_inst_in),//译码阶段的指令
        .reg1_data_in(reg1_data),//rdata1
        .reg2_data_in(reg2_data),//rdata2
        .ex_wreg_in(ex_wreg_out),//处于执行阶段的指令是否要写入目的寄存器
        .ex_wdata_in(ex_wdata_out),//处于执行阶段的指令要写入目的寄存器的数据
        .ex_wd_in(ex_wd_out),//处于执行阶段的指令要写入目的寄存器的地址
        .mem_wreg_in(mem_wreg_out),//处于访存阶段的指令是否要写入目的寄存器
        .mem_wdata_in(mem_wdata_out),//处于访存阶段的指令要写的目的寄存器的数据
        .mem_wd_in(mem_wd_out),//处于访存阶段的指令要写入目的寄存器的地址
        .reg1_read_out(reg1_read),//re1
        .reg2_read_out(reg2_read),//re2
        .reg1_addr_out(reg1_addr),//raddr1
        .reg2_addr_out(reg2_addr),//raddr2
        .aluop_out(id_aluop_out),//译码阶段的指令要进行的运算的子类型
        .alusel_out(id_alusel_out),//译码阶段的指令要进行的运算的类型
        .reg1_out(id_reg1_out),//译码阶段的指令要进行的源操作数1
        .reg2_out(id_reg2_out),//译码阶段的指令要进行的源操作数2
        .wd_out(id_wd_out),//译码阶段的指令要写入的目的寄存器地址
        .wreg_out(id_wreg_out),//译码阶段的指令是否有要写入的目的寄存器
        .inst_out(id_inst_out),//当前处于译码阶段的指令
        .branch_flag_out(id_branch_flag_out),//是否发生转移
        .branch_target_address_out(branch_target_address),//转移到的目标位置
        .link_addr_out(id_link_address_out)//转移指令要保存的返回位置
    );
    //通用寄存器Regfile例化
    regfile regfile0(
        .clk(clk),
        .rst(rst),
        .we(wb_wreg_in),//写使能
        .waddr(wb_wd_in),
        .wdata(wb_wdata_in),
        .re1(reg1_read),//读使能1
        .raddr1(reg1_addr),
        .rdata1(reg1_data),
        .re2(reg2_read),//读使能2
        .raddr2(reg2_addr),
        .rdata2(reg2_data)
    );
    //ID/EX模块
    id_ex id_ex0(
        .clk(clk),
        .rst(rst),
        .id_aluop(id_aluop_out),//译码阶段的指令要进行的运算的子类型
        .id_alusel(id_alusel_out),//译码阶段的指令要进行的运算的类型
        .id_reg1(id_reg1_out),//译码阶段的指令要进行的运算的操作数1
        .id_reg2(id_reg2_out),//译码阶段的指令要进行的运算的操作数2
        .id_wd(id_wd_out),//译码阶段的指令要写入的目的寄存器地址
        .id_wreg(id_wreg_out),//译码阶段的指令是否有要写入的目的寄存器
        .id_link_address(id_link_address_out),//处于译码阶段的转移指令要保存的返回地址
        .id_inst(id_inst_out),//当前处于译码阶段的指令
        .ex_aluop(ex_aluop_in),//执行阶段的指令要进行的运算的子类型
        .ex_alusel(ex_alusel_in),//执行阶段的指令要进行的运算的类型
        .ex_reg1(ex_reg1_in),//执行阶段的指令要进行的运算的操作数1
        .ex_reg2(ex_reg2_in),//执行阶段的指令要进行的运算的操作数2
        .ex_wd(ex_wd_in),//执行阶段的指令要写入的目的寄存器地址
        .ex_wreg(ex_wreg_in),//执行阶段的指令是否有要写入的目的寄存器
        .ex_link_address(ex_link_address_in),//处于执行阶段的转移指令要保存的返回地址
        .ex_inst(ex_inst_in)//当前处于执行阶段的指令
    );
    //EX模块
    ex ex0(
        .rst(rst),
        .aluop_in(ex_aluop_in),//执行阶段要进行的运算的子类型
        .alusel_in(ex_alusel_in),//执行阶段要进行的运算的类型
        .reg1_in(ex_reg1_in),//参与运算的源操作数1
        .reg2_in(ex_reg2_in),//参与运算的源操作数2
        .wd_in(ex_wd_in),//指令执行要写入的目的寄存器地址
        .wreg_in(ex_wreg_in),//是否有要写入的目的寄存器
        .link_address_in(ex_link_address_in),//处于执行阶段的转移指令要保存的返回地址
        .inst_in(ex_inst_in),//当前处于执行阶段的指令
        .wd_out(ex_wd_out),//执行阶段的指令最终要写入的目的寄存器地址
        .wreg_out(ex_wreg_out),//执行阶段的指令最终是否有要写入的目的寄存器
        .wdata_out(ex_wdata_out),//执行阶段的指令最终要写入目的寄存器的值
        .aluop_out(ex_aluop_out),//执行阶段的指令要进行的运算子类型
        .mem_addr_out(ex_mem_addr_out),//加载、存储指令对应的存储器地址
        .reg2_out(ex_reg2_out)//存储指令要存储的数据
    );
    //EX/MEM模块
    ex_mem ex_mem0(
        .clk(clk),
        .rst(rst),
        .ex_wd(ex_wd_out),//执行阶段的指令执行后要写入的目的寄存器地址
        .ex_wreg(ex_wreg_out),//执行阶段的指令执行后是否有要写入的目的寄存器
        .ex_wdata(ex_wdata_out),//执行阶段的指令执行后要写入目的寄存器的值
        .ex_aluop(ex_aluop_out),//执行阶段的指令要进行的运算的子类型
        .ex_mem_addr(ex_mem_addr_out),//执行阶段的加载、存储指令对应的存储器地址
        .ex_reg2(ex_reg2_out),//执行阶段的存储指令要存储的数据
        .mem_wd(mem_wd_in),//访存阶段的指令要写入的目的寄存器地址
        .mem_wreg(mem_wreg_in),//访存阶段的指令是否有要写入的目的寄存器
        .mem_wdata(mem_wdata_in),//访存阶段的指令要写入目的寄存器的值
        .mem_aluop(mem_aluop_in),//访存阶段的指令要进行的运算的子类型
        .mem_mem_addr(mem_mem_addr_in),//执行阶段的加载、存储指令对应的存储器地址
        .mem_reg2(mem_reg2_in)//访存阶段的存储指令要存储的数据
    );
    //MEM模块例化
    mem mem0(
        .rst(rst),
        .wd_in(mem_wd_in),//访存阶段的指令要写入的目的寄存器地址
        .wreg_in(mem_wreg_in),//访存阶段的指令是否有要写入的目的寄存器
        .wdata_in(mem_wdata_in),//访存阶段的指令要写入目的寄存器的值
        .aluop_in(mem_aluop_in),//访存阶段的指令要进行的运算的子类型
        .mem_addr_in(mem_mem_addr_in),//访存阶段的加载、存储指令对应的存储器地址
        .reg2_in(mem_reg2_in),//访存阶段的存储指令要存储的数据
        .mem_data_in(ram_data_in),//从数据存储器读取的数据
        .wd_out(mem_wd_out),//访存阶段的指令最终要写入的目的寄存器地址
        .wreg_out(mem_wreg_out),//访存阶段的指令最终是否有要写入的目的寄存器
        .wdata_out(mem_wdata_out),//访存阶段的指令最终要写入目的寄存器的值
        .mem_addr_out(ram_addr_out),//要访问的数据存储器的地址
        .mem_we_out(ram_we_out),//是否是写操作
        .mem_data_out(ram_data_out),//要写入数据存储器的数据
        .mem_ce_out(ram_ce_out)//数据存储器使能信号
    );
    //MEM/WB模块
    mem_wb mem_wb0(
        .clk(clk),
        .rst(rst),
        .mem_wd(mem_wd_out),//访存阶段的指令最终要写入的目的寄存器地址
        .mem_wreg(mem_wreg_out),//访存阶段的指令最终是否有要写入的目的寄存器
        .mem_wdata(mem_wdata_out),//访存阶段的指令最终要写入目的寄存器的值
        .wb_wd(wb_wd_in),//回写阶段的指令要写入的目的寄存器地址
        .wb_wreg(wb_wreg_in),//回写阶段的指令是否有要写入的目的寄存器
        .wb_wdata(wb_wdata_in)//回写阶段的指令要写入目的寄存器的值
    );
endmodule