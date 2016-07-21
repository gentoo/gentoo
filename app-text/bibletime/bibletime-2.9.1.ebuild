# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="Qt4 Bible study application using the SWORD library"
HOMEPAGE="http://www.bibletime.info/"
SRC_URI="mirror://sourceforge/project/bibletime/BibleTime%202/BibleTime%202%20source%20code/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

# bug 313657
# RESTRICT="test"

RDEPEND="
	>=app-text/sword-1.6.0
	>=dev-cpp/clucene-2.3.3.4
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	dev-libs/icu:=
	net-misc/curl
	sys-libs/zlib
	dev-qt/qttest:4"

DOCS=( ChangeLog README )

src_prepare() {
	sed -e "s:Dictionary;Qt:Dictionary;Office;TextTools;Utility;Qt;:" \
	    -i cmake/platforms/linux/bibletime.desktop.cmake || die "fixing .desktop file failed"
}

src_configure() {
	local mycmakeargs=(
		-DUSE_QT_WEBKIT=ON
	)

	cmake-utils_src_configure
}
