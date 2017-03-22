# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Qt Bible study application using the SWORD library"
HOMEPAGE="http://www.bibletime.info/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

# bug 313657
RESTRICT="test"

RDEPEND="
	>=app-text/sword-1.7.0
	dev-cpp/clucene
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	dev-libs/boost
	dev-libs/icu:=
	dev-qt/linguist-tools:5
	dev-qt/qttest:5
	net-misc/curl
	sys-libs/zlib
"

DOCS=( ChangeLog README.md )

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s:Dictionary;Qt:Dictionary;Office;TextTools;Utility;Qt:" \
	    -i cmake/platforms/linux/bibletime.desktop.cmake || die "fixing .desktop file failed"
}
