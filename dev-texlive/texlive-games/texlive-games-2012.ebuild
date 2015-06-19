# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-games/texlive-games-2012.ebuild,v 1.13 2013/04/25 21:27:25 ago Exp $

EAPI="4"

TEXLIVE_MODULE_CONTENTS="bartel-chess-fonts chess chess-problem-diagrams chessboard chessfss crossword crosswrd egameps gamebook go hanoi hexgame othello othelloboard psgo reverxii schwalbe-chess sgame skak skaknew sudoku sudokubundle xq xskak collection-games
"
TEXLIVE_MODULE_DOC_CONTENTS="bartel-chess-fonts.doc chess.doc chess-problem-diagrams.doc chessboard.doc chessfss.doc crossword.doc crosswrd.doc egameps.doc gamebook.doc hexgame.doc othello.doc othelloboard.doc psgo.doc reverxii.doc schwalbe-chess.doc sgame.doc skak.doc skaknew.doc sudoku.doc sudokubundle.doc xq.doc xskak.doc "
TEXLIVE_MODULE_SRC_CONTENTS="chess-problem-diagrams.source chessboard.source chessfss.source crossword.source crosswrd.source gamebook.source go.source schwalbe-chess.source sudoku.source sudokubundle.source xskak.source "
inherit  texlive-module
DESCRIPTION="TeXLive Games typesetting"

LICENSE="GPL-2 GPL-1 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2012
!<dev-texlive/texlive-latexextra-2009
"
RDEPEND="${DEPEND} "
