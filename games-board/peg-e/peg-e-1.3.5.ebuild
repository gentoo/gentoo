# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Peg solitaire game"
HOMEPAGE="https://gottcode.org/peg-e/"
SRC_URI="https://gottcode.org/peg-e/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtbase:6[gui,widgets]"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"
