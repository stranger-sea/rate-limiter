//////////////////////////////////////////////////////////////////////////////////////////
// module: rate limiter                                                                 //
// Description: A synchronous rate limiter controls the rate of change of output signal,//
// based on step size. The output tracks input but limits the rate of change avoiding   //
// abrupt changes                                                                       //
//////////////////////////////////////////////////////////////////////////////////////////

module rate_limiter #(
    parameter DATA_WIDTH = 6,
    parameter STEP_WIDTH = 3
)
(
    input wire       clk,       // clock input 
    input wire       reset,     // active high synchronous reset
    input wire [DATA_WIDTH-1:0] data_in,   // 6 bit data input to be rate limited
    input wire [STEP_WIDTH-1:0] step_size, // 3 bit step size to control max change per clk cycle 
    output reg [DATA_WIDTH-1:0] data_out   // 6 bit rate limited output data 
);


////////////////////////////////////////////////////////////////////////////////////////////
always@(posedge clk) begin
    
    if(reset) begin
        data_out <= 0;
    end

    else if (step_size != 0) begin
        // case 1: data input is less than or equal to step size
        if(data_in <= step_size) begin
            data_out <= data_in;
        end
        
        // case 2: data input is greater than data out
        else if(data_out < data_in) begin
            if (data_out + step_size > data_in)
                data_out <= data_in;
            else 
                data_out <= data_out + step_size;        
        end

        // case 3: data output signal greater than data input
        else if(data_out > data_in) begin
            if(data_out - step_size < data_in)
                data_out <= data_in;
            else 
                data_out <= data_out - step_size;
        end 
    end

end

////////////////////////////////////////////////////////////////////////////////////////////

endmodule
