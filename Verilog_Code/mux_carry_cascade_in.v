module mux_carry_cascade_in(out, OPmode5, carryIN);
    parameter CARRY_IN_SEL = "OPMODE5";

    input carryIN ;
    input OPmode5 ;

    output out    ;

    assign out = (CARRY_IN_SEL == "OPMODE5")? OPmode5: (CARRY_IN_SEL == "CARRYIN")? carryIN: 0;

endmodule