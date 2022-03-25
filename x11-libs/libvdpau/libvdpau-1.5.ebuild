# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib virtualx

DESCRIPTION="VDPAU wrapper and trace libraries"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/VDPAU"
SRC_URI="https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~riscv x86"
IUSE="doc dri"

RDEPEND="
	x11-libs/libX11[${MULTILIB_USEDEP}]
	dri? ( x11-libs/libXext[${MULTILIB_USEDEP}] )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
		virtual/latex-base
	)"

src_prepare() {
	default

	sed -i "/^docdir/s|${PN}|${PF}|" doc/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_bool doc documentation)
		$(meson_use dri dri2)
	)

	meson_src_configure
}

multilib_src_test() {
	virtx meson_src_test
}
