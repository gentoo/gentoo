# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit autotools python-single-r1 xorg-3

DESCRIPTION="QEMU QXL paravirt video driver"
SRC_URI="https://dev.gentoo.org/~slashbeast/distfiles/${PN}/${P}.tar.xz"
S="${WORKDIR}"

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

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.5_p20200205-xorg-21.0-build.patch
	"${FILESDIR}"/${PN}-0.1.5_p20200205-xorg-21.0-build-bool.patch
)

pkg_setup() {
	use xspice && python-single-r1_pkg_setup
	xorg-3_pkg_setup
}

src_prepare() {
	xorg-3_src_prepare
	eautoreconf

	use xspice && python_fix_shebang scripts
}

src_configure() {
	local XORG_CONFIGURE_OPTIONS=(
		$(use_enable xspice)
	)
	xorg-3_src_configure
}
