# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils games

DESCRIPTION="Rise of the Triad for Linux!"
HOMEPAGE="http://www.icculus.org/rott/"
SRC_URI="http://www.icculus.org/rott/releases/${P}.tar.gz
	demo? ( http://filesingularity.timedoctor.org/swdata.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE="demo"

RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${P}/rott

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch \
		"${FILESDIR}"/${PV}-custom-datapath.patch \
		"${FILESDIR}"/${P}-gcc41.patch
	use demo || epatch "${FILESDIR}"/${P}-full-version.patch
}

src_compile() {
	emake clean || die
	emake -j1 EXTRACFLAGS="${CFLAGS} -DDATADIR=\\\"${GAMES_DATADIR}/${PN}/\\\"" \
		|| die "emake failed"
}

src_install() {
	dogamesbin rott || die "dogamesbin failed"
	dodoc *.txt ../{README,readme.txt}
	if use demo ; then
		cd "${WORKDIR}"
		insinto "${GAMES_DATADIR}"/${PN}
		doins *.dmo huntbgin.* remote1.rts || die "doins failed"
	fi
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! use demo ; then
		elog "To play the full version, just copy the"
		elog "data files to ${GAMES_DATADIR}/${PN}/"
	fi
}
