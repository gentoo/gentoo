# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cross-platform tools for working with chess engines"
HOMEPAGE="https://cutechess.com/ https://github.com/cutechess/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,gui,widgets]
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-bool.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_TESTS=$(usex test)
	)
	cmake_src_configure
}
