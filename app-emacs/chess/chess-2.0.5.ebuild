# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=24

inherit elisp

DESCRIPTION="A chess client and library for Emacs"
HOMEPAGE="https://elpa.gnu.org/packages/chess.html
	https://www.emacswiki.org/emacs/ChessMode"
# Taken from https://elpa.gnu.org/packages/${P}.tar
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz
	https://dev.gentoo.org/~ulm/distfiles/emacs-chess-sounds-${PV%.*}.tar.bz2
	https://dev.gentoo.org/~ulm/distfiles/emacs-chess-pieces-${PV%.*}.tar.bz2"

LICENSE="GPL-3+ FDL-1.3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Free alternatives first, otherwise follow the ordering in the upstream
# chess-default-engine (in chess.el). Rearrange chess-default-engine in
# the site-init file accordingly.
RDEPEND="|| ( games-board/stockfish
		games-board/fruit
		games-board/gnuchess
		games-board/phalanx
		games-board/sjeng
		games-board/crafty )"

ELISP_REMOVE="chess-pkg.el"
SITEFILE="50${PN}-gentoo-2.0.4.el"
DOCS="AUTHORS NEWS TODO"

src_install() {
	elisp_src_install
	doinfo chess.info
	insinto "${SITEETC}/${PN}"
	doins chess-eco.fen chess-polyglot.bin
	doins -r "${WORKDIR}"/{sounds,pieces}
}
