# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="A fast interactive 2D plotter"
HOMEPAGE="http://quickplot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	media-libs/libsndfile
	>=sys-libs/readline-0.6.2:0=
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed '/libquickplot_la_LIBADD/s:$: -lm:g' -i Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	make_desktop_entry 'quickplot --no-pipe' Quickplot quickplot Graphics
	mv "${ED}"/usr/share/applications/quickplot*.desktop \
		"${ED}"/usr/share/applications/quickplot.desktop || die
}
