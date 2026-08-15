module async_fifo #(parameter width = 8,parameter depth = 10)(input[addr_width-1:0] waddr,input [width-1:0] data,input[addr_width-1:0] raddr,input wclk,input rclk,input w_en,output [width-1:0] op);

localparam addr_width = $clog2(depth);
reg [width-1:0] store [depth-1:0];

always @(posedge wclk) begin
    if(w_en)
        store[waddr] <= data;
end

assign op = store[raddr];

endmodule