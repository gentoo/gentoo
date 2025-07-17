# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Window manager hints extensions for libggi"
HOMEPAGE="https://ibiblio.org/ggicore/packages/libggiwmh.html"
SRC_URI="https://downloads.sourceforge.net/ggi/${P}.src.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 ~riscv sparc x86"
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

src_prepare() {
	default

	# https://bugs.gentoo.org/899822
	rm acinclude.m4 || die #it's not regenerated and breaks libggi check
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable X x) \
		$(use_with X x)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
