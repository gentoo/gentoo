# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="a WYSIWYG FictionBook (fb2) editor"
HOMEPAGE="http://fb2edit.lintest.ru/"
SRC_URI="http://fb2edit.lintest.ru/pub/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/libxml2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	dev-qt/qtxmlpatterns:4"
RDEPEND="${DEPEND}
	x11-themes/hicolor-icon-theme"

DOCS=( AUTHORS README )

src_prepare() {
	# drop -g from CFLAGS
	sed -i -e '/^add_definitions(-W/s/-g//' CMakeLists.txt || die 'sed failed'

	cmake-utils_src_prepare
}
