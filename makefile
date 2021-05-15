install: clean bs_bin cmdTbl_bin k_bin clear_bin prntRegs_bin reboot_bin shutdown_bin
		cat bin/boot.bin bin/commandTable.bin bin/kernel.bin commands/bin/clear.bin commands/bin/printRegisters.bin commands/bin/reboot.bin commands/bin/shutdown.bin > OS.bin
		mv OS.bin bin

install2: bs_bin cmdTbl_bin k_bin clear_bin prntRegs_bin reboot_bin shutdown_bin
		cat bin/boot.bin bin/commandTable.bin bin/kernel.bin commands/bin/clear.bin commands/bin/printRegisters.bin commands/bin/reboot.bin commands/bin/shutdown.bin > OS.bin
		mv OS.bin bin

launch:
		qemu-system-x86_64 -fda bin/OS.bin

bs_bin:
		nasm -f bin -o boot.bin bootsector.nasm
		mv boot.bin bin

k_bin:
		nasm -f bin -o kernel.bin kernel.nasm
		mv kernel.bin bin

cmdTbl_bin:
		nasm -f bin -o commandTable.bin commandTable.nasm
		mv commandTable.bin bin

clear_bin:
		nasm -f bin -o clear.bin commands/clear.nasm
		mv clear.bin commands/bin

reboot_bin:
		nasm -f bin -o reboot.bin commands/reboot.nasm
		mv reboot.bin commands/bin

prntRegs_bin:
		nasm -f bin -o printRegisters.bin commands/printRegisters.nasm
		mv printRegisters.bin commands/bin

shutdown_bin:
		nasm -f bin -o shutdown.bin commands/shutdown.nasm
		mv shutdown.bin commands/bin

clean:
		rm bin/*.bin commands/bin/*.bin
