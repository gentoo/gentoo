# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Qt application for getting screenshots"
HOMEPAGE="http://screengrab.doomer.org"
SRC_URI="https://github.com/DOOMer/screengrab/archive/1.2.1.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	x11-libs/libqxt
	x11-libs/libX11
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "/LICENSE.txt/d" CMakeLists.txt || die
	rm -r src/3rdparty || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSG_DOCDIR=${PF}
		-DSG_USE_SYSTEM_QXT=ON
	)

	cmake-utils_src_configure
}
