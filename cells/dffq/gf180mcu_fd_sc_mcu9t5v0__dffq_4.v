// Copyright 2022 GlobalFoundries PDK Authors
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

`ifndef GF180MCU_FD_SC_MCU9T5V0__DFFQ_4_V
`define GF180MCU_FD_SC_MCU9T5V0__DFFQ_4_V

`include "gf180mcu_fd_sc_mcu9t5v0__dffq.v"

`ifdef USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__dffq_4( CLK, D, Q, VDD, VSS );
inout VDD, VSS;
`else // If not USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__dffq_4( CLK, D, Q );
`endif // If not USE_POWER_PINS
input CLK, D;
output Q;

`ifdef USE_POWER_PINS
  gf180mcu_fd_sc_mcu9t5v0__dffq_func gf180mcu_fd_sc_mcu9t5v0__dffq_inst(.CLK(CLK),.D(D),.Q(Q),.VDD(VDD),.VSS(VSS),.notifier(notifier));
`else // If not USE_POWER_PINS
  gf180mcu_fd_sc_mcu9t5v0__dffq_func gf180mcu_fd_sc_mcu9t5v0__dffq_inst(.CLK(CLK),.D(D),.Q(Q),.notifier(notifier));
`endif // If not USE_POWER_PINS

`ifndef FUNCTIONAL
	// spec_gates_begin


	not MGM_G0(ENABLE_NOT_D,D);


	buf MGM_G1(ENABLE_D,D);


	// spec_gates_end



   specify

	// specify_block_begin

	// seq arc CLK --> Q
	(posedge CLK => (Q : D))  = (1.0,1.0);

	$width(negedge CLK &&& (ENABLE_NOT_D === 1'b1)
		,1.0,0,notifier);

	$width(posedge CLK &&& (ENABLE_NOT_D === 1'b1)
		,1.0,0,notifier);

	$width(negedge CLK &&& (ENABLE_D === 1'b1)
		,1.0,0,notifier);

	$width(posedge CLK &&& (ENABLE_D === 1'b1)
		,1.0,0,notifier);

	// hold D-HL CLK-LH
	$hold(posedge CLK,negedge D,1.0,notifier);

	// hold D-LH CLK-LH
	$hold(posedge CLK,posedge D,1.0,notifier);

	// setup D-HL CLK-LH
	$setup(negedge D,posedge CLK,1.0,notifier);

	// setup D-LH CLK-LH
	$setup(posedge D,posedge CLK,1.0,notifier);

	// mpw CLK_lh
	$width(posedge CLK,1.0,0,notifier);

	// mpw CLK_hl
	$width(negedge CLK,1.0,0,notifier);

	// period CLK
	$period(posedge CLK &&& (ENABLE_NOT_D === 1'b1)
		,1.0,notifier);

	// period CLK
	$period(posedge CLK &&& (ENABLE_D === 1'b1)
		,1.0,notifier);

	// period CLK
	$period(posedge CLK,1.0,notifier);

	// specify_block_end

   endspecify

   `endif

endmodule
`endif // GF180MCU_FD_SC_MCU9T5V0__DFFQ_4_V
