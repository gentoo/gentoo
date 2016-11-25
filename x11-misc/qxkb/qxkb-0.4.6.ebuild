# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="Qt4-based keyboard layout switcher"
HOMEPAGE="https://github.com/disels/qxkb"
SRC_URI="https://github.com/disels/qxkb/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-qt/qtgui:4
	dev-qt/qtsvg:4
	x11-libs/libxkbfile"
RDEPEND="${DEPEND}
	x11-apps/setxkbmap"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	sed -i -e 's:../language:${CMAKE_SOURCE_DIR}/language:' \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}
