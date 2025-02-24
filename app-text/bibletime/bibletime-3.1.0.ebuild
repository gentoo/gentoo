# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt Bible-study application using the SWORD library"
HOMEPAGE="https://bibletime.info"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="
	app-text/sword[curl,icu]
	dev-cpp/clucene:1
	dev-qt/qtbase:6[gui,network,widgets,xml]
	dev-qt/qtdeclarative:6[widgets]
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	doc? (
		app-text/docbook-xml-dtd
		app-text/docbook-xsl-stylesheets
		app-text/po4a
		dev-libs/libxslt
	)
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_HANDBOOK_HTML=$(usex doc)
		-DBUILD_HANDBOOK_PDF=no
		-DBUILD_HOWTO_HTML=$(usex doc)
		-DBUILD_HOWTO_PDF=no
	)

	cmake_src_configure
}
