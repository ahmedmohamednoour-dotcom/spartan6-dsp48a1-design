module Spartan6_DSP48A1(P, PCOUT, BCOUT, M, CARRYOUT, CARRYOUTF, A, B, BCIN, C, D, CARRYIN, PCIN,
                         CLK, OPMODE, CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP, RSTA, RSTB,
                         RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP);
    /*===============================================================*/
    //Parameters 
    /*===============================================================*/
    parameter WIDTH1      = 18 ; 
    parameter WIDTH2      = 48 ; 
    parameter WIDTH3      = 36 ; 
    parameter WIDTH4      = 1  ; 
    parameter WIDTH5      = 8  ; 

    parameter A0REG       = 0  ;
    parameter A1REG       = 1  ;
    parameter B0REG       = 0  ;
    parameter B1REG       = 1  ;

    parameter CREG        = 1  ;
    parameter DREG        = 1  ;
    parameter MREG        = 1  ;
    parameter PREG        = 1  ;
    parameter CARRYINREG  = 1  ;
    parameter CARRYOUTREG = 1  ;
    parameter OPMODEREG   = 1  ;

    parameter CARRYINSEL  = "OPMODE5" ;
    parameter B_INPUT     = "DIRECT"  ;
    parameter RSTTYPE     = "SYNC"    ;
    /*===============================================================*/
    //Input Ports
    /*===============================================================*/
    //Data ports
    input [WIDTH1-1:0] A       ;
    input [WIDTH1-1:0] B       ;
    input [WIDTH1-1:0] BCIN    ;
    input [WIDTH2-1:0] C       ;
    input [WIDTH1-1:0] D       ;
    input              CARRYIN ;

    //Control Input Ports
    input              CLK    ;
    input [WIDTH5-1:0] OPMODE ;

    //Clock Enable Input Ports
    input CEA          ;
    input CEB          ;
    input CEC          ;
    input CECARRYIN    ;
    input CED          ;
    input CEM          ;
    input CEOPMODE     ;
    input CEP          ;

    //Reset Input Ports
    input RSTA         ;
    input RSTB         ;
    input RSTC         ;
    input RSTCARRYIN   ;
    input RSTD         ;
    input RSTM         ;
    input RSTOPMODE    ;
    input RSTP         ;

    //Cascade Ports
    input [WIDTH2-1:0] PCIN ;
    /*===============================================================*/
    //Output Ports
    /*===============================================================*/
    //Data ports
    output [WIDTH3-1:0] M         ;
    output [WIDTH2-1:0] P         ;
    output              CARRYOUT  ;
    output              CARRYOUTF ;

    //Cascade Ports
    output [WIDTH1-1:0] BCOUT ;
    output [WIDTH2-1:0] PCOUT ;
    /*===============================================================*/
    //input pre stage
    /*===============================================================*/
    wire [WIDTH1-1:0] D_reg      ;
    wire [WIDTH1-1:0] A0_reg     ;
    wire [WIDTH1-1:0] B0_reg     ;
    wire [WIDTH1-1:0] BOUT       ;
    wire [WIDTH2-1:0] C_reg      ;
    wire [WIDTH5-1:0] OPMODE_reg ;

    mux_b_bcin #(.B_INPUT(B_INPUT)) mux_B (BOUT, B, BCIN);

    mux_reg_18bits_parameter #(.Reg_state(B0REG), .rst_state(RSTTYPE), .width_reg(WIDTH1)) 
    B0_regM (.out_mux_reg(B0_reg), .in(B), .clk(CLK), .clkE(CEB), .rst(RSTB));

    mux_reg_18bits_parameter #(.Reg_state(A0REG), .rst_state(RSTTYPE), .width_reg(WIDTH1)) 
    A0_regM (.out_mux_reg(A0_reg), .in(A), .clk(CLK), .clkE(CEA), .rst(RSTA));

    mux_reg_18bits_parameter #(.Reg_state(DREG), .rst_state(RSTTYPE), .width_reg(WIDTH1)) 
    D_regM (.out_mux_reg(D_reg), .in(D), .clk(CLK), .clkE(CED), .rst(RSTD));

    mux_reg_18bits_parameter #(.Reg_state(CREG), .rst_state(RSTTYPE), .width_reg(WIDTH2)) 
    C_regM (.out_mux_reg(C_reg), .in(C), .clk(CLK), .clkE(CEC), .rst(RSTC));

    mux_reg_18bits_parameter #(.Reg_state(OPMODEREG), .rst_state(RSTTYPE), .width_reg(WIDTH5)) 
    OPMODE_regM (.out_mux_reg(OPMODE_reg), .in(OPMODE), .clk(CLK), .clkE(CEOPMODE), .rst(RSTOPMODE));
    /*===============================================================*/
    //pre operator stage
    /*===============================================================*/
    wire [WIDTH1-1:0] pre_operator ;
    wire [WIDTH1-1:0] B1_reg       ;
    wire [WIDTH1-1:0] A1_reg       ;

    mux_pre_add_sub #(.width_add_sub(WIDTH1)) 
    pre_add_sub (.out(pre_operator), .in1(D_reg), .in2(B0_reg), .OPMODE_pre(OPMODE_reg[6]), .OPMODE_mux(OPMODE_reg[4]));

    mux_reg_18bits_parameter #(.Reg_state(B1REG), .rst_state(RSTTYPE), .width_reg(WIDTH1)) 
    B1_regM (.out_mux_reg(B1_reg), .in(pre_operator), .clk(CLK), .clkE(CEB), .rst(RSTB));

    mux_reg_18bits_parameter #(.Reg_state(A1REG), .rst_state(RSTTYPE), .width_reg(WIDTH1)) 
    A1_regM (.out_mux_reg(A1_reg), .in(A0_reg), .clk(CLK), .clkE(CEA), .rst(RSTA));
    /*===============================================================*/
    //Multiplication stage
    /*===============================================================*/
    wire [WIDTH3-1:0] M_pre_reg ;

    assign BCOUT = B1_reg;

    multiplier #(.width_mult_in(WIDTH1)) 
    mult1 (.out(M_pre_reg), .in1(B1_reg), .in2(A1_reg));

    mux_reg_18bits_parameter #(.Reg_state(MREG), .rst_state(RSTTYPE), .width_reg(WIDTH3)) 
    M_regM (.out_mux_reg(M), .in(M_pre_reg), .clk(CLK), .clkE(CEM), .rst(RSTM));
    /*===============================================================*/
    //Carry In
    /*===============================================================*/
    wire cin     ;
    wire cin_reg ;

    mux_carry_cascade_in #(.CARRY_IN_SEL(CARRYINSEL)) 
    carry_cascade (.out(cin), .OPmode5(OPMODE_reg[5]), .carryIN(CARRYIN));

    mux_reg_18bits_parameter #(.Reg_state(CARRYINREG), .rst_state(RSTTYPE), .width_reg(WIDTH4)) 
    CYI (.out_mux_reg(cin_reg), .in(cin), .clk(CLK), .clkE(CECARRYIN), .rst(RSTCARRYIN));
    /*===============================================================*/
    //X-Z multiplexers
    /*===============================================================*/
    wire [WIDTH2-1:0] x_out ;
    wire [WIDTH2-1:0] z_out;

    mux_3to1_x_z 
    X_3to1_mux (.out(x_out), .in0({12'b0,M}), .in1(PCOUT), .in2({D_reg[11:0],A1_reg,B1_reg}), .opmode_2bits(OPMODE_reg[1:0]));

    mux_3to1_x_z 
    Z_3to1_mux (.out(z_out), .in0(PCIN), .in1(PCOUT), .in2(C_reg), .opmode_2bits(OPMODE_reg[3:2]));
    /*===============================================================*/
    //post operator stage
    /*===============================================================*/
    wire [WIDTH2-1:0] post_operator ;
    wire              cout          ;

    mux_post_add_sub #(.width_add_sub(WIDTH2)) 
    post_add_sub (.out(post_operator), .cout(cout), .in1(x_out), .in2(z_out), .cin(cin_reg), .OPMODE_post(OPMODE_reg[7]));
    /*===============================================================*/
    //Carry Out
    /*===============================================================*/
    mux_reg_18bits_parameter #(.Reg_state(CARRYOUTREG), .rst_state(RSTTYPE), .width_reg(WIDTH4)) 
    CYO (.out_mux_reg(CARRYOUT), .in(cout), .clk(CLK), .clkE(CECARRYIN), .rst(RSTCARRYIN));
    assign CARRYOUTF = CARRYOUT;
    /*===============================================================*/
    //P output
    /*===============================================================*/
    mux_reg_18bits_parameter #(.Reg_state(PREG), .rst_state(RSTTYPE), .width_reg(WIDTH2)) 
    P_regM (.out_mux_reg(P), .in(post_operator), .clk(CLK), .clkE(CEP), .rst(RSTP));
    assign PCOUT = P;
endmodule