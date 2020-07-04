# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_BASE_INDIVIDUAL_URI=""
XORG_DOC=doc
XORG_MULTILIB=yes
inherit xorg-2

DESCRIPTION="X C-language Bindings sample implementations"
HOMEPAGE="https://xcb.freedesktop.org/"
SRC_URI="https://github.com/Airblader/${PN}/releases/download/v${PV}/${P}.tar.bz2"

KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=x11-libs/libxcb-1.9.1[${MULTILIB_USEDEP}]
	x11-libs/xcb-util[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	x11-libs/libX11[${MULTILIB_USEDEP}]" # Only for tests, but configure.ac requires it

src_configure() {
	xorg-2_src_configure
}
