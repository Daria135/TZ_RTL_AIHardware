`include "adder_fp.v"
`include "HardFloat-1.vi"

`define VECTORS_NUM 5
`define T_CLK 10

module tb_adder_fp();

logic clk;
logic rst_n;
logic en;
logic [31:0] summand;
logic [63:0] testvectors [`VECTORS_NUM];
logic [31:0] sum;
logic [31:0] sum_check;

adder_fp dut_1 (
	.clk_i(clk),
	.rst_n_i(rst_n),
	.en_i(en),
	.summand_i(summand),
	.sum_o(sum)
);

always #(`T_CLK/2) clk <= !clk;

initial begin
	$readmemb("./tb/test_vectors.tv", testvectors);
	sum_check <= 0;
	summand   <= 0;
	en        <= 1'b0;
	clk       <= 1'b0;
	rst_n     <= 1'b1;
	#2
	rst_n <= 1'b0;
	#2
	rst_n <= 1'b1;
	#2
	en <= 1'b1;
	for (int i = 0; i < `VECTORS_NUM; i++) begin
		summand   <= testvectors[i][63:32];
		sum_check <= testvectors[i][31: 0];
		#(`T_CLK)

		if (sum_check != sum) begin
			$display("DATA MISMATCH! Data calculated: %0h, Data received: %0h", sum_check, sum);
		end else begin
			$display("DATA MATCH! Data calculated: %0h, Data received: %0h", sum_check, sum);
		end
	end
	$finish;
end

endmodule