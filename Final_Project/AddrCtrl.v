module AddrCtrl (D0, D1, clk, Ctl, addr);
	input  [3:0] D0, D1;
	input  clk, Ctl;
	output [3:0] addr;
	reg    [3:0] addr, temp1, temp2;

	always @ (Ctl or D0 or D1) begin
		case (Ctl)
			0: temp1 = D0;
			1: temp1 = D1;
		endcase
	end

	always @ (posedge clk) begin
		addr = temp2;
		temp2 = temp1;
	end
endmodule