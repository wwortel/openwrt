define Device/mikrotik_nor
	DEVICE_VENDOR := MikroTik
	BLOCKSIZE := 64k
	IMAGE_SIZE := 16128k
	KERNEL_NAME := vmlinux
	KERNEL := kernel-bin | append-dtb-elf
	IMAGES = sysupgrade.bin
	IMAGE/sysupgrade.bin := append-kernel | kernel2minor -s 1024 | \
		pad-to $$$$(BLOCKSIZE) | append-rootfs | pad-rootfs | \
		check-size | append-metadata
endef

define Device/mikrotik_nand
	DEVICE_VENDOR := MikroTik
	KERNEL_NAME := vmlinux
	KERNEL_INITRAMFS := kernel-bin | append-dtb-elf
	KERNEL := kernel-bin | append-dtb-elf | package-kernel-ubifs | \
		ubinize-kernel
	IMAGES := nand-sysupgrade.bin
	IMAGE/nand-sysupgrade.bin := sysupgrade-tar | append-metadata
endef

define Device/mikrotik_cap-ac
	$(call Device/mikrotik_nor)
	DEVICE_MODEL := cAP ac
	SOC := qcom-ipq4018
	DEVICE_PACKAGES := -kmod-ath10k-ct kmod-ath10k-ct-smallbuffers
endef
TARGET_DEVICES += mikrotik_cap-ac

define Device/mikrotik_7442a-lhg5acd
	$(call Device/mikrotik_nor)
	SOC := qcom-ipq4018
	DEVICE_PACKAGES := rssileds \
		-kmod-ath10k-ct -kmod-ath10k-ct-smallbuffers kmod-ath10k \
		-ath10k-firmware-qca4019-ct ath10k-firmware-qca4019 \
		-kmod-usb-dwc3-qcom -swconfig -kmod-usb3 -kmod-usb-dwc3
endef

define Device/mikrotik_hap-ac2
	$(call Device/mikrotik_nor)
	DEVICE_MODEL := hAP ac2
	SOC := qcom-ipq4018
	DEVICE_PACKAGES := -kmod-ath10k -kmod-ath10k-ct \
		kmod-ath10k-ct-smallbuffers
endef
TARGET_DEVICES += mikrotik_hap-ac2

define Device/mikrotik_hap-ac3
	$(call Device/mikrotik_nand)
	DEVICE_MODEL := hAP ac3
	SOC := qcom-ipq4019
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	KERNEL_UBIFS_OPTS = -m $$(PAGESIZE) -e 124KiB -c $$(PAGESIZE) -x none
	DEVICE_PACKAGES := kmod-ledtrig-gpio \
		-kmod-ath10k-ct -kmod-ath10k-ct-smallbuffers kmod-ath10k \
		-ath10k-firmware-qca4019-ct ath10k-firmware-qca4019
endef
TARGET_DEVICES += mikrotik_hap-ac3

define Device/mikrotik_lhgg-60ad
	$(call Device/mikrotik_nor)
	DEVICE_MODEL := Wireless Wire Dish LHGG-60ad
	DEVICE_DTS := qcom-ipq4019-lhgg-60ad
	DEVICE_PACKAGES += -kmod-ath10k-ct -ath10k-firmware-qca4019-ct kmod-wil6210
endef
TARGET_DEVICES += mikrotik_lhgg-60ad

define Device/mikrotik_ldf-5-ac
	$(call Device/mikrotik_7442a-lhg5acd)
	DEVICE_MODEL := LDF 5 ac (RBLDFG-5acD)
endef
TARGET_DEVICES += mikrotik_ldf-5-ac

define Device/mikrotik_lhg-5-ac
	$(call Device/mikrotik_7442a-lhg5acd)
	DEVICE_MODEL := LHG [XL] 5 ac (RBLHGG-5acD[-XL])
endef
TARGET_DEVICES += mikrotik_lhg-5-ac

define Device/mikrotik_sxtsq-5-ac
	$(call Device/mikrotik_7442a-lhg5acd)
	DEVICE_MODEL := SXTsq 5 ac (RBSXTsqG-5acD)
endef
TARGET_DEVICES += mikrotik_sxtsq-5-ac
