# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Ampache desktop client library"
HOMEPAGE="http://ampache-browser.org https://github.com/ampache-browser/ampache_browser"
SRC_URI="https://github.com/ampache-browser/ampache_browser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/1.0.5"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="debug nls qt6"

RDEPEND="
	qt6? ( dev-qt/qtbase:6[concurrent,gui,widgets] )
	!qt6? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
"

DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_NLS="$(usex nls)"
	)
	cmake_src_configure
}
