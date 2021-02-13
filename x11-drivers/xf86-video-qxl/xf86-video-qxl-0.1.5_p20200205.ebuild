# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-single-r1 xorg-3 autotools

SRC_URI="https://dev.gentoo.org/~slashbeast/distfiles/${PN}/${P}.tar.xz"
DESCRIPTION="QEMU QXL paravirt video driver"
KEYWORDS="~amd64 ~x86"

IUSE="xspice"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}/"

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

	eautoreconf

	xorg-3_src_prepare
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable xspice)
	)
	xorg-3_src_configure
}
