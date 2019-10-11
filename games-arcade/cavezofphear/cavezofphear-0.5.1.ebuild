# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils games

DESCRIPTION="A boulder dash / digger-like game for console using ncurses"
HOMEPAGE="http://www.x86.no/cavezofphear/"
SRC_URI="mirror://gentoo/phear-${PV}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P/cavezof/}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i \
		-e "s:get_data_dir(.):\"${GAMES_DATADIR}/${PN}/\":" \
		src/{chk.c,main.c,gplot.c} \
		|| die
}

src_install() {
	dogamesbin src/phear
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*
	dodoc ChangeLog README* TODO
	prepgamesdirs
}
