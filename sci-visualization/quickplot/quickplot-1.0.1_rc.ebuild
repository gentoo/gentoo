# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

MY_P=${P/_rc/rc}

DESCRIPTION="A fast interactive 2D plotter"
HOMEPAGE="http://quickplot.sourceforge.net/ https://github.com/lanceman2/quickplot"
SRC_URI="https://github.com/lanceman2/${PN}/archive/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	media-libs/libsndfile
	>=sys-libs/readline-0.6.2:0=
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	media-gfx/imagemagick
	virtual/pkgconfig
	www-client/lynx"

S="${WORKDIR}/${PN}-${MY_P}"

src_prepare() {
	sed -i \
		-e '/libquickplot_la_LIBADD/s:$: -lm:g' \
		-e 's/ $(htmldir)/ $(DESTDIR)$(htmldir)/g' \
		Makefile.am || die
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-developer \
		$(use_enable static-libs static)
}

src_install () {
	default
	make_desktop_entry 'quickplot --no-pipe' Quickplot quickplot Graphics
	mv "${ED%/}"/usr/share/applications/quickplot{*,}.desktop || die
}
