module mux_b_bcin(BOUT, B, BCIN);
    parameter B_INPUT = "DIRECT";

    input [17:0] BCIN;
    input [17:0] B;

    output [17:0] BOUT;

    assign BOUT = (B_INPUT == "DIRECT")? B : BCIN;

endmodule