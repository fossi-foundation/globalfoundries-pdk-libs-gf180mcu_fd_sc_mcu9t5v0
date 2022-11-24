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

`ifndef GF180MCU_FD_SC_MCU9T5V0__FILLTIE_V
`define GF180MCU_FD_SC_MCU9T5V0__FILLTIE_V

`include gf180mcu_fd_sc_mcu9t5v0__filltie.v

`ifdef USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__filltie( VDD, VSS );
inout VDD, VSS;
`else // If not USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__filltie(  );
`endif // If not USE_POWER_PINS

`ifdef USE_POWER_PINS
  gf180mcu_fd_sc_mcu9t5v0__filltie_func gf180mcu_fd_sc_mcu9t5v0__filltie_inst(.VDD(VDD),.VSS(VSS));
`else // If not USE_POWER_PINS
  gf180mcu_fd_sc_mcu9t5v0__filltie_func gf180mcu_fd_sc_mcu9t5v0__filltie_inst();
`endif // If not USE_POWER_PINS

`ifndef FUNCTIONAL
	// spec_gates_begin


	// spec_gates_end



   specify

	// specify_block_begin

	// specify_block_end

   endspecify

   `endif

endmodule
`endif // GF180MCU_FD_SC_MCU9T5V0__FILLTIE_V
