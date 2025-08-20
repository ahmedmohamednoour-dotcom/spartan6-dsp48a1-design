module mux_reg_18bits_async(out_mux_reg, in, clk, clkE, rst);
    parameter Reg_state = "1"      ;
    parameter width_reg = 18       ;

    input [width_reg - 1:0] in     ;
    input clk                      ;
    input clkE                     ;
    input rst                      ;

    output [width_reg - 1:0] out_mux_reg ;
    reg [width_reg - 1:0] out_reg ;


    assign out_mux_reg = (Reg_state == 1)? out_reg : in;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            out_reg <= 0;
        end
        else if(clkE) begin
           out_reg <= in;  
        end
        
    end
endmodule