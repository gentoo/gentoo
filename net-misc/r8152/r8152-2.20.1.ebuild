# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1 udev

DESCRIPTION="r8152 driver for Realtek USB FE / GBE / 2.5G Gaming Ethernet Family Controller"
# Using github readme as homepage as the realtek page has changed location twice in six months.
HOMEPAGE="https://github.com/jayofdoom/realtek-r8152-unchanged"
SRC_URI="https://github.com/jayofdoom/realtek-r8152-unchanged/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/realtek-r8152-unchanged-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"

IUSE="+center-tap-short"

# Many of the patches are sourced from pull requests to
# https://github.com/wget/realtek-r8152-linux/ -- we do not use this repo
# as the official upstream as it does not keep a clear deliniation between
# shipped realtek code and patches. It is the source used by the AUR package.
PATCHES=(
	"${FILESDIR}"/${PN}-2.16.3-kernel-6.4.10-fix.patch
	"${FILESDIR}"/${PN}-2.16.3-asus-c5000-support.patch
)

src_compile() {
	local modlist=( ${PN}=kernel/net/usb:. )
	local modargs=(
		KERNELDIR="${KV_OUT_DIR}"
		CONFIG_CTAP_SHORT="$(usex center-tap-short on off)"
	)

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
	udev_dorules 50-usb-realtek-net.rules
}

pkg_postinst() {
	linux-mod-r1_pkg_postinst
	udev_reload
}

pkg_postrm() {
	udev_reload
}
