# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
XORG_TARBALL_SUFFIX="xz"
inherit python-single-r1 xorg-3

DESCRIPTION="QEMU QXL paravirt video driver"

KEYWORDS="amd64 x86"
IUSE="xspice"
REQUIRED_USE="xspice? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	xspice? (
		app-emulation/spice
		${PYTHON_DEPS}
	)
	x11-base/xorg-server[-minimal]
	>=x11-libs/libdrm-2.4.46"
DEPEND="
	${RDEPEND}
	>=app-emulation/spice-protocol-0.12.0
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	use xspice && python-single-r1_pkg_setup
	xorg-3_pkg_setup
}

src_prepare() {
	xorg-3_src_prepare

	use xspice && python_fix_shebang scripts
}

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable xspice)
	)
	xorg-3_src_configure
}
