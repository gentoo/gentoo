# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nvidia-driver.eclass
# @MAINTAINER:
# Jeroen Roovers <jer@gentoo.org>
# @AUTHOR:
# Original author: Doug Goldstein <cardoe@gentoo.org>
# @BLURB: Provide useful messages for nvidia-drivers
# @DESCRIPTION:
# Provide useful messages for nvidia-drivers based on currently installed
# Nvidia GPU and Linux kernel.

inherit readme.gentoo-r1

DEPEND="sys-apps/pciutils"
RESTRICT="bindist mirror test"

# Variables for readme.gentoo.eclass:
DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You must be in the video group to use the NVIDIA device
For more info, read the docs at
https://www.gentoo.org/doc/en/nvidia-guide.xml#doc_chap3_sect6

This ebuild installs a kernel module and X driver. Both must
match explicitly in their version. This means, if you restart
X, you must modprobe -r nvidia before starting it back up

To use the NVIDIA GLX, run \"eselect opengl set nvidia\"

To use the NVIDIA CUDA/OpenCL, run \"eselect opencl set nvidia\"

NVIDIA has requested that any bug reports submitted have the
output of nvidia-bug-report.sh included.
"

# the data below is derived from
# http://us.download.nvidia.com/XFree86/Linux-x86_64/396.18/README/supportedchips.html

drv_71xx="
	0020 0028 0029 002c 002d 00a0 0100 0101 0103 0150 0151 0152 0153
"

drv_96xx="
	0110 0111 0112 0113 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 017a
	017c 017d 0181 0182 0183 0185 0188 018a 018b 018c 01a0 01f0 0200 0201 0202
	0203 0250 0251 0253 0258 0259 025b 0280 0281 0282 0286 0288 0289 028c
"

drv_173x="
	00fa 00fb 00fc 00fd 00fe 0301 0302 0308 0309 0311 0312 0314 031a 031b 031c
	0320 0321 0322 0323 0324 0325 0326 0327 0328 032a 032b 032c 032d 0330 0331
	0332 0333 0334 0338 033f 0341 0342 0343 0344 0347 0348 034c 034e
"

drv_304x="
	0040 0041 0042 0043 0044 0045 0046 0047 0048 004e 0090 0091 0092 0093 0095
	0098 0099 009d 00c0 00c1 00c2 00c3 00c8 00c9 00cc 00cd 00ce 00f1 00f2 00f3
	00f4 00f5 00f6 00f8 00f9 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149
	014a 014c 014d 014e 014f 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169
	016a 01d0 01d1 01d2 01d3 01d6 01d7 01d8 01da 01db 01dc 01dd 01de 01df 0211
	0212 0215 0218 0221 0222 0240 0241 0242 0244 0245 0247 0290 0291 0292 0293
	0294 0295 0297 0298 0299 029a 029b 029c 029d 029e 029f 02e0 02e1 02e2 02e3
	02e4 038b 0390 0391 0392 0393 0394 0395 0397 0398 0399 039c 039e 03d0 03d1
	03d2 03d5 03d6 0531 0533 053a 053b 053e 07e0 07e1 07e2 07e3 07e5
"

