# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Touchscreen calibration utility"
HOMEPAGE="http://touchcal.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"

DEPEND="
	sys-libs/ncurses:0=
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	local PKGCONFIG="$(tc-getPKG_CONFIG)"
	emake LDADD="$(${PKGCONFIG} --libs ncurses)"
}
