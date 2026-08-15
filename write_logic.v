module write_logic #(parameter width = 8,parameter depth = 10)(input wrst,input wclk,input winc,input [addr_width:0] rptr2,output reg [addr_width:0] wptr, output reg [addr_width-1:0] waddr,output wen,output reg wfull,output reg almost_full);

localparam addr_width = $clog2(depth);

reg [addr_width:0] wcount;
reg [addr_width:0] rptr2_bin;
wire [addr_width:0] wcountnext;
wire [addr_width-1:0] waddrnext;
wire [addr_width:0] wptrnext;
wire wfullnext;
wire almost_full_next;

always @(posedge wclk or posedge wrst) begin
    if(wrst) begin
        waddr <= {(addr_width){1'b0}};
        wptr <= {(addr_width+1){1'b0}};
        wcount <= {(addr_width+1){1'b0}};
        wfull <= 1'b0;
    end
    else begin
            wcount <= wcountnext;
            waddr <= waddrnext;
            wptr <= wptrnext;
            wfull <= wfullnext;
            almost_full <= almost_full_next;
    end
end
assign waddrnext = wcountnext[addr_width-1:0];
assign wptrnext = wcountnext^(wcountnext>>1);
assign wcountnext = wcount + (winc && !wfull);
assign wfullnext = ((wptrnext[addr_width:addr_width-1] != rptr2[addr_width:addr_width-1])&&(wptrnext[addr_width-2:0] == rptr2[addr_width-2:0]));
assign wen = !wfull && winc;
integer i;
always @(*) begin
    rptr2_bin[addr_width] = rptr2[addr_width];

    for (i = addr_width-1; i >= 0; i = i-1)
        rptr2_bin[i] = rptr2_bin[i+1] ^ rptr2[i];
end

assign almost_full_next = (wcountnext - rptr2_bin) > depth - 3;

endmodule