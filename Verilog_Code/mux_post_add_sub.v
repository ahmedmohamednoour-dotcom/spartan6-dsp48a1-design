module mux_post_add_sub(out, cout, in1, in2, cin, OPMODE_post);
    parameter width_add_sub = 48;

    input [width_add_sub-1:0] in1;
    input [width_add_sub-1:0] in2;
    input cin ;
    input OPMODE_post ;

    output [width_add_sub-1:0] out; 
    output cout; 

    assign {cout,out} = (OPMODE_post == 0)? (in1 + in2 + cin) : (in2 - (in1 + cin));

endmodule