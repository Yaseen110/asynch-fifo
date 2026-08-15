module sync_r_w #(parameter width = 8,parameter depth = 10)(input wrst,input[addr_width:0] rptr,input wclk,output reg [addr_width:0] rptr2);

localparam addr_width = $clog2(depth);
reg [addr_width:0] rptr1;

always @(posedge wclk or posedge wrst) begin
    if(wrst) begin
        rptr1 <= {(addr_width+1){1'b0}};
        rptr2 <= {(addr_width+1){1'b0}};
    end
    else
        {rptr2,rptr1} <= {rptr1,rptr};
end

endmodule