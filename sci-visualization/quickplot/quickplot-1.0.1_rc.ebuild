# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

MY_P=${P/_rc/rc}

DESCRIPTION="A fast interactive 2D plotter"
HOMEPAGE="
	http://quickplot.sourceforge.net/
	https://github.com/lanceman2/quickplot"
SRC_URI="https://github.com/lanceman2/${PN}/archive/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	media-libs/libsndfile:=
	>=sys-libs/readline-0.6.2:0=
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="
	media-gfx/imagemagick[png]
	virtual/pkgconfig
	www-client/lynx"

PATCHES=( "${FILESDIR}"/${P}-automake.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--enable-developer
}

src_install() {
	default

	make_desktop_entry 'quickplot --no-pipe' Quickplot quickplot Graphics
	mv "${ED}"/usr/share/applications/quickplot{*,}.desktop || die

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
