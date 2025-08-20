module multiplier(out, in1, in2);
    parameter width_mult_in = 18;
    localparam width_mult_out = 2 * width_mult_in;

    input [width_mult_in-1:0] in1;
    input [width_mult_in-1:0] in2;

    output [width_mult_out-1:0] out;

    assign out = in1 * in2;
endmodule