// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

//`timescale 1 ns / 1 ps

module xvlog_tb;
	reg clock;
    reg RSTB;

	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	wire sys_clk = clock;
	wire sys_rst = ~RSTB;
	reg state = 1'd0;
	reg next_state = 1'd0;
	reg mgmtsoc_wishbone_cyc;
	reg mgmtsoc_wishbone_stb;

	initial begin
		$dumpfile("xvlog.vcd");
		$dumpvars(0, xvlog_tb);

	end


	initial begin
		RSTB <= 1'b0;
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#1700;
		@ (posedge sys_clk);
		mgmtsoc_wishbone_cyc <= 1;
		mgmtsoc_wishbone_stb <= 1;
		@ (posedge sys_clk);
		mgmtsoc_wishbone_cyc <= 0;
		mgmtsoc_wishbone_stb <= 0;
		@ (posedge sys_clk);
		mgmtsoc_wishbone_cyc <= 1;
		mgmtsoc_wishbone_stb <= 1;
		@ (posedge sys_clk);
		mgmtsoc_wishbone_cyc <= 0;
		mgmtsoc_wishbone_stb <= 0;
		@ (posedge sys_clk);
		mgmtsoc_wishbone_cyc <= 1;
		mgmtsoc_wishbone_stb <= 1;
		@ (posedge sys_clk);
		mgmtsoc_wishbone_cyc <= 0;
		mgmtsoc_wishbone_stb <= 0;

		$finish;
		
	end

always @(next_state) begin
	$display($time, "=> dump next_state=%x", next_state);
end

always @(mgmtsoc_wishbone_cyc) begin
	$display($time, "=> dump mgmtsoc_wishbone_cyc=%x", mgmtsoc_wishbone_cyc);
end

always @(mgmtsoc_wishbone_stb) begin
	$display($time, "=> dump mgmtsoc_wishbone_stb=%x", mgmtsoc_wishbone_stb);
end

always @(state) begin
	$display($time, "=> dump state=%x", state);
end    

always @(*) begin
	$display($time, "=> checkpoint 1");
	next_state = 1'd0;
	$display($time, "=> checkpoint 2");
	next_state = state;
	$display($time, "=> checkpoint 3");
	case (state)
		1'd1: begin
	        $display($time, "=> checkpoint 4");
			next_state = 1'd0;
		end
		default: begin
	        $display($time, "=> checkpoint 5");
			if ((mgmtsoc_wishbone_cyc & mgmtsoc_wishbone_stb)) begin
	            $display($time, "=> checkpoint 6");
				next_state = 1'd1;
			end
		end
	endcase
end

always @(posedge sys_clk) begin
    state <= next_state;
    if (sys_rst) begin
		state <= 0;
	end
	
end

endmodule
`default_nettype wire

