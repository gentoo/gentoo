# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="The glue between Coin3D and Qt"
HOMEPAGE="https://bitbucket.org/Coin3D/soqt"
SRC_URI="https://bitbucket.org/Coin3D/coin/downloads/${P}.tar.gz"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE="debug doc static-libs"

RDEPEND="
	>=media-libs/coin-3.1.3
	virtual/opengl
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.0-pkgconfig-partial.patch"
)

DOCS=(AUTHORS ChangeLog FAQ HACKING NEWS README)

src_configure() {
	local myeconfargs=(
		htmldir="/usr/share/doc/${PF}/html"
		--disable-compact
		--disable-html-help
		--disable-loadlibrary
		--disable-man
		--enable-pkgconfig
		--includedir="/usr/include/coin"
		--with-coin
		$(use_enable debug)
		$(use_enable debug symbols)
		$(use_enable doc html)
	)
	autotools-utils_src_configure
}

src_install() {
	# Remove SoQt from Libs.private
	sed -e '/Libs.private/s/ -lSoQt//' -i "${BUILD_DIR}"/SoQt.pc || die

	autotools-utils_src_install
}
