module transmitter_FSM(
    input logic clk, nrst, baud_tick, tx_valid,
    output logic start, stop, count_en, count_clear,
    output logic select
);

    typedef enum logic [2:0]{  
        IDLE = 0,
        START = 1,
        DATA = 2,
        PARITY = 3,
        STOP = 4
    } state_t;

    state_t state, nextState;

    always_ff @(posedge clk, negedge ~nrst) begin
        if(~nrst) begin
            state <= IDLE;
        end else begin
            state <= nextState;
        end
    end

    always_comb begin
        case(state) 
            IDLE: begin 
                count_en = 0;
                if(tx_valid) begin
                    nextState = START;
                end else begin
                    nextState = IDLE;
                end
            end
            START: begin 
                count_en = 0;
                if(baud_tick) begin
                    nextState = DATA;
                end else begin
                    nextState = START;
                end
            end
            DATA: begin 
                count_en = 1;

            end
            PARITY: begin 
                count_en = 0;
            end
            STOP: begin 
                count_en = 0;
            end
            default: begin
                nextState = IDLE; 
                count_en = 0;
            end
        endcase
    end
endmodule