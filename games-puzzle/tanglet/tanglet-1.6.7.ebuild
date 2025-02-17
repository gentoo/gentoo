# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Single player word finding game based on Boggle"
HOMEPAGE="https://gottcode.org/tanglet/"
SRC_URI="https://gottcode.org/tanglet/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtbase:6[gui,widgets]
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"
