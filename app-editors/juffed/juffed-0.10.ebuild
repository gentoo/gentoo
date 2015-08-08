# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="QScintilla-based tabbed text editor with syntax highlighting"
HOMEPAGE="http://juffed.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}-1054.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="debug"

RDEPEND="
	app-i18n/enca
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsingleapplication[qt4(+),X]
	x11-libs/qscintilla:=
"
DEPEND="${RDEPEND}"

DOCS=( ChangeLog README )

PATCHES=(
	# bug 540554
	"${FILESDIR}/0.10-link-libjuff-against-libenca.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	sed -i -e '/set(CMAKE_CXX_FLAGS/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_QTSINGLEAPPLICATION=ON
	)
	cmake-utils_src_configure
}
