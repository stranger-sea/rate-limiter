module tb_rate_limiter();

reg clk;
reg reset;
reg [5:0] data_in;
reg [2:0] step_size;
wire [5:0] data_out;

rate_limiter uut(.clk(clk),
                 .reset(reset),
                 .data_in(data_in),
                 .step_size(step_size),
                 .data_out(data_out)
                );

// initialize inputs 
initial begin 
    clk = 0;
    reset = 1;
    data_in = 0;
    step_size = 0;
    // generate clock signal
    forever #5 clk = ~clk;
end

// test 
initial begin
#10;
    //deassert reset
    reset = 0;
    // case 1: data input < step size
    data_in = 6'd5;
    step_size = 3'd7;

#10;
    // case 2: data input greater than data output
    data_in = 6'd32;
    step_size = 3'd7;
    
#150;
    // case 3: data input less than data output
    data_in = 15;
#80;
    // case 4: data input equal to data output 
    data_in = 15;
#40;
    // assert reset 
    reset = 1;

end

initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
    #250;
    $finish;
end

endmodule
