`timescale 1ns/1ps

module tb_top();

reg sys_clk;
reg rst_n;
reg YC;

wire [5:0] led;
wire [6:0] segH;
wire [6:0] segL;
wire ack;

top  top_inst (
    .sys_clk(sys_clk),
    .rst_n(rst_n),
    .YC(YC),
    .led(led),
    .segL(segL),
    .segH(segH)
  );

//时钟周期，单位ns，在这里修改时钟周期
parameter CYCLE = 20;

//复位时间，此时表示复位3个时钟周期的时间
parameter RST_TIME = 3;

//生成本地时钟50M
initial begin
    sys_clk = 0;
    forever
    #(CYCLE/2)
    sys_clk=~sys_clk;
end

//产生复位信号
initial begin
    rst_n = 1;
    #2;
    rst_n = 0;
    #(CYCLE * RST_TIME);
    rst_n = 1;
end

//输入信号din0赋值方式
initial begin
    #1;
    //赋初值
    YC = 0;
    #(10*CYCLE);
    //开始赋值
    YC = 1;
    #(1000*CYCLE);
    $stop;
end

endmodule

