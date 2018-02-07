# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

TEXLIVE_MODULE_CONTENTS="bartel-chess-fonts chess chess-problem-diagrams chessboard chessfss crossword crosswrd egameps gamebook go hanoi havannah hexgame horoscop labyrinth logicpuzzle othello othelloboard pas-crosswords psgo reverxii rubik schwalbe-chess sgame skak skaknew soup sudoku sudokubundle xq xskak collection-games
"
TEXLIVE_MODULE_DOC_CONTENTS="bartel-chess-fonts.doc chess.doc chess-problem-diagrams.doc chessboard.doc chessfss.doc crossword.doc crosswrd.doc egameps.doc gamebook.doc go.doc havannah.doc hexgame.doc horoscop.doc labyrinth.doc logicpuzzle.doc othello.doc othelloboard.doc pas-crosswords.doc psgo.doc reverxii.doc rubik.doc schwalbe-chess.doc sgame.doc skak.doc skaknew.doc soup.doc sudoku.doc sudokubundle.doc xq.doc xskak.doc "
TEXLIVE_MODULE_SRC_CONTENTS="chess-problem-diagrams.source chessboard.source chessfss.source crossword.source crosswrd.source gamebook.source go.source havannah.source horoscop.source rubik.source schwalbe-chess.source soup.source sudoku.source sudokubundle.source xskak.source "
inherit  texlive-module
DESCRIPTION="TeXLive Games typesetting"

LICENSE=" GPL-1 GPL-2 LPPL-1.2 LPPL-1.3 public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-latex-2017
!<dev-texlive/texlive-latexextra-2009
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="
	texmf-dist/scripts/rubik/rubikrotation.pl
"
