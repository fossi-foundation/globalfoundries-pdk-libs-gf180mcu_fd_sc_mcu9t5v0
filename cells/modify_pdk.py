#!/usr/bin/python

import os
import re
import glob

pdk_cells = os.listdir()

for cells in pdk_cells:
    udp_data = None
    udp_line = None
    if os.path.isdir(cells) and cells != "udp":
        func_pp_file_path = glob.glob(f"{cells}/gf180mcu_fd_sc_mcu9t5v0__{cells}*.functional.pp.v")[0]
        func_file_path = func_pp_file_path.replace(".pp", "")
        beh_pp_file_path = glob.glob(f"{cells}/gf180mcu_fd_sc_mcu9t5v0__{cells}*.behavioral.pp.v")
        beh_file_path = glob.glob(f"{cells}/gf180mcu_fd_sc_mcu9t5v0__{cells}*.behavioral.v")
        base_file_path = f"{cells}/gf180mcu_fd_sc_mcu9t5v0__{cells}_func.v"
        pp_file = open(func_pp_file_path, "r")
        ref_file = open(func_file_path, "r")
        base_file = open(base_file_path, "w")

        for num, line in enumerate(pp_file, 1):
            if line.startswith("//"):
                comment_line = num
            elif line.startswith("module"):
                module_line = num
                module = line
            elif line.startswith("input") or line.startswith("output") or line.startswith("inout"):
                interface_line = num
                if line.startswith("inout"):
                    power = line
            elif line.startswith("endmodule"):
                endmodule_line = num
            elif line.strip().startswith("UDP"):
                udp_line = num
                args_udp = re.search(".*UDP(\(.*;)", line).group(1)
                if "UDP_GF018hv5v_mcu_sc9_TT_5P0V_25C_verilog_pg_MGM_N_IQ_FF_UDP" in line:
                    udp_data = "gf180mcu_fd_sc_mcu9t5v0__N_IQ_FF_udp"
                elif "UDP_GF018hv5v_mcu_sc9_TT_5P0V_25C_verilog_pg_MGM_HN_IQ_FF_UDP" in line:
                    udp_data = "gf180mcu_fd_sc_mcu9t5v0__HN_IQ_FF_udp"
                elif "UDP_GF018hv5v_mcu_sc9_TT_5P0V_25C_verilog_pg_MGM_N_IQ_LATCH_UDP" in line:
                    udp_data = "gf180mcu_fd_sc_mcu9t5v0__N_IQ_LATCH_udp"
                elif "UDP_GF018hv5v_mcu_sc9_TT_5P0V_25C_verilog_pg_MGM_HN_IQ_LATCH_UDP" in line:
                    udp_data = "gf180mcu_fd_sc_mcu9t5v0__HN_IQ_LATCH_udp"
        pp_file.close()

        for num, line in enumerate(ref_file, 1):
            if num <= comment_line:
                base_file.write(line)
            elif num == comment_line + 1:
                base_file.write("\n")
                base_file.write("`ifndef " + f"GF180MCU_FD_SC_MCU9T5V0__{cells}_V\n".upper())
                base_file.write("`define " + f"GF180MCU_FD_SC_MCU9T5V0__{cells}_V\n\n".upper())
                if udp_data:
                    if "N_IQ_FF_udp" in udp_data:
                        base_file.write(f"`include \"../../models/N_IQ_FF_udp/{udp_data}.v\"\n\n")
                    elif "N_IQ_FF_udp" in udp_data:
                        base_file.write(f"`include \"../../models/HN_IQ_FF_udp/{udp_data}.v\"\n\n")
                    elif "N_IQ_FF_udp" in udp_data:
                        base_file.write(f"`include \"../../models/N_IQ_LATCH_udp/{udp_data}.v\"\n\n")
                    elif "N_IQ_FF_udp" in udp_data:
                        base_file.write(f"`include \"../../models/HN_IQ_LATCH_udp/{udp_data}.v\"\n\n")
                base_file.write("`ifdef USE_POWER_PINS\n")
            elif line.startswith("module"):
                base_file.write(re.sub("_*[0-9]*\(", "_func(", module))
                base_file.write(power)
                base_file.write("`else // If not USE_POWER_PINS\n")
                base_file.write(re.sub("_*[0-9]*\(", "_func(", line))
                base_file.write("`endif // If not USE_POWER_PINS\n")
            elif udp_data and num <= udp_line:
                if num < udp_line:
                    base_file.write(line)
                elif num == udp_line:
                    base_file.write(f"	{udp_data}{args_udp}\n")
            elif num <= endmodule_line:
                base_file.write(line)
        base_file.write("`endif " + f"// GF180MCU_FD_SC_MCU9T5V0__{cells}_V\n".upper())
        ref_file.close()
        base_file.close()

        for i in range(0,len(beh_pp_file_path)):
            count = 0
            beh_base_file_path = beh_pp_file_path[i].replace(".behavioral.pp","")
            beh_pp_file = open(beh_pp_file_path[i], "r")
            beh_file = open(beh_pp_file_path[i].replace(".pp",""), "r")
            beh_base_file = open(beh_base_file_path, "w")
            cell_name = re.search(".*__(.*).b.*", str(beh_pp_file_path[i])).group(1)

            for num, line in enumerate(beh_pp_file, 1):
                if line.startswith("//"):
                    comment_line = num
                elif line.startswith("module"):
                    module_line = num
                    module = line
                elif line.startswith("input") or line.startswith("output") or line.startswith("inout"):
                    interface_line = num
                    if line.startswith("inout"):
                        power = line
                elif "spec_gates_begin" in line:
                    begin_spec_line = num
                elif line.strip().startswith("gf180mcu_fd_sc_mcu9t5v0__"):
                    args_power = re.search(".*inst(\(.*;)", line).group(1)
                    func_line = num
                elif line.startswith("endmodule"):
                    endmodule_line = num
            beh_pp_file.close()
            
            for num, line in enumerate(beh_file, 1):
                if num <= comment_line:
                    beh_base_file.write(line)
                elif num == comment_line + 1:
                    beh_base_file.write("\n")
                    beh_base_file.write("`ifndef " + f"GF180MCU_FD_SC_MCU9T5V0__{cell_name}_V\n".upper())
                    beh_base_file.write("`define " + f"GF180MCU_FD_SC_MCU9T5V0__{cell_name}_V\n\n".upper())
                    beh_base_file.write(f"`include \"gf180mcu_fd_sc_mcu9t5v0__{cells}_func.v\"\n\n")
                    beh_base_file.write("`ifdef USE_POWER_PINS\n")
                elif line.startswith("module"):
                    beh_base_file.write(module)
                    beh_base_file.write(power)
                    beh_base_file.write("`else // If not USE_POWER_PINS\n")
                    beh_base_file.write(line)
                    beh_base_file.write("`endif // If not USE_POWER_PINS\n")
                elif line.startswith("input") or line.startswith("output"):
                    beh_base_file.write(line)
                
                elif line.strip().startswith("gf180mcu_fd_sc_mcu9t5v0__") and count == 0:
                    beh_base_file.write("\n")
                    args = re.search(".*inst(\(.*;)", line).group(1)
                    beh_base_file.write("`ifdef USE_POWER_PINS\n")
                    beh_base_file.write(f"  gf180mcu_fd_sc_mcu9t5v0__{cells}_func gf180mcu_fd_sc_mcu9t5v0__{cells}_inst{args_power}\n")
                    beh_base_file.write("`else // If not USE_POWER_PINS\n")
                    beh_base_file.write(f"  gf180mcu_fd_sc_mcu9t5v0__{cells}_func gf180mcu_fd_sc_mcu9t5v0__{cells}_inst{args}\n")
                    beh_base_file.write("`endif // If not USE_POWER_PINS\n\n")
                    beh_base_file.write("`ifndef FUNCTIONAL\n")
                    count = 1
                
                elif "spec_gates_begin" in line:
                    beh_base_file.write(line)
                    begin_spec_line = num

                elif num <= endmodule_line and num >= begin_spec_line:
                    beh_base_file.write(line)
            beh_base_file.write("`endif " + f"// GF180MCU_FD_SC_MCU9T5V0__{cell_name}_V\n".upper())
            beh_file.close()
            beh_base_file.close()
