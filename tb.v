module tb;

reg wclk,rclk,winc,wrst,rinc,rrst;
reg [7:0] wdata;
wire [7:0] rdata;
wire wfull,rempty;
wire almost_full,almost_empty;

always #5 wclk = ~ wclk;
always #10 rclk = ~ rclk;

top #(.width(8),.depth(64)) dut(wdata,winc,wclk,wrst,rinc,rclk,rrst,wfull,rempty,rdata,almost_full,almost_empty);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb);

    wclk= 1'b0; rclk = 1'b0;
    winc = 1'b0;rinc = 1'b0;
    wdata = 8'h00;
    wrst = 1'b1;rrst = 1'b1;
    #3;
    wrst = 1'b0;rrst = 1'b0;
    
    winc = 1'b1;wdata = 8'h01;
    #5;
    winc = 1'b0;
    #5;
    winc = 1'b1;wdata = 8'h04;
    #5;
    winc = 1'b0;
    #5;
    winc = 1'b1;wdata = 8'h08;
    #5;
    winc = 1'b0;
    
    rinc = 1'b1;
    #15;
    rinc = 1'b0;
    #15;
    rinc = 1'b1;
    #15;
    rinc = 1'b0;
    #15;
    rinc = 1'b1;
    #15;
    rinc = 1'b0;

    #100;
    $finish;
end

endmodule