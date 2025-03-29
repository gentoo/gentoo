# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dkms

DESCRIPTION="APFS module for linux, with experimental write support"
HOMEPAGE="https://github.com/linux-apfs/linux-apfs-rw"
SRC_URI="https://github.com/linux-apfs/linux-apfs-rw/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

CONFIG_CHECK="LIBCRC32C"

pkg_setup() {
	linux-mod-r1_pkg_setup
}

src_prepare() {
	default
	sed -e "s/GIT_COMMIT=.*/GIT_COMMIT=${PV}/" -i genver.sh || die
}

src_compile() {
	local modlist=( apfs=extra )
	local modargs=( KERNEL_DIR=${KV_OUT_DIR} KERNELRELEASE=${KV_FULL} )

	dkms_src_compile
}
