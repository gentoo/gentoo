# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-mud/tkmoo/tkmoo-0.3.32.ebuild,v 1.16 2015/03/25 15:33:42 jlec Exp $

EAPI=5

inherit eutils games

MY_PN=${PN/moo/MOO-light}
MY_P=${P/moo/MOO-light}
DESCRIPTION="MOO Client written in Tcl/Tk"
HOMEPAGE="http://www.awns.com/tkMOO-light/"
SRC_URI="http://www.awns.com/tkMOO-light/Source/${MY_P}.tar.gz"

LICENSE="tkMOO"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="
	>=dev-lang/tcl-8.3.3:0=
	>=dev-lang/tk-8.3.3:0="

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}/${PV}-Makefile-noclean.patch" \
		"${FILESDIR}/${PV}-keys-workaround.patch"
}

src_compile() {
	emake \
		WISH="$(type -P wish)" \
		TKMOO_LIB_DIR="$(games_get_libdir)/${MY_PN}" \
		TKMOO_BIN_DIR="${GAMES_BINDIR}"
}

src_install() {
	emake \
		TKMOO_LIB_DIR="${D}/$(games_get_libdir)/${MY_PN}" \
		TKMOO_BIN_DIR="${D}/${GAMES_BINDIR}" \
		install
	dodoc README dot.tkmoolightrc bugsmail.txt
	dosym tkMOO-lite "${GAMES_BINDIR}/tkmoo"
	make_desktop_entry tkmoo "tkMOO"
	prepgamesdirs
}
