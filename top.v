module top #(parameter width = 8,parameter depth = 10)(input [width-1:0] wdata,input winc,input wclk,input wrst,input rinc,input rclk,input rrst,output wfull,output rempty,output [width-1:0] rdata,output almost_full,output almost_empty);
    
    localparam addr_width = $clog2(depth);

    wire [addr_width:0] rptr,rptr2,wptr,wptr2;
    wire [addr_width-1:0] waddr,raddr;
    wire wen;

    sync_r_w #(.width(width),.depth(depth)) s1(wrst,rptr,wclk,rptr2);
    sync_w_r #(.width(width),.depth(depth)) s2(rrst,wptr,rclk,wptr2);

    write_logic #(.width(width),.depth(depth)) wl(wrst,wclk,winc,rptr2,wptr,waddr,wen,wfull,almost_full);
    async_fifo #(.width(width),.depth(depth)) fifo(waddr,wdata,raddr,wclk,rclk,wen,rdata);
    read_logic #(.width(width),.depth(depth)) rl(rrst,rclk,rinc,wptr2,rptr,raddr,rempty,almost_empty);
    
endmodule