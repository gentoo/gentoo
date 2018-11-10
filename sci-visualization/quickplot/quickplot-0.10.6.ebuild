# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils eutils

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
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed '/libquickplot_la_LIBADD/s:$: -lm:g' -i Makefile.am || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
	)
	autotools-utils_src_configure
}

src_install () {
	autotools-utils_src_install
	make_desktop_entry 'quickplot --no-pipe' Quickplot quickplot Graphics
	mv "${ED}"/usr/share/applications/quickplot*.desktop \
		"${ED}"/usr/share/applications/quickplot.desktop || die
}
