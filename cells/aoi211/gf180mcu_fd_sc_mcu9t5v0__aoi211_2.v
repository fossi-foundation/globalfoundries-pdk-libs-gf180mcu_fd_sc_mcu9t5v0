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

`ifndef GF180MCU_FD_SC_MCU9T5V0__AOI211_2_V
`define GF180MCU_FD_SC_MCU9T5V0__AOI211_2_V

`include gf180mcu_fd_sc_mcu9t5v0__aoi211.v

`ifdef USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__aoi211_2( A2, ZN, A1, B, C, VDD, VSS );
inout VDD, VSS;
`else // If not USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__aoi211_2( A2, ZN, A1, B, C );
`endif // If not USE_POWER_PINS
input A1, A2, B, C;
output ZN;

`ifdef USE_POWER_PINS
  gf180mcu_fd_sc_mcu9t5v0__aoi211_func gf180mcu_fd_sc_mcu9t5v0__aoi211_inst(.A2(A2),.ZN(ZN),.A1(A1),.B(B),.C(C),.VDD(VDD),.VSS(VSS));
`else // If not USE_POWER_PINS
  gf180mcu_fd_sc_mcu9t5v0__aoi211_func gf180mcu_fd_sc_mcu9t5v0__aoi211_inst(.A2(A2),.ZN(ZN),.A1(A1),.B(B),.C(C));
`endif // If not USE_POWER_PINS

`ifndef FUNCTIONAL
	// spec_gates_begin


	// spec_gates_end



   specify

	// specify_block_begin

	// comb arc A1 --> ZN
	 (A1 => ZN) = (1.0,1.0);

	// comb arc A2 --> ZN
	 (A2 => ZN) = (1.0,1.0);

	if(A1===1'b0 && A2===1'b0)
	// comb arc B --> ZN
	 (B => ZN) = (1.0,1.0);

	if(A1===1'b0 && A2===1'b1)
	// comb arc B --> ZN
	 (B => ZN) = (1.0,1.0);

	if(A1===1'b1 && A2===1'b0)
	// comb arc B --> ZN
	 (B => ZN) = (1.0,1.0);

	ifnone
	// comb arc B --> ZN
	 (B => ZN) = (1.0,1.0);

	if(A1===1'b0 && A2===1'b0)
	// comb arc C --> ZN
	 (C => ZN) = (1.0,1.0);

	if(A1===1'b0 && A2===1'b1)
	// comb arc C --> ZN
	 (C => ZN) = (1.0,1.0);

	if(A1===1'b1 && A2===1'b0)
	// comb arc C --> ZN
	 (C => ZN) = (1.0,1.0);

	ifnone
	// comb arc C --> ZN
	 (C => ZN) = (1.0,1.0);

	// specify_block_end

   endspecify

   `endif

endmodule
`endif // GF180MCU_FD_SC_MCU9T5V0__AOI211_2_V
