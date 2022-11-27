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

`ifndef GF180MCU_FD_SC_MCU9T5V0__DFFQ_V
`define GF180MCU_FD_SC_MCU9T5V0__DFFQ_V

`include "../../models/N_IQ_FF_udp/gf180mcu_fd_sc_mcu9t5v0__N_IQ_FF_udp.v"

`ifdef USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__dffq_func( CLK, D, Q, VDD, VSS, notifier );
inout VDD, VSS;
`else // If not USE_POWER_PINS
module gf180mcu_fd_sc_mcu9t5v0__dffq_func( CLK, D, Q, notifier );
`endif // If not USE_POWER_PINS
input CLK, D, notifier;
output Q;

	not MGM_BG_0( MGM_D0, D );

	gf180mcu_fd_sc_mcu9t5v0__N_IQ_FF_udp( IQ1, 1'b0, 1'b0, CLK, MGM_D0, notifier );

	not MGM_BG_1( Q, IQ1 );

endmodule
`endif // GF180MCU_FD_SC_MCU9T5V0__DFFQ_V
