# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Window manager hints extensions for libggi"
HOMEPAGE="https://ibiblio.org/ggicore/packages/libggiwmh.html"
SRC_URI="mirror://sourceforge/ggi/${P}.src.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="X"

RDEPEND=">=media-libs/libggi-2.2.2
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm
	)"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README doc/libggiwmh{,-functions,-libraries}.txt )

src_configure() {
	econf \
		$(use_enable X x) \
		$(use_with X x) \
		--disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
