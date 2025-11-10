//Transmitter Parallel In Serial Out Module (Shift Register w/ Parallel Load)
//Anna Dalton (https://github.com/annazdalton)

module transmitter_PISO(
    input clk, nrst,
    input logic [7:0] data_i,
    input logic shift_en, load,
    output logic piso_o
);
    logic nextpiso_o;
    logic piso_data, nextpiso_data

    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            piso_o <= '0;
            piso_data <= '0;
        end else begin
            piso_o <= nextpiso_o;
            piso_data <= nextpiso_data;
        end
    end

    //shift register logic, parallel load has priority 
    //LSB gets sent out first
    always_comb begin
        if(load) begin
            nextpiso_data = data_i;
            nextpiso_o = piso_o;
        end else if (shift_en) begin
            nextpiso_data = {1'b0, piso_data[7:1]};
            nextpiso_o = piso_data[0];

        end else begin
            nextpiso_data = piso_data;
            nextpiso_o = piso_o;
        end
    end

endmodule 