drv_340x="
	0191 0193 0194 0197 019d 019e 0400 0401 0402 0403 0404 0405 0406 0407 0408
	0409 040a 040b 040c 040d 040e 040f 0410 0420 0421 0422 0423 0424 0425 0426
	0427 0428 0429 042a 042b 042c 042d 042e 042f 05e0 05e1 05e2 05e3 05e6 05e7
	05e7 05e7 05e7 05e7 05e7 05ea 05eb 05ed 05f8 05f9 05fd 05fe 05ff 0600 0601
	0602 0603 0604 0605 0606 0607 0608 0609 0609 060a 060b 060c 060d 060f 0610
	0611 0612 0613 0614 0615 0617 0618 0619 061a 061b 061c 061d 061e 061f 0621
	0622 0623 0625 0626 0627 0628 062a 062b 062c 062d 062e 062e 0630 0631 0632
	0635 0637 0638 063a 0640 0641 0643 0644 0645 0646 0647 0648 0649 0649 064a
	064b 064c 0651 0652 0652 0653 0654 0654 0654 0655 0656 0658 0659 065a 065b
	065c 06e0 06e1 06e2 06e3 06e4 06e5 06e6 06e7 06e8 06e8 06e9 06ea 06eb 06ec
	06ef 06f1 06f8 06f9 06f9 06fa 06fb 06fd 06ff 06ff 0840 0844 0845 0846 0847
	0848 0849 084a 084b 084c 084d 084f 0860 0861 0862 0863 0864 0865 0866 0866
	0867 0868 0869 086a 086c 086d 086e 086f 0870 0871 0872 0872 0873 0873 0874
	0876 087a 087d 087e 087f 08a0 08a2 08a3 08a4 08a5 0a20 0a22 0a23 0a26 0a27
	0a28 0a29 0a2a 0a2b 0a2c 0a2d 0a32 0a34 0a35 0a38 0a3c 0a60 0a62 0a63 0a64
	0a65 0a66 0a67 0a68 0a69 0a6a 0a6c 0a6e 0a6e 0a6f 0a70 0a70 0a70 0a71 0a72
	0a73 0a73 0a73 0a74 0a74 0a75 0a75 0a76 0a78 0a7a 0a7a 0a7a 0a7a 0a7a 0a7a
	0a7a 0a7a 0a7a 0a7a 0a7a 0a7c 0ca0 0ca2 0ca3 0ca4 0ca5 0ca7 0ca8 0ca9 0cac
	0caf 0cb0 0cb1 0cbc 10c0 10c3 10c5 10d8
"

drv_390x="
	06c0 06c4 06ca 06cd 06d1 06d2 06d8 06d9 06da 06dc 06dd 06de 06df 0dc0 0dc4
	0dc5 0dc6 0dcd 0dce 0dd1 0dd2 0dd3 0dd6 0dd8 0dda 0de0 0de1 0de2 0de3 0de4
	0de5 0de7 0de8 0de9 0dea 0deb 0dec 0ded 0dee 0def 0df0 0df1 0df2 0df3 0df4
	0df5 0df6 0df7 0df8 0df9 0dfa 0dfc 0e22 0e23 0e24 0e30 0e31 0e3a 0e3b 0f00
	0f01 0f02 0f03 1040 1042 1048 1049 104a 104b 104c 1050 1051 1052 1054 1055
	1056 1057 1058 1059 105a 105b 107c 107d 1080 1081 1082 1084 1086 1087 1088
	1089 108b 1091 1094 1096 109a 109b 1140 1200 1201 1203 1205 1206 1207 1208
	1210 1211 1212 1213 1241 1243 1244 1245 1246 1247 1248 1249 124b 124d 1251
"

mask_71xx=">=x11-drivers/nvidia-drivers-72.0.0"
mask_96xx=">=x11-drivers/nvidia-drivers-97.0.0"
mask_173x=">=x11-drivers/nvidia-drivers-177.0.0"
mask_304x=">=x11-drivers/nvidia-drivers-305.0.0"
mask_340x=">=x11-drivers/nvidia-drivers-341.0.0"
mask_390x=">=x11-drivers/nvidia-drivers-391.0.0"

# @FUNCTION: nvidia-driver_get_gpu
# @DESCRIPTION:
# Retrieve the PCI device ID for each Nvidia GPU you have
nvidia-driver_get_gpu() {
	local NVIDIA_CARD=$(
		[ -x /usr/sbin/lspci ] && /usr/sbin/lspci -d 10de: -n \
			| awk -F'[: ]' '/ 03[0-9][0-9]: /{print $6}'
	)

	if [ -n "${NVIDIA_CARD}" ]; then
		echo "${NVIDIA_CARD}"
	else
		echo 0000
	fi
}

