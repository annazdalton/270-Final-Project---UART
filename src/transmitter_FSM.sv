module transmitter_FSM(
    input logic clk, nrst, baud_tick, tx_valid, count_overflow,
    input logic [3:0] count_data,
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
                count_clear = 0;
                if(tx_valid) begin
                    nextState = START;
                end else begin
                    nextState = IDLE;
                end
            end
            START: begin 
                count_en = 0;
                count_clear = 0;
                if(baud_tick) begin
                    nextState = DATA;
                end else begin
                    nextState = START;
                end
            end
            DATA: begin 
                count_en = 1;
                count_clear = 0;
                if(count_data < 4'd8) begin
                    nextState == DATA;
                end else if (baud_tick == 1) begin
                    count_en = 0;
                    count_clear = 1;
                    if(parity_en == 0) begin
                        nextState = STOP;
                    end else begin
                        nextState = PARITY;
                    end
                end else begin
                    nextState = DATA;
                end
            end
            PARITY: begin 
                count_clear = 0;
                count_en = 0;
                //add logic once parity gen is done
                if(baud_tick) begin
                    nextState = STOP
                end else begin
                    nextState = PARITY;
                end
            end
            STOP: begin 
                count_clear = 0;
                count_en = 0;
                if(baud_tick) begin
                    nextState = IDLE;
                end else begin
                    nextState = STOP;
                end
            end
            default: begin
                nextState = IDLE; 
                count_en = 0;
                count_clear = 0;
            end
        endcase
    end
endmodule