#!/bin/sh

. /usr/share/grub/grub-mkconfig_lib

memtest_efi=/boot/memtest86-bin.efi

if [ -f "${memtest_efi}" ]; then
	echo "Found MemTest86-EFI" >&2
	device="$("${grub_probe}" --target=device "${memtest_efi}")"
	path="$(make_system_path_relative_to_its_root "${memtest_efi}")"
	cat <<EOF
if [ "x\$grub_platform" = xefi ]; then
	menuentry "MemTest86-EFI" {
EOF
	prepare_grub_to_access_device "${device}" | grub_add_tab
	cat <<EOF
		chainloader "${path}"
	}
fi
EOF
fi
