`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: id
// Description: 对指令进行译码
//////////////////////////////////////////////////////////////////////////////////

module id(
    input rst,
    input [31:0] pc_in,//译码阶段的指令对应的地址
    input [31:0] inst_in,//译码阶段的指令
    input [31:0] reg1_data_in,//rdata1
    input [31:0] reg2_data_in,//rdata2
    input ex_wreg_in,//处于执行阶段的指令是否要写入目的寄存器
    input [31:0] ex_wdata_in,//处于执行阶段的指令要写入目的寄存器的数据
    input [4:0] ex_wd_in,//处于执行阶段的指令要写入目的寄存器的地址
    input mem_wreg_in,//处于访存阶段的指令是否要写入目的寄存器
    input [31:0] mem_wdata_in,//处于访存阶段的指令要写的目的寄存器的数据
    input [4:0] mem_wd_in,//处于访存阶段的指令要写入目的寄存器的地址
    output reg reg1_read_out,//re1
    output reg reg2_read_out,//re2
    output reg[4:0] reg1_addr_out,//raddr1
    output reg[4:0] reg2_addr_out,//raddr2
    output reg[7:0] aluop_out,//译码阶段的指令要进行的运算的子类型
    output reg[2:0] alusel_out,//译码阶段的指令要进行的运算的类型
    output reg[31:0] reg1_out,//译码阶段的指令要进行的源操作数1
    output reg[31:0] reg2_out,//译码阶段的指令要进行的源操作数2
    output reg[4:0] wd_out,//译码阶段的指令要写入的目的寄存器地址
    output reg wreg_out,//译码阶段的指令是否有要写入的目的寄存器
    output wire[31:0] inst_out,//当前处于译码阶段的指令
    output reg branch_flag_out,//是否发生转移
    output reg[31:0] branch_target_address_out,//转移到的目标位置
    output reg[31:0] link_addr_out//转移指令要保存的返回位置
    );
    wire[5:0] op=inst_in[31:26];
    wire[4:0] op2=inst_in[10:6];
    wire[5:0] op3=inst_in[5:0];
    wire[4:0] op4=inst_in[20:16];
    reg[31:0] imm;//保存立即数
    wire[31:0] pc_plus_8;//保存当前译码阶段指令后面第2条指令的地址
    wire[31:0] pc_plus_4;//保存当前译码阶段指令后面第1条指令的地址
    wire[31:0] imm_sll2_signedext;//分支指令中的offset左移2位再符号扩展
    assign pc_plus_8=pc_in+8;//保存当前译码阶段指令后面第2条指令的地址
    assign pc_plus_4=pc_in+4;//保存当前译码阶段指令后面第1条指令的地址
    assign imm_sll2_signedext={{14{inst_in[15]}},inst_in[15:0],2'b00};//分支指令中的offset左移2位再符号扩展
    assign inst_out=inst_in;
    always @(*)begin//对指令进行译码
        if(rst==1'b1)begin
            aluop_out<=8'b00000000;
            alusel_out<=3'b000;
            wd_out<=5'b00000;
            wreg_out<=1'b0;
            reg1_read_out<=1'b0;
            reg2_read_out<=1'b0;
            reg1_addr_out<=5'b00000;
            reg2_addr_out<=5'b00000;
            imm<=32'h00000000;
            link_addr_out<=32'h00000000;
            branch_target_address_out<=32'h00000000;
            branch_flag_out<=1'b0;
        end else begin
            aluop_out<=8'b00000000;
            alusel_out<=3'b000;
            wd_out<=inst_in[15:11];
            wreg_out<=1'b0;
            reg1_read_out<=1'b0;
            reg2_read_out<=1'b0;
            reg1_addr_out<=inst_in[25:21];
            reg2_addr_out<=inst_in[20:16];
            imm<=32'h00000000;
            link_addr_out<=32'h00000000;
            branch_target_address_out<=32'h00000000;
            branch_flag_out<=1'b0;
            case(op)
                6'b000000:begin
                    case(op2)
                        5'b00000:begin
                            case(op3)
                                6'b100101:begin//OR
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00100101;//OR
                                    alusel_out<=3'b001;//LOGIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b100100:begin//AND
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00100100;//AND
                                    alusel_out<=3'b001;//LOGIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b100110:begin//XOR
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00100110;//XOR
                                    alusel_out<=3'b001;//LOGIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b100111:begin//NOR
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00100111;//NOR
                                    alusel_out<=3'b001;//LOGIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b000100:begin//SLLV
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b01111100;//SLL
                                    alusel_out<=3'b010;//SHIFT
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b000110:begin//SRLV
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00000010;//SRL
                                    alusel_out<=3'b010;//SHIFT
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b000111:begin//SRAV
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00000011;//SRA
                                    alusel_out<=3'b010;//SHIFT
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b101010:begin//SLT
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00101010;//SLT
                                    alusel_out<=3'b011;//ARITHMETIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b101011:begin//SLTU
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00101011;//SLTU
                                    alusel_out<=3'b011;//ARITHMETIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b100000:begin//ADD
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00100000;//ADD
                                    alusel_out<=3'b011;//ARITHMETIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b100001:begin//ADDU
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00100001;//ADDU
                                    alusel_out<=3'b011;//ARITHMETIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b100010:begin//SUB
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00100010;//SUB
                                    alusel_out<=3'b011;//ARITHMETIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b100011:begin//SUBU
                                    wreg_out<=1'b1;
                                    aluop_out<=8'b00100011;//SUBU
                                    alusel_out<=3'b011;//ARITHMETIC
                                    reg1_read_out<=1'b1;
                                    reg2_read_out<=1'b1;
                                end
                                6'b001000:begin//JR
                                    reg1_read_out<=1'b1;
                                    branch_target_address_out<=reg1_out;
                                    branch_flag_out<=1'b1;
                                end
                                default:begin
                                end
                            endcase
                        end
                        default:begin
                        end
                    endcase
                end
                6'b001101:begin//ORI
                    wreg_out<=1'b1;
                    aluop_out<=8'b00100101;//OR
                    alusel_out<=3'b001;//LOGIC
                    reg1_read_out<=1'b1;
                    imm<={16'h0,inst_in[15:0]};
                    wd_out<=inst_in[20:16];
                end
                6'b001100:begin//ANDI
                    wreg_out<=1'b1;
                    aluop_out<=8'b00100100;//AND
                    alusel_out<=3'b001;//LOGIC
                    reg1_read_out<=1'b1;
                    imm<={16'h0,inst_in[15:0]};
                    wd_out<=inst_in[20:16];
                end
                6'b001110:begin//XORI
                    wreg_out<=1'b1;
                    aluop_out<=8'b00100110;//XOR
                    alusel_out<=3'b001;//LOGIC
                    reg1_read_out<=1'b1;
                    imm<={16'h0,inst_in[15:0]};
                    wd_out<=inst_in[20:16];
                end
                6'b001111:begin//LUI
                    wreg_out<=1'b1;
                    aluop_out<=8'b00100101;//OR
                    alusel_out<=3'b001;//LOGIC
                    reg1_read_out<=1'b1;
                    imm<={inst_in[15:0],16'h0};
                    wd_out<=inst_in[20:16];
                end
                6'b001010:begin//SLTI
                    wreg_out<=1'b1;
                    aluop_out<=8'b00101010;//SLT
                    alusel_out<=3'b011;//ARITHMETIC
                    reg1_read_out<=1'b1;
                    imm<={{16{inst_in[15]}},inst_in[15:0]};
                    wd_out<=inst_in[20:16];
                end
                6'b001011:begin//SLTIU
                    wreg_out<=1'b1;
                    aluop_out<=8'b00101011;//SLTU
                    alusel_out<=3'b011;//ARITHMETIC
                    reg1_read_out<=1'b1;
                    imm<={16'h0,inst_in[15:0]};
                    wd_out<=inst_in[20:16];
                end
                6'b001000:begin//ADDI
                    wreg_out<=1'b1;
                    aluop_out<=8'b00100000;//ADD
                    alusel_out<=3'b011;//ARITHMETIC
                    reg1_read_out<=1'b1;
                    imm<={{16{inst_in[15]}},inst_in[15:0]};
                    wd_out<=inst_in[20:16];
                end
                6'b001001:begin//ADDIU
                    wreg_out<=1'b1;
                    aluop_out<=8'b00100001;//ADDU
                    alusel_out<=3'b011;//ARITHMETIC
                    reg1_read_out<=1'b1;
                    imm<={{16{inst_in[15]}},inst_in[15:0]};
                    wd_out<=inst_in[20:16];
                end
                6'b000010:begin//J
                    branch_target_address_out<={4'h0,inst_in[25:0],2'b00};
                    branch_flag_out<=1'b1;
                end
                6'b000011:begin//JAL
                    wreg_out<=1'b1;
                    alusel_out<=3'b000;
                    wd_out<=5'b11111;//$31
                    link_addr_out<=pc_plus_8;
                    branch_target_address_out<={4'h0,inst_in[25:0],2'b00};
                    branch_flag_out<=1'b1;
                end
                6'b000100:begin//BEQ
                    reg1_read_out<=1'b1;
                    reg2_read_out<=1'b1;
                    if(reg1_out==reg2_out)begin
                        branch_target_address_out<=pc_plus_4+imm_sll2_signedext;
                        branch_flag_out<=1'b1;
                    end
                end
                6'b000101:begin//BNE
                    reg1_read_out<=1'b1;
                    reg2_read_out<=1'b1;
                    if(reg1_out!=reg2_out)begin
                        branch_target_address_out<=pc_plus_4+imm_sll2_signedext;
                        branch_flag_out<=1'b1;
                    end
                end
                6'b100011:begin//LW
                    wreg_out<=1'b1;
                    aluop_out<=8'b11100011;//LW
                    reg1_read_out<=1'b1;
                    wd_out<=inst_in[20:16];
                end
                6'b101011:begin//SW
                    aluop_out<=8'b11101011;//SW
                    reg1_read_out<=1'b1;
                    reg2_read_out<=1'b1;
                end
                default:begin
                end
            endcase
            if(inst_in[31:21]==11'b00000000000)begin
                if(op3==6'b000000)begin//SLL
                    wreg_out<=1'b1;
                    aluop_out<=8'b01111100;//SLL
                    alusel_out<=3'b010;//SHIFT
                    reg2_read_out<=1'b1;
                    imm[4:0]<=inst_in[10:6];
                end else if(op3==6'b000010)begin//SRL
                    wreg_out<=1'b1;
                    aluop_out<=8'b00000010;//SRL
                    alusel_out<=3'b010;//SHIFT
                    reg2_read_out<=1'b1;
                    imm[4:0]<=inst_in[10:6];
                end else if(op3==6'b000011)begin//SRA
                    wreg_out<=1'b1;
                    aluop_out<=8'b00000011;//SRA
                    alusel_out<=3'b010;//SHIFT
                    reg2_read_out<=1'b1;
                    imm[4:0]<=inst_in[10:6];
                end
            end
        end
    end
    always @(*)begin//确定进行运算的源操作数1
        if(rst==1'b1) reg1_out<=32'h00000000;
        else if((reg1_read_out==1'b1)&&(ex_wreg_in==1'b1)&&(ex_wd_in==reg1_addr_out)) reg1_out<=ex_wdata_in;//数据前推，将前1条指令执行阶段的数据送到当前指令译码阶段
        else if((reg1_read_out==1'b1)&&(mem_wreg_in==1'b1)&&(mem_wd_in==reg1_addr_out)) reg1_out<=mem_wdata_in;//数据前推，将前2条指令访存阶段的数据送到当前指令译码阶段
        else if(reg1_read_out==1'b1) reg1_out<=reg1_data_in;
        else if(reg1_read_out==1'b0) reg1_out<=imm;
        else reg1_out<=32'h00000000;
    end
    always @(*)begin//确定进行运算的源操作数2
        if(rst==1'b1) reg2_out<=32'h00000000;
        else if((reg2_read_out==1'b1)&&(ex_wreg_in==1'b1)&&(ex_wd_in==reg2_addr_out)) reg2_out<=ex_wdata_in;//数据前推，将前1条指令执行阶段的数据送到当前指令译码阶段
        else if((reg2_read_out==1'b1)&&(mem_wreg_in==1'b1)&&(mem_wd_in==reg2_addr_out)) reg2_out<=mem_wdata_in;//数据前推，将前2条指令访存阶段的数据送到当前指令译码阶段
        else if(reg2_read_out==1'b1) reg2_out<=reg2_data_in;
        else if(reg2_read_out==1'b0) reg2_out<=imm;
        else reg2_out<=32'h00000000;
    end
endmodule