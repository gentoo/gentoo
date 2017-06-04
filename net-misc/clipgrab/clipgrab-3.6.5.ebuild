# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit qt4-r2 eutils

DESCRIPTION="Download from various internet video services like Youtube etc."
HOMEPAGE="http://clipgrab.de/en"
SRC_URI="https://download.${PN}.de/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}
	|| ( media-video/libav media-video/ffmpeg )"

src_install() {
	dobin ${PN}

	make_desktop_entry clipgrab Clipgrab "" "Qt;Video;AudioVideo;"
}
