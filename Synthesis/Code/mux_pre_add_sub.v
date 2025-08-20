module mux_pre_add_sub(out, in1, in2, OPMODE_pre, OPMODE_mux);
    parameter width_add_sub = 18;

    input [width_add_sub-1:0] in1;
    input [width_add_sub-1:0] in2;
    input OPMODE_pre ;
    input OPMODE_mux ;

    output [width_add_sub-1:0] out; 

    wire [width_add_sub-1:0] pre_out;

    assign pre_out = (OPMODE_pre == 0)? (in1 + in2) : (in1 - in2);
    assign out = (OPMODE_mux == 1)? pre_out : in2;
endmodule