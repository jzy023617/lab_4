`timescale 1ns/10ps
module down_seg (
sys_clk,
rst_n,
en,
set_seg,
segH,
segL,
ack
);

/*-------------------------------------------------------------------*\
                          Parameter Description
\*-------------------------------------------------------------------*/
parameter D = 0.1;

/*-------------------------------------------------------------------*\
                            Port Description
\*-------------------------------------------------------------------*/
input               sys_clk;
input               rst_n;
input  [5:0]        set_seg;
input               en;
output [6:0]        segH;
output [6:0]        segL;
output              ack;
/*-------------------------------------------------------------------*\
                          register Description
\*-------------------------------------------------------------------*/
reg [5:0]           set_data;
reg [25:0]          cnt;
reg [5:0]           sec_cnt;
reg                 en_d0,en_d1,en_d2;
/*-------------------------------------------------------------------*\
                          wire Description
\*-------------------------------------------------------------------*/


/*-------------------------------------------------------------------*\
                                main
\*-------------------------------------------------------------------*/
always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n)
        cnt <= #D 0;
    else if(en_d2)begin
        // if(cnt == 26'd49_999_999)
        if(cnt == 26'd10)
            cnt <= #D 0;
        else
            cnt <= #D cnt + 1'b1;
    end
    else
        cnt <= #D 0;
end

always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n)
        sec_cnt <= #D 0;
    else if(set_seg == sec_cnt)
        sec_cnt <= #D 0;
    else if(cnt == 26'd10)
        sec_cnt <= #D sec_cnt + 1'b1;
    else
        sec_cnt <= #D sec_cnt;
end

// edge_detect
always@(posedge sys_clk or negedge rst_n)begin 
    if(!rst_n)begin
        en_d0 <= #D 0;
        en_d1 <= #D 0;
    end
    else begin
        en_d0 <= #D en;
        en_d1 <= #D en_d0;
        en_d2 <= #D en_d1;
    end
end



always @(posedge sys_clk or negedge rst_n) begin
    if(!rst_n) begin
        set_data <= 0;
	 end
    else if(en_d2) begin 
        // if(cnt == 26'd24_999_999)begin
        if(cnt == 26'd10)begin
            set_data <= #D set_data - 1;
        end
        else if(set_data == 6'd0) begin 
            set_data = 0;
        end
        else begin
            set_data <= #D set_data;
        end
    end
    else if(en_d0 & ~en_d1) begin 
        set_data <= #D set_seg;
    end
    else begin
        set_data <= #D set_data;
    end
end

assign ack = (sec_cnt == set_data)? 1:0;

seg  seg_inst1 (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .seg_data(set_data/10),
    .seg_hex(segH)
  );
  
seg  seg_inst2 (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .seg_data(set_data%10),
    .seg_hex(segL)
);

endmodule