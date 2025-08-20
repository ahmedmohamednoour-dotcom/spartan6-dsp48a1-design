module mux_3to1_x_z(out, in0, in1, in2, opmode_2bits);
    input [47:0] in0;
    input [47:0] in1;
    input [47:0] in2;
    input [1:0] opmode_2bits;

    output [47:0] out;

    assign out = (opmode_2bits == 0)? 0:
                 (opmode_2bits == 1)? in0:
                 (opmode_2bits == 2)? in1:
                 in2;
endmodule