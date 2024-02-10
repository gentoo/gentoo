# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RESTRICT="!test? ( test )"

inherit cmake

DESCRIPTION="Cross-platform tools for working with chess engines"
HOMEPAGE="https://cutechess.com/ https://github.com/cutechess/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test qt5 +qt6"

RDEPEND="qt5? (
		dev-qt/qtwidgets:5
		dev-qt/qtsvg:5
		dev-qt/qtprintsupport:5
		dev-qt/qtconcurrent:5
		)
	qt6? ( dev-qt/qtbase:6
		dev-qt/qtsvg:6
		dev-qt/qt5compat:6
		)
	"
DEPEND="${RDEPEND}
	qt5? ( test? ( dev-qt/qttest:5 ) )
	"

src_configure() {
	use test || mycmakeargs=( "-DWITH_TESTS=OFF" )
	cmake_src_configure
}
