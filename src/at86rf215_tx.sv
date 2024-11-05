`timescale 1 ns / 1 ps

module at86rf215_tx #
(
    parameter integer TXD_WIDTH = 2,
    parameter integer FRACTIONAL_BITS = 13
)
(

    /* General inputs and outputs */
    input logic aclk,
    input logic aresetn,

    // input logic mark_sync,
    input logic [4:0] mark_samp_rate,
    input logic [4:0] sync_bits,
    output logic [TXD_WIDTH - 1 : 0] txd,
    output logic underflow,

    /* AXI Stream Slave interface */
    output logic s00_axis_tready,
    input logic [31 : 0] s00_axis_tdata,
    input logic  s00_axis_tlast,
    input logic  s00_axis_tvalid
);

typedef enum logic {
    IDLE,            
    ACCEPT_SAMPLE    
} slave_fsm_t;

localparam integer C_S_AXIS_TDATA_WIDTH = 32/TXD_WIDTH;
localparam integer ZERO_PREAMBLE_LEN = 32/TXD_WIDTH;

logic SlaveReceiveReadiness;
slave_fsm_t mst_exec_state; 


always_comb begin
    s00_axis_tready = ((mst_exec_state == ACCEPT_SAMPLE));
    SlaveReceiveReadiness = s00_axis_tvalid && s00_axis_tready;
end

logic [1:0] word_cnt;
always_ff @(posedge aclk) begin  
    if (!aresetn) begin
        mst_exec_state <= IDLE;
    end  
    else begin
        if (mst_exec_state == IDLE) begin
            mst_exec_state <= word_cnt < 2 ? ACCEPT_SAMPLE : IDLE;
        end
        else if (mst_exec_state == ACCEPT_SAMPLE) begin
            mst_exec_state <= word_cnt > 1 ? IDLE : ACCEPT_SAMPLE;
        end
        else begin
            mst_exec_state <= mst_exec_state;
        end
    end
end

/* Assigning them only during reset caused problems if they were configured with GPIO.
 * It is likely that they cause problems with the embedded AXI Lite as well. 
 */
logic write_idx;
logic read_idx;
logic [$clog2(32*10) - 1 : 0] zero_pad;
logic [$clog2(ZERO_PREAMBLE_LEN*10 + ZERO_PREAMBLE_LEN) - 1 : 0] bit_cnt;
logic [31:0] words [1:0];

always_comb begin
    zero_pad = (mark_samp_rate[3:0] - 1) * ZERO_PREAMBLE_LEN;
end


always_ff @(posedge aclk) begin
    if(!aresetn) begin
        word_cnt <= 0;
        words[0] <= 0;
        words[1] <= 0;
        read_idx <= 0;
        write_idx <= 0;
    end
    else begin
        if(SlaveReceiveReadiness) begin
            words[write_idx] <= s00_axis_tdata;
            write_idx <= write_idx + 1;
            word_cnt <= word_cnt + 1;
        end
        else begin
            write_idx <= write_idx;
            words[write_idx] <= words[write_idx];
            word_cnt <= word_cnt;
        end
        
        if(bit_cnt == C_S_AXIS_TDATA_WIDTH + zero_pad - 1) begin
            word_cnt <= word_cnt == 0 ? word_cnt : word_cnt - 1;
            read_idx <= read_idx + 1;
        end
    end
end

logic init;
always_ff @(posedge aclk) begin
    if(!aresetn) begin
        init <= 1;
    end
    else begin
        if(init) begin
            init <= bit_cnt >= ZERO_PREAMBLE_LEN - 1 && word_cnt != 0 ? 0 : 1;
        end
        else begin
            init <= word_cnt == 0 ? 1 : 0;
        end
    end
end


logic mark_sync;
always_comb begin
    mark_sync = mark_samp_rate[4];
end

always_ff @(posedge aclk) begin
    if(!aresetn) begin
        underflow <= 0;
        bit_cnt <= 0;
    end
    else begin
        /* At the start of a new IQ session the IC needs at least 32 zero bits */
        if(init) begin
            bit_cnt <= bit_cnt >= ZERO_PREAMBLE_LEN - 1 ? 0 : bit_cnt + 1;
        end
        else begin
            underflow <= word_cnt == 0 ? 1 : 0 ;
            if(word_cnt == 0) begin
                bit_cnt <= bit_cnt;
            end
            else begin
                bit_cnt <= bit_cnt == C_S_AXIS_TDATA_WIDTH + zero_pad - 1 ? 0 : bit_cnt + 1;
            end
        end
    end
end

logic [12:0] i_data, q_data;
logic [15:0] i_data_norm, q_data_norm;
logic [31:0] tx_word;

always_comb begin
    i_data_norm = words[1][31:16] << 15 - FRACTIONAL_BITS;
    q_data_norm = words[1][15:0] << 15 - FRACTIONAL_BITS;
    i_data = i_data_norm[15:3];
    q_data = q_data_norm[15:3];
    
end


always_comb begin
    tx_word = {sync_bits[3:2], i_data, mark_sync, sync_bits[1:0], q_data, sync_bits[4]};
end

logic [TXD_WIDTH - 1 : 0] data_rate_tx_idle;
logic [TXD_WIDTH - 1 : 0] data_rate_tx_send;

always_comb begin
    data_rate_tx_idle = 2'b00;
    data_rate_tx_send = {tx_word[31-2*bit_cnt], tx_word[31-2*bit_cnt -  1]};
end


/* Only in case a mistake between the `n` and `p` signals of the LVDS exists. */
logic [TXD_WIDTH - 1 : 0] inverted_data_rate_tx_idle;
logic [TXD_WIDTH - 1 : 0] inverted_data_rate_tx_send;

always_comb begin
    inverted_data_rate_tx_idle = data_rate_tx_idle;
    inverted_data_rate_tx_send = data_rate_tx_send;
end



always_ff @(posedge aclk) begin
    if(!aresetn) begin
        txd <= inverted_data_rate_tx_idle;
    end
    else begin
        /* At the start of a new IQ session the IC needs at least 32 zero bits */
        if(init) begin
            txd <= inverted_data_rate_tx_idle;
        end
        else begin
            if(word_cnt == 0) begin
                txd <= inverted_data_rate_tx_idle;
            end
            else begin
                txd <= bit_cnt < C_S_AXIS_TDATA_WIDTH ? inverted_data_rate_tx_send : inverted_data_rate_tx_idle;
            end
        end
    end
end

endmodule
