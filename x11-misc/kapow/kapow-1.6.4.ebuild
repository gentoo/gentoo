# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Punch clock program designed to easily keep track of your hours"
HOMEPAGE="https://gottcode.org/kapow/"
SRC_URI="https://gottcode.org/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-qt/qtbase:6[gui,network,widgets]"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( ChangeLog README )

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTS=$(usex test)
	)

	cmake_src_configure
}
