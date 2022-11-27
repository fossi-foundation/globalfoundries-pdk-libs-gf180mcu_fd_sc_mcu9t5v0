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

`ifndef GF180MCU_FD_SC_MCU9T5V0__MUX2_V
`define GF180MCU_FD_SC_MCU9T5V0__MUX2_V

`include "../udp/udp_primitives.v"

`ifdef USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__mux2_func( Z, I1, S, I0, VDD, VSS );
inout VDD, VSS;
`else // If not USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__mux2_func( Z, I1, S, I0 );
`endif // If not USE_POWER_PINS
input I0, I1, S;
output Z;

	wire Z_row1;

	and MGM_BG_0( Z_row1, I0, I1 );

	wire S_inv_for_gf180mcu_fd_sc_mcu9t5v0__mux2_2;

	not MGM_BG_1( S_inv_for_gf180mcu_fd_sc_mcu9t5v0__mux2_2, S );

	wire Z_row2;

	and MGM_BG_2( Z_row2, S_inv_for_gf180mcu_fd_sc_mcu9t5v0__mux2_2, I0 );

	wire Z_row3;

	and MGM_BG_3( Z_row3, I1, S );

	or MGM_BG_4( Z, Z_row1, Z_row2, Z_row3 );

endmodule
`endif // GF180MCU_FD_SC_MCU9T5V0__MUX2_V
