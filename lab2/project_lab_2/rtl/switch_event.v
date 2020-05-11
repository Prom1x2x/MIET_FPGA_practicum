`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.05.2020 18:25:31
// Design Name: 
// Module Name: switch_event
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module switch_event(
    input       [9:0]   sw_i,              //���� ������ c �������������� � ���������� ��
    input               clk_50m,           //���� ��������� ��������
    input               btn_sync_i,        //���� ������ (��� ������ ������������ ��� ������ �� ���������� �������� � �� �������� �� ��)
    input               rst_i,
    output  reg         synced_event_o     //����� ��
      );
    
    reg         sw_event;     //������� ����������� �������
    reg  [1:0]  event_sync_reg;   //���������������� �������        
    parameter   EV_CONST = 4'd2;
    // ���������� ����������� ������� (�������������� �������)
    // �������� ������� ����������� ������� � ������ ��������� ����������� �������� KEY[0]
    always @(sw_i[9:0])
        if (sw_i[0]+sw_i[1]+sw_i[2]+sw_i[3]+sw_i[4]+sw_i[5]+sw_i[6]+sw_i[7]+sw_i[8]+sw_i[9]>EV_CONST) 
            sw_event = 1'b1; 
        else 
            sw_event = 1'b0;
    //��������� sw_event ����������, ��������� �� ���������� ������� ��� ��������� ��������� ��������� ��������������
    
    
    //���������  sw_event ���������������� � 2 �����
    //���� 1 - ������������� Reg_sw_event � clk_50m
    //���� ���� ��������� ����� ������� ���������� (��� ���������� ������������ sw_i) ������ � �������� ���������
    //(�� �� ��� ����������, �� 0->1 ���������� ������������ � ��������)
    always @(posedge clk_50m or posedge rst_i) begin
      if (rst_i) begin
        event_sync_reg  <= 1'b0; 
      end
      else begin
        event_sync_reg <= sw_event;
      end
    end
    
    //���� 2 - ������������� Reg_sw_event � btn_sync_i
    //���� ���� ��������� ����� ������� ������������������ � �������� ������ Reg_sw_event � ��������� �� ������� ������
    //(��������� ���������� ������ �� ����������� �� � ��������� ��������� ������� �� ������� ������)
    reg sync_block;
    always @(posedge clk_50m or posedge rst_i) begin
        if (rst_i) begin
            sync_block <= 1'b0;
            synced_event_o <= 1'b0;
        end
        else begin
            if(event_sync_reg && btn_sync_i && !sync_block) begin
                synced_event_o <= event_sync_reg;
                sync_block <= 1'b1;
            end
            if(sync_block) begin
                synced_event_o <= 1'b0;
            end
            if(!btn_sync_i && sync_block) begin
                sync_block <= 1'b0;
            end
        end
    end
    //����� ���� ������������� �� ������ ������� synced_event
    
endmodule