`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCUT
// Engineer: kayak4665664
// Module Name: if_id
// Description: 暂时保存取指令阶段取得的指令，以及对应的指令地址，并在下一个时钟周期传递
// 到译码阶段
//////////////////////////////////////////////////////////////////////////////////

module if_id(
    input clk,
    input rst,
    input [31:0] if_pc,//取指令阶段取得的指令对应的地址
    input [31:0] if_inst,//取指令阶段取得的指令
    output reg[31:0] id_pc,//译码阶段的指令对应的地址
    output reg[31:0] id_inst//译码阶段的指令
    );
    always @(posedge clk)begin
        if(rst==1'b1)begin
            id_pc<=32'h00000000;
            id_inst<=32'h00000000;
        end else begin
                id_pc<=if_pc;
                id_inst<=if_inst;
            end
    end
endmodule