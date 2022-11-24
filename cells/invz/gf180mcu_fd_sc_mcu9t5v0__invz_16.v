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

`ifndef GF180MCU_FD_SC_MCU9T5V0__INVZ_16_V
`define GF180MCU_FD_SC_MCU9T5V0__INVZ_16_V

`include gf180mcu_fd_sc_mcu9t5v0__invz.v

`ifdef USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__invz_16( EN, I, ZN, VDD, VSS );
inout VDD, VSS;
`else // If not USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__invz_16( EN, I, ZN );
`endif // If not USE_POWER_PINS
input EN, I;
output ZN;

`ifdef USE_POWER_PINS
  gf180mcu_fd_sc_mcu9t5v0__invz_func gf180mcu_fd_sc_mcu9t5v0__invz_inst(.EN(EN),.I(I),.ZN(ZN),.VDD(VDD),.VSS(VSS));
`else // If not USE_POWER_PINS
  gf180mcu_fd_sc_mcu9t5v0__invz_func gf180mcu_fd_sc_mcu9t5v0__invz_inst(.EN(EN),.I(I),.ZN(ZN));
`endif // If not USE_POWER_PINS

`ifndef FUNCTIONAL
	// spec_gates_begin


	// spec_gates_end



   specify

	// specify_block_begin

	// comb arc EN --> ZN
	 (EN => ZN) = (1.0,1.0);

	// comb arc I --> ZN
	 (I => ZN) = (1.0,1.0);

	// specify_block_end

   endspecify

   `endif

endmodule
`endif // GF180MCU_FD_SC_MCU9T5V0__INVZ_16_V
