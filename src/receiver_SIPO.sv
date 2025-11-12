module receiver_SIPO (
    input logic clk, nrst,
    input logic shift_en, data_i,
    output logic [7:0] sipo_o
);
    logic [7:0] nextSipo_o;

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            sipo_o <= '0;
        end else begin
            sipo_o <= nextSipo_o;
        end
    end

    always_comb begin
        if (shift_en == 1) begin
            nextSipo_o = {data_i, sipo_o[7:1]};
        end else begin
            nextSipo_o = sipo_o;
        end
    end

endmodule

