// counter, counts to 8 for transmitter FSM
// Anna Dalton (https://github.com/annazdalton)

module counter(
    input logic clk, nrst, enable, clear
    output logic [3:0] count,
    output logic overflow_flag
);
    logic [3:0] nextCount;

    always_ff @(posedge clk, negedge ~nrst) begin
        if(~nrst) begin
            count <= '0;
        end else begin
            count <= nextCount;
        end
    end

    always_comb begin
        if(clear) begin
            nextCount = '0;
        end else if(enable) begin
            nextCount = count + 4'd1; 
            //overflow flag is high if count > 8
            if(count = 4'd8) begin
                overflow_flag = 1'b1; 
            end else begin
                overflow_flag = 1'b0;
            end
        end else begin
            nextCount = count;
        end
    end
endmodule 