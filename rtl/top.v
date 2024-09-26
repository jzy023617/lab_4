`timescale 1ns/10ps
module top (
sys_clk,
rst_n,
YC,
led,
segL,
segH
);
/*-------------------------------------------------------------------*\
                          Parameter Description
\*-------------------------------------------------------------------*/
parameter D = 0.1;
localparam IDLE = 4'b0001;//main G and sub R
localparam S1 = 4'b0010;  //main Y and sub R
localparam S2 = 4'b0100;  //main R and sub G
localparam S3 = 4'b1000;  //main R and sub Y

/*-------------------------------------------------------------------*\
                            Port Description
\*-------------------------------------------------------------------*/
input               sys_clk;
input               rst_n;
input               YC;
output [5:0]        led;
output [6:0]        segL;
output [6:0]        segH;

/*-------------------------------------------------------------------*\
                          register Description
\*-------------------------------------------------------------------*/
reg [5:0] led;
reg [3:0] cur_state;
reg [3:0] next_state;
reg en;
reg [5:0] set_seg;
reg ack_d0;
/*-------------------------------------------------------------------*\
                          wire Description
\*-------------------------------------------------------------------*/
wire ack;


always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n)
        cur_state <= #D IDLE;
    else
        cur_state <= #D next_state;
end

always@(posedge sys_clk or negedge rst_n)begin 
    if(!rst_n)
        ack_d0 <= #D 0;
    else
        ack_d0 <= #D ack;
end

always@(*)begin
    case (cur_state)
        IDLE: begin
            if(YC && ack_d0)
                next_state = S1;
            else
                next_state = IDLE;
        end
        S1:begin
            if(ack_d0)
                next_state = S2;    
            else
                next_state = S1;
        end
        S2:begin
            if(ack_d0)
                next_state = S3;    
            else
                next_state = S2;
        end
        S3:begin
            if(ack_d0)
                next_state = IDLE;
            else
                next_state = S3;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end


always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n) begin
        en <= #D 1'b0;
        led <= #D 6'b0;
    end
    else begin 
        case (cur_state)
            IDLE:begin
                set_seg <= #D 6'd60;
                led <= #D 6'b001100;
                if(ack)
                    en <= #D 1'b0;
                else
                    en <= #D 1'b1;
            end
            S1:begin
                led <= #D 6'b010100;
                set_seg <= #D 6'd3;
                if(ack)
                    en <= #D 1'b0;
                else
                    en <= #D 1'b1;
            end
            S2:begin
                led <= #D 6'b100001;
                set_seg <= #D 6'd30;
                if(ack)
                    en <= #D 1'b0;
                else
                    en <= #D 1'b1;
            end
            S3:begin
                led <= #D 6'b100010;
                set_seg <= #D 6'd3;
                if(ack)
                    en <= #D 1'b0;
                else
                    en <= #D 1'b1;
            end 
            default:begin
                set_seg <= #D 6'd0;
                en <= #D 1'b0;
            end 
        endcase
    end
end

down_seg  down_seg_inst (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .set_seg(set_seg),
    .en(en),
    .segH(segH),
    .segL(segL),
    .ack(ack)
  );

endmodule