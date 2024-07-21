# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit linux-info multiprocessing

DESCRIPTION="Broadcom Bluetooth firmware"
HOMEPAGE="https://github.com/winterheart/broadcom-bt-firmware"
SRC_URI="https://github.com/winterheart/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="broadcom_bcm20702 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 x86"
# Re-use compress-* USE flags from sys-kernel/linux-firmware.
IUSE="compress-xz compress-zstd"
REQUIRED_USE="?? ( compress-xz compress-zstd )"

BDEPEND="
	compress-xz? ( app-arch/xz-utils )
	compress-zstd? ( app-arch/zstd )
"

pkg_setup() {
	if use compress-xz || use compress-zstd ; then
		local CONFIG_CHECK

		if kernel_is -ge 5 19; then
			use compress-xz && CONFIG_CHECK="~FW_LOADER_COMPRESS_XZ"
			use compress-zstd && CONFIG_CHECK="~FW_LOADER_COMPRESS_ZSTD"
		else
			use compress-xz && CONFIG_CHECK="~FW_LOADER_COMPRESS"
			if use compress-zstd; then
				eerror "Kernels <5.19 do not support ZSTD-compressed firmware files"
			fi
		fi
		linux-info_pkg_setup
	fi
}

src_install() {
	insinto /lib/firmware
	doins -r brcm

	if use compress-xz || use compress-zstd; then
		pushd "${ED}/lib/firmware/brcm" &>/dev/null || die
		einfo "Compressing firmware ..."
		local ext
		local compressor

		if use compress-xz; then
			ext=xz
			compressor="xz -T1 -C crc32"
		elif use compress-zstd; then
			ext=zst
			compressor="zstd -15 -T1 -C -q --rm"
		fi
		find . -type f -print0 | \
			xargs -0 -P $(makeopts_jobs) -I'{}' ${compressor} '{}'
	assert
		popd &>/dev/null || die
	fi
	dodoc DEVICES.md README.md
}
