module sync_w_r #(parameter width = 8,parameter depth = 10)(input rrst,input[addr_width:0] wptr,input rclk,output reg [addr_width:0] wptr2);

localparam addr_width = $clog2(depth);

reg [addr_width:0] wptr1;

always @(posedge rclk or posedge rrst) begin
    if(rrst) begin
        wptr1 <= {(addr_width+1){1'b0}};
        wptr2 <= {(addr_width+1){1'b0}};
    end
    else 
        {wptr2,wptr1} <= {wptr1,wptr};
end

endmodule