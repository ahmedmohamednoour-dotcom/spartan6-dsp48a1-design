module mux_reg_18bits_parameter(out_mux_reg, in, clk, clkE, rst);
    parameter Reg_state = "1"      ;
    parameter rst_state = "SYNC"   ;
    parameter width_reg = 18   ;

    input [width_reg - 1:0] in ;
    input clk                      ;
    input clkE                     ;
    input rst                      ;

    output [width_reg - 1:0] out_mux_reg ;

    generate
        if (rst_state == "SYNC") begin
            mux_reg_18bits_sync #(.Reg_state(Reg_state), .width_reg(width_reg)) 
            mux_reg_18bits (.out_mux_reg(out_mux_reg), .in(in), .clk(clk), .clkE(clkE), .rst(rst));
        end
        else begin
            mux_reg_18bits_async #(.Reg_state(Reg_state), .width_reg(width_reg)) 
            mux_reg_18bits (.out_mux_reg(out_mux_reg), .in(in), .clk(clk), .clkE(clkE), .rst(rst));
        end
    endgenerate
endmodule