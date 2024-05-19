`include "addRecFN.v"

module adder_fp(
	input 		  clk_i,
	input 		  rst_n_i,
	input 		  en_i,
	input  [31:0] summand_i,
	output [31:0] sum_o
);

localparam EXPWIDTH=8;
localparam SIGWIDTH=24;

wire [31:0] result;

wire [32:0] summand_rec;
wire [32:0] sum_rec;
wire [32:0] result_rec;

reg  [31:0] sum;

assign sum_o = sum;

always@(posedge clk_i or negedge rst_n_i) begin
	if (!rst_n_i) begin
		sum <= 32'b0;
	end
	else begin
		if(en_i) begin
			sum <= result;
		end
	end
end

fNToRecFN #(EXPWIDTH, SIGWIDTH) code_op_a(
    .in (summand_i  ),
    .out(summand_rec)
);

fNToRecFN #(EXPWIDTH, SIGWIDTH) code_op_b(
    .in (sum    ),
    .out(sum_rec)
);

recFNToFN #(EXPWIDTH, SIGWIDTH) decode_out(
    .in (result_rec),
    .out(result    )
);

addRecFN #(EXPWIDTH, SIGWIDTH) adder(
	.control	   (`flControl_tininessAfterRounding),
	.subOp  	   (1'b0                            ),
	.a      	   (sum_rec                         ),
	.b             (summand_rec                     ),
	.roundingMode  (`round_near_even                ),
	.out           (result_rec                      ),
	.exceptionFlags(                                )
);


endmodule