nvidia-driver_get_mask() {
	local nvidia_gpus="$(nvidia-driver_get_gpu)"
	local nvidia_gpu drv

	for nvidia_gpu in ${nvidia_gpus}; do
		for drv in ${drv_71xx}; do
			if [ "x${nvidia_gpu}" = "x${drv}" ]; then
				echo "${mask_71xx}"
				return 0
			fi
		done

		for drv in ${drv_96xx}; do
			if [ "x${nvidia_gpu}" = "x${drv}" ]; then
				echo "${mask_96xx}"
				return 0
			fi
		done

		for drv in ${drv_173x}; do
			if [ "x${nvidia_gpu}" = "x${drv}" ]; then
				echo "${mask_173x}"
				return 0
			fi
		done

		for drv in ${drv_304x}; do
			if [ "x${nvidia_gpu}" = "x${drv}" ]; then
				echo "${mask_304x}"
				return 0
			fi
		done

		for drv in ${drv_340x}; do
			if [ "x${nvidia_gpu}" = "x${drv}" ]; then
				echo "${mask_340x}"
				return 0
			fi
		done

		for drv in ${drv_390x}; do
			if [ "x${nvidia_gpu}" = "x${drv}" ]; then
				echo "${mask_390x}"
				return 0
			fi
		done
	done

	echo ''
	return 1
}

# @FUNCTION: nvidia-driver_check_gpu
# @DESCRIPTION:
# Prints out a warning if the driver does not work with the installed GPU
nvidia-driver_check_gpu() {
	local nvidia_mask="$(nvidia-driver_get_mask)"

	if [ -n "${nvidia_mask}" ]; then
		if ver_test "${nvidia_mask##*-}" -lt "${PV}" ; then
			ewarn "***** WARNING *****"
			ewarn
			ewarn "You are currently installing a version of nvidia-drivers that is"
			ewarn "known not to work with a GPU you have installed on your system."
			ewarn "If this is intentional, please ignore this. If it is not please"
			ewarn "perform the following steps:"
			ewarn
			ewarn "Add the following mask entry to the local package.mask file:"
			if [ -d "${ROOT}/etc/portage/package.mask" ]; then
				ewarn "echo \"${nvidia_mask}\" > /etc/portage/package.mask/nvidia-drivers"
			else
				ewarn "echo \"${nvidia_mask}\" >> /etc/portage/package.mask"
			fi
			ewarn
			ewarn "Failure to perform the steps above could result in a non-working"
			ewarn "X setup."
			ewarn
			ewarn "For more information please read:"
			ewarn "http://www.nvidia.com/object/IO_32667.html"
		fi
	fi
}

nvidia-driver_check_kernel() {
	if kernel_is ge $(ver_cut 1 ${NV_KV_MAX_PLUS}) $(ver_cut 2 ${NV_KV_MAX_PLUS}); then
		ewarn "Gentoo supports kernels which are supported by NVIDIA"
		ewarn "which are limited to the following kernels:"
		ewarn "<sys-kernel/gentoo-sources-${NV_KV_MAX_PLUS}"
		ewarn "<sys-kernel/vanilla-sources-${NV_KV_MAX_PLUS}"
		ewarn ""
		ewarn "You are free to utilize eapply_user to provide whatever"
		ewarn "support you feel is appropriate, but will not receive"
		ewarn "support as a result of those changes."
		ewarn ""
		ewarn "Do not file a bug report about this."
		ewarn ""
	fi

	check_extra_config
}

nvidia-driver_check() {
	if use amd64 && has_multilib_profile && \
		[ "${DEFAULT_ABI}" != "amd64" ]; then
		eerror "This ebuild doesn't currently support changing your default ABI"
		die "Unexpected \${DEFAULT_ABI} = ${DEFAULT_ABI}"
	fi

	# Since Nvidia ships many different series of drivers, we need to give the user
	# some kind of guidance as to what version they should install. This tries
	# to point the user in the right direction but can't be perfect. check
	# nvidia-driver.eclass
	nvidia-driver_check_gpu

	use kernel_linux && nvidia-driver_check_kernel
}
