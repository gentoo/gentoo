# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
OPENGL_REQUIRED="optional"
inherit kde4-base

DESCRIPTION="Sudoku by KDE"
HOMEPAGE="
	https://www.kde.org/applications/games/ksudoku/
	https://games.kde.org/game.php?game=ksudoku
"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep libkdegames)
	opengl? ( virtual/glu )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DWITH_OpenGL=$(usex opengl)
	)
	kde4-base_src_configure
}
