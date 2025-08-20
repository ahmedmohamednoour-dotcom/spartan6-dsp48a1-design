module Spartan6_DSP48A1_tb();
    /*===============================================================*/
    //Parameters 
    /*===============================================================*/
    // Parameters
    parameter WIDTH1 = 18;
    parameter WIDTH2 = 48;
    parameter WIDTH3 = 36;
    parameter WIDTH5 = 8;
    /*===============================================================*/
    //Input Ports
    /*===============================================================*/
    reg [WIDTH1-1:0] A, B, BCIN, D;
    reg [WIDTH2-1:0] C, PCIN;
    reg CARRYIN;
    reg CLK;
    reg [WIDTH5-1:0] OPMODE;
    reg CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
    reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;
    /*===============================================================*/
    //Output Ports
    /*===============================================================*/
    wire [WIDTH3-1:0] M;
    wire [WIDTH2-1:0] P, PCOUT;
    wire [WIDTH1-1:0] BCOUT;
    wire CARRYOUT, CARRYOUTF;
    /*===============================================================*/
    // Instantiate the DUT
    /*===============================================================*/
    Spartan6_DSP48A1 #(
        .A0REG(0), .A1REG(1), .B0REG(0), .B1REG(1), .CREG(1), .DREG(1),
        .MREG(1), .PREG(1), .CARRYINREG(1), .CARRYOUTREG(1), .OPMODEREG(1),
        .CARRYINSEL("OPMODE5"), .B_INPUT("DIRECT"), .RSTTYPE("SYNC")
    ) dut (
        .A(A), .B(B), .BCIN(BCIN), .C(C), .D(D), .CARRYIN(CARRYIN), .PCIN(PCIN),
        .CLK(CLK), .OPMODE(OPMODE), .CEA(CEA), .CEB(CEB), .CEC(CEC),
        .CECARRYIN(CECARRYIN), .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), .CEP(CEP),
        .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN),
        .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP),
        .M(M), .P(P), .PCOUT(PCOUT), .BCOUT(BCOUT), .CARRYOUT(CARRYOUT), .CARRYOUTF(CARRYOUTF)
    );
    /*===============================================================*/
    // Clock
    /*===============================================================*/
    initial begin
        CLK = 0;
        forever begin
            #1 CLK = ~CLK;
        end
    end
    /*===============================================================*/
    // Stimulus Generation
    /*===============================================================*/
    initial begin
    /*===============================================================*/
    // Reset Test
    /*===============================================================*/
        A = 0; B = 0; BCIN = 0; C = 0; D = 0; CARRYIN = 0; PCIN = 0; OPMODE = 0; 
        CEA = 0; CEB = 0; CEC = 0; CECARRYIN = 0; CED = 0; CEM = 0; CEOPMODE = 0; CEP = 0;
        RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0; RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0;
        #5;
        RSTA = 1; RSTB = 1; RSTC = 1; RSTCARRYIN = 1; RSTD = 1; RSTM = 1; RSTOPMODE = 1; RSTP = 1;
        CEA = 1; CEB = 1; CEC = 1; CECARRYIN = 1; CED = 1; CEM = 1; CEOPMODE = 1; CEP = 1;
        #3;
        repeat(10)begin
            A = $random; B = $random; BCIN = $random; C = $random; D = $random; CARRYIN = $random; PCIN = $random; OPMODE = $random; 
            CEA = $random; CEB = $random; CEC = $random; CECARRYIN = $random; CED = $random; CEM = $random; CEOPMODE = $random; CEP = $random;
            @(negedge CLK);
            if (M !== 0 || P !== 0 || PCOUT !== 0 || BCOUT !== 0 || CARRYOUT !== 0 || CARRYOUTF !== 0) begin
                $display("Error in reset: M: %d, P: %d, PCOUT: %d, BCOUT: %d, CARRYOUT: %d, CARRYOUTF: %d"
                , M, P, PCOUT, BCOUT, CARRYOUT, CARRYOUTF);
                $stop;
            end
        end

        RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0; RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0;
        CEA = 1; CEB = 1; CEC = 1; CECARRYIN = 1; CED = 1; CEM = 1; CEOPMODE = 1; CEP = 1;
        #5;
    /*===============================================================*/
    // DSP path 1
    /*===============================================================*/
        OPMODE = 8'b11011101;
        A = 20; B = 10; C = 350; D = 25;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        @(negedge CLK);
        @(negedge CLK);
        @(negedge CLK);
        @(negedge CLK);
        if(BCOUT !== 18'hf || M !== 36'h12c || P !== 48'h32 || PCOUT !== 48'h32 || CARRYOUT !== 0 || CARRYOUTF !== 0)begin
            $display("Error in DSP path 1: BCOUT: %h, M: %h, P: %h, PCOUT: %h, CARRYOUT: %h, CARRYOUTF: %h"
            , BCOUT, M, P, PCOUT, CARRYOUT, CARRYOUTF);
            $stop;
        end
        #5;
    /*===============================================================*/
    // DSP path 2
    /*===============================================================*/
        OPMODE = 8'b00010000;
        A = 20; B = 10; C = 350; D = 25;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        @(negedge CLK);
        @(negedge CLK);
        @(negedge CLK);
        if(BCOUT !== 18'h23 || M !== 36'h2bc || P !== 48'h0 || PCOUT !== 48'h0 || CARRYOUT !== 0 || CARRYOUTF !== 0)begin
            $display("Error in DSP path 2: BCOUT: %h, M: %h, P: %h, PCOUT: %h, CARRYOUT: %h, CARRYOUTF: %h"
            , BCOUT, M, P, PCOUT, CARRYOUT, CARRYOUTF);
            $stop;
        end
        #5;
    /*===============================================================*/
    // DSP path 3
    /*===============================================================*/
        OPMODE = 8'b00001010;
        A = 20; B = 10; C = 350; D = 25;
        BCIN = $random; PCIN = $random; CARRYIN = $random;
        @(negedge CLK);
        @(negedge CLK);
        @(negedge CLK);
        if(BCOUT !== 18'ha || M !== 36'hc8 || P !== PCOUT || CARRYOUT !== CARRYOUTF)begin
            $display("Error in DSP path 3: BCOUT: %h, M: %h, P: %h, PCOUT: %h, CARRYOUT: %h, CARRYOUTF: %h"
            , BCOUT, M, P, PCOUT, CARRYOUT, CARRYOUTF);
            $stop;
        end
        #5;
    /*===============================================================*/
    // DSP path 4
    /*===============================================================*/
        OPMODE = 8'b10100111;
        A = 5; B = 6; C = 350; D = 25; PCIN = 3000;
        BCIN = $random; CARRYIN = $random;
        @(negedge CLK);
        @(negedge CLK);
        @(negedge CLK);
        if(BCOUT !== 18'h6 || M !== 36'h1e || P !== 48'hfe6fffec0bb1 || PCOUT !== 48'hfe6fffec0bb1 || CARRYOUT !== 1 || CARRYOUTF !== 1)begin
            $display("Error in DSP path 4: BCOUT: %h, M: %h, P: %h, PCOUT: %h, CARRYOUT: %h, CARRYOUTF: %h"
            , BCOUT, M, P, PCOUT, CARRYOUT, CARRYOUTF);
            $stop;
        end
        $display("Test Done");
        $finish;
    end
endmodule