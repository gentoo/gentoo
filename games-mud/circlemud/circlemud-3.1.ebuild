# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="a multi-user dungeon game system server"
HOMEPAGE="http://www.circlemud.org/"
SRC_URI="http://www.circlemud.org/pub/CircleMUD/3.x/circle-${PV}.tar.bz2"

LICENSE="circlemud"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-libs/openssl:0="
RDEPEND=${DEPEND}

S=${WORKDIR}/circle-${PV}

src_prepare() {
	cd src
	touch .accepted
	sed -i \
		-e 's:^read.*::' licheck || die

	# make circlemud fit into Gentoo nicely
	sed -i \
		-e "s:\"lib\":\"${GAMES_DATADIR}/${PN}\":g" \
		-e "s:\(LOGNAME = \)NULL:\1\"${GAMES_LOGDIR}/${PN}.log\":g" \
		config.c || die
	sed -i \
		-e "s:etc/:${GAMES_SYSCONFDIR}/${PN}/:g" db.h || die

	# now lets rename binaries (too many are very generic)
	sed -i \
		-e "s:\.\./bin/autowiz:${PN}-autowiz:" limits.c || die
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake -C src
}

src_install() {
	local bin

	for bin in autowiz delobjs listrent mudpasswd play2to3 purgeplay \
	           shopconv showplay sign split wld2html ; do
		newgamesbin bin/${bin} ${PN}-${bin}
	done
	dogamesbin bin/circle

	dodir "${GAMES_DATADIR}/${PN}"
	cp -r lib/*  "${D}/${GAMES_DATADIR}/${PN}" || die

	insinto "${GAMES_SYSCONFDIR}/${PN}"
	doins lib/etc/*

	dodoc doc/{README.UNIX,*.pdf,*.txt} ChangeLog FAQ README release_notes.${PV}.txt
	prepgamesdirs
	fperms 770 "${GAMES_SYSCONFDIR}/${PN}/players"
}
