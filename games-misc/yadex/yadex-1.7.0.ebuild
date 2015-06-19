# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/yadex/yadex-1.7.0.ebuild,v 1.12 2015/02/06 22:15:03 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A Doom level (wad) editor"
HOMEPAGE="http://www.teaser.fr/~amajorel/yadex/"
SRC_URI="http://www.teaser.fr/~amajorel/yadex/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""
RESTRICT="test"

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/iwad/s/local\///' \
		"${S}"/yadex.cfg \
		|| die "sed yadex.cfg failed"
	epatch "${FILESDIR}/${P}"-NULL-is-not-zero.patch \
		"${FILESDIR}/${P}"-elif.patch
	# Force the patched file to be old, otherwise the compile fails
	touch -t 197010101010 "${S}"/src/wadlist.cc
	touch -t 197010101010 "${S}"/src/gfx.cc
}

src_configure() {
	# not an autoconf script
	./configure --prefix="/usr" || die "configure failed"
}

src_compile() {
	emake CC="${CC}" CXX="${CXX}" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	dogamesbin obj/0/yadex
	insinto "${GAMES_DATADIR}/${PN}/${PV}"
	doins ygd/*
	doman doc/yadex.6
	dodoc CHANGES FAQ README TODO VERSION
	dohtml doc/*
	insinto /etc/yadex/${PV}
	doins yadex.cfg
	prepgamesdirs
}
