# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Tool for extracting data points from graphs"
HOMEPAGE="https://rhig.physics.yale.edu/~ullrich/software/xyscan"
SRC_URI="https://rhig.physics.yale.edu/~ullrich/software/${PN}/Distributions/${PV}/${P}-src.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-qt/qtcharts:6
	dev-qt/qtbase:6[gui,network,ssl,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtwebengine:6[pdfium]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

src_prepare() {
	sed -e "/path = /s:\"/usr/share/doc/xyscan/docs\":\"${EPREFIX}/usr/share/doc/${PF}/html\":" \
		-i src/xyscanBaseWindow.cpp || die "Failed to fix docs path"
	cmake_src_prepare
}

src_install() {
	cmake_src_install
	mv "${ED}"/usr/share/docs/xyscan \
		"${ED}"/usr/share/doc/${PF}/html || die
}
