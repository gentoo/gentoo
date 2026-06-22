# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Borland-style programming environment and editor for console and X11"
HOMEPAGE="https://codeberg.org/mendezr/xwpe"
# Upstream "make dist" tarball attached to the Codeberg release; it ships a
# pre-generated configure, so no eautoreconf is needed.
SRC_URI="https://codeberg.org/mendezr/xwpe/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X gpm"

RDEPEND="
	dev-libs/json-c:=
	dev-libs/libvterm
	sys-libs/ncurses:=
	virtual/zlib
	X? (
		x11-libs/cairo
		x11-libs/libX11
		x11-libs/libXft
		x11-libs/pango
	)
	gpm? ( sys-libs/gpm )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	sys-apps/texinfo
"

src_configure() {
	econf \
		$(use_with X x) \
		$(use_with gpm)
}

src_test() {
	emake check
}
