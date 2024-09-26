module seg (
    sys_clk,
    rst_n,
    seg_data,
    seg_hex

);
    input sys_clk;
    input rst_n;
    input [3:0] seg_data;
    output [6:0] seg_hex;
    reg [6:0] seg_hex;

    always @(*) begin
        if(!rst_n)begin
            seg_hex <= 7'b100_0000;
        end
        else begin
            case (seg_data)
                0: seg_hex = 7'h40;
                1: seg_hex = 7'h79;
                2: seg_hex = 7'h24;
                3: seg_hex = 7'h30;
                4: seg_hex = 7'h19;
                5: seg_hex = 7'h12;
                6: seg_hex = 7'h02;
                7: seg_hex = 7'h78;
                8: seg_hex = 7'h00;
                9: seg_hex = 7'h10;
                default: seg_hex = 7'h40;
            endcase
        end
    end

endmodule