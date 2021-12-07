`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Description: 对数据存储器进行访问
//////////////////////////////////////////////////////////////////////////////////

module mem(
    input rst,
    input [4:0] wd_in,//访存阶段的指令要写入的目的寄存器地址
    input wreg_in,//访存阶段的指令是否有要写入的目的寄存器
    input [31:0] wdata_in,//访存阶段的指令要写入目的寄存器的值
    input [7:0] aluop_in,//访存阶段的指令要进行的运算的子类型
    input [31:0] mem_addr_in,//访存阶段的加载、存储指令对应的存储器地址
    input [31:0] reg2_in,//访存阶段的存储指令要存储的数据
    input [31:0] mem_data_in,//从数据存储器读取的数据
    output reg[4:0] wd_out,//访存阶段的指令最终要写入的目的寄存器地址
    output reg wreg_out,//访存阶段的指令最终是否有要写入的目的寄存器
    output reg[31:0] wdata_out,//访存阶段的指令最终要写入目的寄存器的值
    output reg[31:0] mem_addr_out,//要访问的数据存储器的地址
    output wire mem_we_out,//是否是写操作
    output reg[31:0] mem_data_out,//要写入数据存储器的数据
    output reg mem_ce_out//数据存储器使能信号
    );
    reg mem_we;
    assign mem_we_out=mem_we;
    always @(*)begin
        if(rst==1'b1)begin
            wd_out<=5'b00000;
            wreg_out<=1'b0;
            wdata_out<=32'h00000000;
            mem_addr_out<=32'h00000000;
            mem_we<=1'b0;
            mem_data_out<=32'h00000000;
            mem_ce_out<=1'b0;
        end else begin
            wd_out<=wd_in;
            wreg_out<=wreg_in;
            wdata_out<=wdata_in;
            mem_we<=1'b0;
            mem_addr_out<=32'h00000000;
            mem_data_out<=32'h00000000;
            mem_ce_out<=1'b0;
            case(aluop_in)
                8'b11100011:begin//LW
                    mem_addr_out<=mem_addr_in;
                    mem_ce_out<=1'b1;
                    wdata_out<=mem_data_in;
                end
                8'b11101011:begin//SW
                    mem_addr_out<=mem_addr_in;
                    mem_we<=1'b1;
                    mem_data_out<=reg2_in;
                    mem_ce_out<=1'b1;
                end
                default:begin
                end
            endcase
        end
    end
endmodule