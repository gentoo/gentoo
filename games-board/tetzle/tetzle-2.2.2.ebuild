# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Jigsaw puzzle game that uses tetrominoes for the pieces"
HOMEPAGE="https://gottcode.org/tetzle/"
SRC_URI="https://gottcode.org/tetzle/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-qt/qtbase:6[gui,opengl,widgets,-gles2-only]"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"
