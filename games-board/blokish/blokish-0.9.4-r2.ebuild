# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
WX_GTK_VER="3.0"
inherit eutils autotools wxwidgets games

MY_P="${PN}_v${PV}"
DESCRIPTION="Open source clone of the four-player board game Blokus"
HOMEPAGE="https://sourceforge.net/projects/blokish/"
SRC_URI="mirror://sourceforge/blokish/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	virtual/glu
	virtual/opengl"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-underlink.patch \
		"${FILESDIR}"/${P}-wxgtk.patch
	sed -i \
		-e "s:wx-config:${WX_CONFIG}:" \
		configure.in makefile.am || die
	mv configure.in configure.ac || die
	eautoreconf
}

src_install() {
	default

	doicon src/${PN}.xpm
	make_desktop_entry ${PN} Blokish ${PN}

	dohtml docs/*
	prepgamesdirs
}
