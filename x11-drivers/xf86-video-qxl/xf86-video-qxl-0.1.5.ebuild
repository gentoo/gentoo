# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 xorg-2

DESCRIPTION="QEMU QXL paravirt video driver"

KEYWORDS="amd64 x86"
IUSE="xspice"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	xspice? (
		app-emulation/spice
		${PYTHON_DEPS}
	)
	x11-base/xorg-server[-minimal]
	>=x11-libs/libdrm-2.4.46"
DEPEND="${RDEPEND}
	>=app-emulation/spice-protocol-0.12.0
	x11-base/xorg-proto"

src_prepare() {
	python_fix_shebang scripts
	xorg-2_src_prepare
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable xspice)
	)
	xorg-2_src_configure
}
