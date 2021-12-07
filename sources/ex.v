`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: ex
// Description: 依据译码阶段的结果，进行指定的运算，给出运算结果
//////////////////////////////////////////////////////////////////////////////////

module ex(
    input rst,
    input [7:0] aluop_in,//执行阶段要进行的运算的子类型
    input [2:0] alusel_in,//执行阶段要进行的运算的类型
    input [31:0] reg1_in,//参与运算的源操作数1
    input [31:0] reg2_in,//参与运算的源操作数2
    input [4:0] wd_in,//指令执行要写入的目的寄存器地址
    input wreg_in,//是否有要写入的目的寄存器
    input [31:0] link_address_in,//处于执行阶段的转移指令要保存的返回地址
    input [31:0] inst_in,//当前处于执行阶段的指令
    output reg[4:0] wd_out,//执行阶段的指令最终要写入的目的寄存器地址
    output reg wreg_out,//执行阶段的指令最终是否有要写入的目的寄存器
    output reg[31:0] wdata_out,//执行阶段的指令最终要写入目的寄存器的值
    output wire[7:0] aluop_out,//执行阶段的指令要进行的运算子类型
    output wire[31:0] mem_addr_out,//加载、存储指令对应的存储器地址
    output wire[31:0] reg2_out//存储指令要存储的数据
    );
    reg[31:0] logicout;//保存逻辑运算的结果
    reg[31:0] shiftres;//保存移位运算的结果
    reg[31:0] arithmeticres;//保存算数运算的结果
    wire ov_sum;//保存溢出情况
    wire reg1_lt_reg2;//第一个操作数是否小于第二个操作数
    wire[31:0] reg2_in_mux;//保存输入的第二个操作数reg2_in的补码
    wire[31:0] result_sum;//保存加法结果
    assign reg2_in_mux=((aluop_in==8'b00100010)||(aluop_in==8'b00100011)||(aluop_in==8'b00101010))?(~reg2_in)+1:reg2_in;//SUB,SUBU,SLT 补码
    assign result_sum=reg1_in+reg2_in_mux;//如果是SLT运算，通过判断2个操作数减法运算的结果是否小于0，进而判断2个操作数的大小关系
    assign ov_sum=((!reg1_in[31]&&!reg2_in_mux[31])&&result_sum[31])||((reg1_in[31]&&reg2_in_mux[31])&&(!result_sum[31]));
    //reg1_in为正数，reg2_in_mux为正数，但和为负数 或者 reg1_in为负数，reg2_in_mux为负数，但和为正数， 此时溢出
    assign reg1_lt_reg2=((aluop_in==8'b00101010))?((reg1_in[31]&&!reg2_in[31])||(!reg1_in[31]&&!reg2_in[31]&&result_sum[31])||(reg1_in[31]&&reg2_in[31]&&result_sum[31])):(reg1_in<reg2_in);
    //SLT,reg1_in为负数且reg2_in为正数，reg1_in和reg2_in为正数且减法运算结果为负数，reg_i和reg2_in为负数且减法运算结果为负数
    assign aluop_out=aluop_in;
    assign mem_addr_out=reg1_in+{{16{inst_in[15]}},inst_in[15:0]};//加载、存储指令对应的存储器地址
    assign reg2_out=reg2_in;
    always @(*)begin//算数
        if(rst==1'b1) arithmeticres<=32'h00000000;
        else begin
            case(aluop_in)
                8'b00101010,8'b00101011:arithmeticres<=reg1_lt_reg2;//SLT,SLTU
                8'b00100000,8'b00100001:arithmeticres<=result_sum;//ADD,ADDU
                8'b00100010,8'b00100011:arithmeticres<=result_sum;//SUB,SUBU
                default:arithmeticres<=32'h00000000;
            endcase
        end
    end
    always @(*)begin//逻辑
        if(rst==1'b1) logicout<=32'h00000000;
        else begin
            case(aluop_in)
                8'b00100101:logicout<=reg1_in|reg2_in;//OR
                8'b00100100:logicout<=reg1_in&reg2_in;//AND
                8'b00100111:logicout<=~(reg1_in|reg2_in);//NOR
                8'b00100110:logicout<=reg1_in^reg2_in;//XOR
                default:logicout<=32'h00000000;
            endcase
        end
    end
    always @(*)begin//移位
        if(rst==1'b1) shiftres<=32'h00000000;
        else begin
            case(aluop_in)
                8'b01111100:shiftres<=reg2_in<<reg1_in[4:0];//SLL
                8'b00000010:shiftres<=reg2_in>>reg1_in[4:0];//SRL
                8'b00000011:shiftres<=({32{reg2_in[31]}}<<(6'd32-{1'b0,reg1_in[4:0]}))|reg2_in>>reg1_in[4:0];//SRA
                default:shiftres<=32'h00000000;
            endcase
        end
    end
    always @(*)begin
        wd_out<=wd_in;
        if(((aluop_in==8'b00100000)||(aluop_in==8'b00100010))&&(ov_sum==1'b1)) wreg_out<=1'b0;//ADD,SUB 溢出
        else wreg_out<=wreg_in;
        case(alusel_in) 
            3'b001:wdata_out<=logicout;//LOGIC
            3'b010:wdata_out<=shiftres;//SHIFT
            3'b011:wdata_out<=arithmeticres;//ARITHMETIC
            3'b000:wdata_out<=link_address_in;//JUMP,BRANCH
            default:wdata_out<=32'h00000000;
        endcase
    end
endmodule