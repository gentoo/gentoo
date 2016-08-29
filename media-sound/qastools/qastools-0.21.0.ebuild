# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils

MY_P=${PN}_${PV}

DESCRIPTION="Qt5 GUI ALSA tools: mixer, configuration browser"
HOMEPAGE="http://xwmw.org/qastools/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	virtual/libudev:=
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

S=${WORKDIR}/${MY_P}

src_configure() {
	local mycmakeargs=( -DSKIP_LICENSE_INSTALL=TRUE )
	cmake-utils_src_configure
}
