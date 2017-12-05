# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="A chess client and library for Emacs"
HOMEPAGE="http://emacs-chess.sourceforge.net/"
SRC_URI="mirror://sourceforge/emacs-chess/${P/_beta/b}.tar.gz
	mirror://gentoo/emacs-chess-sounds-${PV%%_*}.tar.bz2
	mirror://gentoo/emacs-chess-pieces-${PV%%_*}.tar.bz2"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="|| ( games-board/gnuchess
		games-board/crafty
		games-board/phalanx
		games-board/sjeng )"

S="${WORKDIR}/${PN}"
DOCS="ChangeLog EPD.txt PGN.txt PLAN README TODO"
ELISP_PATCHES="${PV}-chess-pos-move-gentoo.patch
	${PV}-chess-common-handler-gentoo.patch
	${PV}-texinfo-5.patch"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	default
}

src_install() {
	elisp_src_install
	doinfo chess.info
	insinto "${SITEETC}/${PN}"
	doins -r "${WORKDIR}"/{sounds,pieces}
}
