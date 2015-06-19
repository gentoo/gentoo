# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/0verkill/0verkill-0.16-r3.ebuild,v 1.10 2014/12/30 12:50:37 tupone Exp $

EAPI=4
inherit autotools eutils games

DESCRIPTION="a bloody 2D action deathmatch-like game in ASCII-ART"
HOMEPAGE="http://artax.karlin.mff.cuni.cz/~brain/0verkill/"
SRC_URI="http://artax.karlin.mff.cuni.cz/~brain/0verkill/release/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc sparc x86"
IUSE="X"

DEPEND="X? ( x11-libs/libXpm )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-docs.patch \
		"${FILESDIR}"/${P}-home-overflow.patch \
		"${FILESDIR}"/${P}-segv.patch \
		"${FILESDIR}"/${P}-gentoo-paths.patch \
		"${FILESDIR}"/${P}-ovflfix.patch \
		"${FILESDIR}"/${P}-CC.patch \
		"${FILESDIR}"/${P}-underflow-check.patch #136222 \
	sed -i \
		-e "s:data/:${GAMES_DATADIR}/${PN}/data/:" cfg.h \
		|| die "sed failed"
	sed -i \
		-e "s:@CFLAGS@ -O3 :@CFLAGS@ :" Makefile.in \
		|| die "sed failed"
	sed -i \
		-e "/gettimeofday/s/getopt/getopt calloc/" configure.in \
		|| die "sed failed"
	eautoreconf
}

src_configure() {
	egamesconf $(use_with X x)
}

src_install() {
	local x
	dogamesbin 0verkill
	for x in avi bot editor server test_server ; do
		newgamesbin ${x} 0verkill-${x}
	done
	if use X ; then
		dogamesbin x0verkill
		for x in avi editor ; do
			newgamesbin ${x} 0verkill-${x}
		done
	fi

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data grx

	dohtml doc/*.html
	rm doc/*.html doc/README.OS2 doc/Readme\ Win32.txt doc/COPYING
	dodoc doc/*

	prepgamesdirs
}
