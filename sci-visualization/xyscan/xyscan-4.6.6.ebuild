# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_rs 2 '')
inherit desktop qmake-utils

DESCRIPTION="Tool for extracting data points from graphs"
HOMEPAGE="https://rhig.physics.yale.edu/~ullrich/software/xyscan"
SRC_URI="https://rhig.physics.yale.edu/~ullrich/software/${PN}/Distributions/${MY_PV}/${PN}-${MY_PV}-src.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-text/poppler[qt6]
	dev-qt/qtcharts:6
	dev-qt/qtbase:6[gui,network,ssl,widgets]
	dev-qt/qtmultimedia:6
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-qt6.patch" )

src_prepare() {
	default
	sed -e "/path = /s:\"/usr/share/doc/xyscan/docs\":\"${EPREFIX}/usr/share/doc/${PF}/html\":" \
		-i src/xyscanBaseWindow.cpp || die "Failed to fix docs path"
}

src_configure() {
	eqmake6
}

src_install() {
	dobin xyscan
	local HTML_DOCS=( docs/. )
	einstalldocs
	newicon images/xyscanIcon.png xyscan.png
	make_desktop_entry xyscan "xyscan data point extractor"
}
