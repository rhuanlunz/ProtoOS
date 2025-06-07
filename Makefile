CC			= nasm
CC_FLAGS	= -f bin -o
QEMU		= qemu-system-i386
QEMU_FLAGS	= -fda

BOOTLOADER	= ./src/boot/bootloader.asm
KERNEL		= ./src/kernel/kernel.asm
BUILD_DIR	= ./build

DISK_IMAGE	= ./build/ProtoOS.img


all: clean create_build_dir build_binaries build_disk_image run

create_build_dir:
	@echo "</> Creating ./build directory."

	@test -d $(BUILD_DIR) || mkdir $(BUILD_DIR)


build_binaries: $(BUILD_DIR) $(BOOTLOADER) $(KERNEL)
	@echo "</> Building binaries."

	@$(CC) $(BOOTLOADER) $(CC_FLAGS) $(BUILD_DIR)/bootloader.bin

	@$(CC) $(KERNEL) $(CC_FLAGS) $(BUILD_DIR)/kernel.bin


build_disk_image:
	@echo "</> Building disk image."
	
	@dd if=/dev/zero of=$(DISK_IMAGE) bs=512 count=1 conv=notrunc
	
	@dd if=$(BUILD_DIR)/bootloader.bin of=$(DISK_IMAGE) bs=512 seek=0 count=1 conv=notrunc

	@dd if=$(BUILD_DIR)/kernel.bin of=$(DISK_IMAGE) bs=512 seek=1 count=5 conv=notrunc

	@rm -rf *.bin


run: $(DISK_IMAGE)
	@echo "</> Running ProtoOS."

	@$(QEMU) $(QEMU_FLAGS) $(DISK_IMAGE)

	@clear

clean:
	@echo "</> Cleaning build directory."

	@rm -rf $(BUILD_DIR)/*