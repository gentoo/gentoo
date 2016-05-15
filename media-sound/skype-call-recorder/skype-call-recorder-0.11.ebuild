# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit cmake-utils flag-o-matic

DESCRIPTION="Records Skype calls to MP3/Ogg/WAV files"
HOMEPAGE="http://atdot.ch/scr/"
SRC_URI="http://atdot.ch/scr/files/${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug"

DEPEND="
	media-libs/id3lib
	>=media-libs/libogg-1.2.0
	>=media-libs/libvorbis-1.2.0
	media-sound/lame
	>=dev-qt/qtcore-4.4:4
	>=dev-qt/qtdbus-4.4:4
	>=dev-qt/qtgui-4.4:4
"
RDEPEND="${DEPEND}
	net-im/skype[-qt-static(-)]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.8-cmake.patch"
)
