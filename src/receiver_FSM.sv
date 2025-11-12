module receiver_FSM(
    input logic clk, nrst,
    input logic baud_tick, data_i, 
    output logic shift_en, parity_en, frame_en,
    output logic data_ready
);

    typedef enum logic [2:0]{
        IDLE = 3'd0;
        START = 3'd1;
        DATA = 3'd2;
        PARITY = 3'd3;
        STOP = 3'd4;
    } state_t;

    state_t state, nextState;
    logic [3:0] bit_count, nextCount;

    always_ff @(posedge clk, negedge ~nrst) begin
        if(~nrst) begin
            state <= IDLE;
            bit_count <= '0;
        end else begin  
            state <= nextState;
            bit_count <= nextCount;
        end
    end

    always_comb begin
        shift_en = 1'b0;
        parity_en = 1'b0;
        frame_en = 1'b0;
        data_ready = 1'b0;
        nextState = state;
        nextCount = bit_count;

        case(state)
            IDLE: begin
                nextCount = '0;
                if (data_i == 1'b0) begin nextState = START; end
                else begin nextState = IDLE; end
            end
            START: begin
                if (baud_tick == 1'b0) begin
                    nextState = START;
                end else if (baud_tick == 1'b1 && data_i == 1'b0) begin 
                    nextState = DATA; 
                    nextCount = '0;
                end
                else if(baud_tick == 1'b1 && data_i == 1'b1) begin 
                    nextState = IDLE; 
                end
            end    
            DATA: begin
                if (baud_tick == 1'b1 && bit_count == 4'd7 && parity_en == 1'b1) begin
                    shift_en = 1'b1;
                    nextState = PARITY;
                    nextCount = '0;
                end else if (baud_tick == 1'b1 && bit_count < 4'd7) begin
                    shift_en = 1'b1;
                    nextState = DATA;
                    nextCount = bit_count + 4'd1;
                end else if (baud_tick == 1'b1 && bit_count == 4'd7 && parity_en == 1'b0) begin
                    shift_en = 1'b1;
                    nextState = STOP;
                    nextCount = '0;
                end else if (baud_tick == 1'b0) begin
                    nextState = DATA;
                end
            end
            PARITY: begin
                if (baud_tick == 1'b0) begin
                    nextState = PARITY;
                end else begin
                    parity_en = 1'b1;
                    nextState = STOP;
                end
            end
            STOP: begin 
                if (baud_tick == 1'b0) begin
                    nextState = STOP;
                end else begin
                    frame_en = 1'b1;
                    data_ready = 1'b1;
                    nextState = IDLE;
                end
            end
            default: begin nextState = IDLE; end
        endcase
    end

endmodule
