module frameChecker(
    input logic frame_en, stop_bit, //stop_bit is data_i from transmitter
    output logic frame_error
);

    always_comb begin
        if (frame_en == 1'b1) begin
            frame_error = (stop_bit ! = 1'b1);
        end else begin
            frame_error = 1'b0;
        end
    end


endmodule
