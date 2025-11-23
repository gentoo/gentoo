# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Ampache desktop client library"
HOMEPAGE="https://ampache-browser.org https://github.com/ampache-browser/ampache_browser"
SRC_URI="https://github.com/ampache-browser/ampache_browser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="debug nls"

RDEPEND="dev-qt/qtbase:6[concurrent,gui,widgets]"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT6=ON
		-DUSE_NLS="$(usex nls)"
	)
	cmake_src_configure
}
