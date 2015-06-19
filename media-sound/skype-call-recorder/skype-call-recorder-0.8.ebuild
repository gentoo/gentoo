# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/skype-call-recorder/skype-call-recorder-0.8.ebuild,v 1.7 2013/11/26 09:13:45 slyfox Exp $

EAPI="4"

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
	"${FILESDIR}/${P}-cmake.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	append-ldflags $(no-as-needed) -lvorbis -logg # bug 482744
}
