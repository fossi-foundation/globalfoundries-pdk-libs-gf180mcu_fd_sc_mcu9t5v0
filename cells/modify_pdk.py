#!/usr/bin/python

import os
import re
import glob
pdk_cells = os.listdir()

for cells in pdk_cells:
    if os.path.isdir(cells):
        func_pp_file_path = glob.glob(f"{cells}/gf180mcu_fd_sc_mcu9t5v0__{cells}*.functional.pp.v")[0]
        func_file_path = glob.glob(f"{cells}/gf180mcu_fd_sc_mcu9t5v0__{cells}*.functional.v")[0]
        beh_pp_file_path = glob.glob(f"{cells}/gf180mcu_fd_sc_mcu9t5v0__{cells}*.behavioral.pp.v")
        beh_file_path = glob.glob(f"{cells}/gf180mcu_fd_sc_mcu9t5v0__{cells}*.behavioral.v")
        base_file_path = f"{cells}/gf180mcu_fd_sc_mcu9t5v0__{cells}.v"
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
        pp_file.close()

        for num, line in enumerate(ref_file, 1):
            if num <= comment_line:
                base_file.write(line)
            elif num == comment_line + 1:
                base_file.write("\n")
                base_file.write("`ifndef " + f"GF180MCU_FD_SC_MCU9T5V0__{cells}_V\n".upper())
                base_file.write("`define " + f"GF180MCU_FD_SC_MCU9T5V0__{cells}_V\n".upper())
                base_file.write("\n")
                base_file.write("`ifdef USE_POWER_PINS\n")
            elif line.startswith("module"):
                base_file.write(re.sub("_*[0-9]*\(", "_func(", module))
                base_file.write(power)
                base_file.write("`else // If not USE_POWER_PINS\n")
                base_file.write(re.sub("_*[0-9]*\(", "_func(", line))
                base_file.write("`endif // If not USE_POWER_PINS\n")
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
                    beh_base_file.write(f"`include \"gf180mcu_fd_sc_mcu9t5v0__{cells}.v\"\n\n")
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
