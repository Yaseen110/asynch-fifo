module read_logic #(parameter width = 8,parameter depth = 10)(input rrst,input rclk,input rinc,input [addr_width:0] wptr2,output reg [addr_width:0] rptr, output reg [addr_width-1:0] raddr,output reg rempty,output reg almost_empty);

localparam addr_width = $clog2(depth);

reg [addr_width:0] rcount;
reg [addr_width:0] wptr2_bin;
wire [addr_width:0] rcountnext;
wire [addr_width-1:0] raddrnext;
wire [addr_width:0] rptrnext;
wire remptynext;
wire almost_empty_next;
integer i;
always @(posedge rclk or posedge rrst) begin
    if(rrst) begin
        raddr <= {(addr_width){1'b0}};
        rptr <= {(addr_width+1){1'b0}};
        rcount <= {(addr_width+1){1'b0}};
        rempty <= 1'b0;
    end
    else begin
            rcount <= rcountnext;
            raddr <= raddrnext;
            rptr <= rptrnext;
            rempty <= remptynext;
            almost_empty <= almost_empty_next;
    end
end
assign raddrnext = rcountnext[addr_width-1:0];
assign rptrnext = rcountnext^(rcountnext>>1);
assign rcountnext = rcount + (rinc && !rempty);
assign remptynext = (rptrnext[addr_width:0] == wptr2[addr_width:0]);

always @(*) begin
    wptr2_bin[addr_width] = wptr2[addr_width];

    for (i = addr_width-1; i >= 0; i = i-1)
        wptr2_bin[i] = wptr2_bin[i+1] ^ wptr2[i];
end

assign almost_empty_next = (wptr2_bin - rcountnext) < 2;

endmodule