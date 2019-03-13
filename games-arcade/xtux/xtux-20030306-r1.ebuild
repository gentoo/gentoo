# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Multiplayer Gauntlet-style arcade game"
HOMEPAGE="http://xtux.sourceforge.net/"
SRC_URI="mirror://sourceforge/xtux/xtux-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libXpm"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-75dpi
"

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	find data/ -type d -name .xvpics -exec rm -rf \{\} +
	sed -i \
		-e "s:-g -Wall -O2:${CFLAGS}:" \
		src/{client,common,server}/Makefile \
		|| die "sed failed"
	sed -i \
		-e "s:./tux_serv:tux_serv:" \
		src/client/menu.c \
		|| die "sed failed"

	eapply "${FILESDIR}/${P}-particles.patch" \
		"${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	# Not parallel-make friendly (bug #247332)
	emake DATADIR="/usr/share/xtux/data" common
	emake DATADIR="/usr/share/xtux/data" ggz
	emake DATADIR="/usr/share/xtux/data" server
	emake DATADIR="/usr/share/xtux/data" client
}

src_install () {
	dobin xtux tux_serv
	insinto "/usr/share/xtux"
	doins -r data/
	dodoc AUTHORS CHANGELOG README README.GGZ doc/*
	newicon data/images/icon.xpm ${PN}.xpm
	make_desktop_entry xtux "Xtux"
}
