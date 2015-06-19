# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/fb2edit/fb2edit-0.0.9.ebuild,v 1.1 2014/10/19 11:50:04 pinkbyte Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="a WYSIWYG FictionBook (fb2) editor"
HOMEPAGE="http://fb2edit.lintest.ru/"
SRC_URI="https://github.com/lintest/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libxml2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4"
RDEPEND="${DEPEND}
	x11-themes/hicolor-icon-theme"

DOCS=( AUTHORS README )

PATCHES=( "${FILESDIR}/${P}-fix-compiler-warnings.patch" )

src_prepare() {
	# drop -g from CFLAGS
	sed -i -e '/^add_definitions(-W/s/-g//' CMakeLists.txt || die 'sed failed'

	cmake-utils_src_prepare
}
