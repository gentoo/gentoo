# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
inherit eutils games

DESCRIPTION="Tcl/Tk variant of the well-known 15-puzzle game"
HOMEPAGE="http://www.naskita.com/linux/penguzzle/penguzzle.shtml"
SRC_URI="http://www.naskita.com/linux/${PN}/${PN}.zip"

LICENSE="penguzzle"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/tk
	dev-tcltk/tclx"
DEPEND="app-arch/unzip"

S=${WORKDIR}/${PN}${PV}

src_prepare() {
	sed -i \
		-e "s:~/puzz/images:${GAMES_DATADIR}/${PN}:" \
		lib/init \
		|| die "sed init failed"
	sed -i \
		-e "s:~/puzz/lib:$(games_get_libdir)/${PN}:" \
		bin/${PN} \
		|| die "sed ${PN} failed"

	epatch "${FILESDIR}"/${P}-tclx.patch
}

src_install() {
	insinto "${GAMES_DATADIR}"/${PN}
	doins images/img0.gif

	insinto "$(games_get_libdir)"/${PN}
	doins lib/init

	dogamesbin bin/${PN}

	dodoc README
	prepgamesdirs
}
