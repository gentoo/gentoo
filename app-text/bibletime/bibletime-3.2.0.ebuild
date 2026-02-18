# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Qt Bible-study application using the SWORD library"
HOMEPAGE="https://bibletime.info"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc speech"

RDEPEND="
	app-text/sword[curl,icu]
	dev-cpp/clucene:1
	dev-qt/qtbase:6[gui,icu,network,widgets,xml]
	dev-qt/qtdeclarative:6[widgets]
	dev-qt/qtsvg:6
	speech? ( dev-qt/qtspeech:6 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd
		app-text/docbook-xsl-stylesheets
		app-text/po4a
		dev-libs/libxslt
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.2.0-disable_autolto.patch

	# from master
	"${FILESDIR}"/${P}-fix_cxx20.patch
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DBUILD_HANDBOOK_HTML=$(usex doc)
		-DBUILD_HANDBOOK_PDF=no
		-DBUILD_HOWTO_HTML=$(usex doc)
		-DBUILD_HOWTO_PDF=no
		-DBUILD_TEXT_TO_SPEECH=$(usex speech)
	)

	cmake_src_configure
}
