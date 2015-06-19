# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/clipgrab/clipgrab-3.4.11.ebuild,v 1.1 2015/05/23 09:42:27 xmw Exp $

EAPI=5

inherit qt4-r2 eutils

DESCRIPTION="Download from various internet video services like Youtube etc."
HOMEPAGE="http://clipgrab.de/en"
SRC_URI="http://${PN}.de/download/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtwebkit:4"
RDEPEND="${DEPEND}
	|| ( media-video/libav media-video/ffmpeg )"

PATCHES=(
	"${FILESDIR}/${PN}-3.4.2-obey.patch"
)

src_install() {
	dobin ${PN}

	newicon icon.png ${PN}.png
	make_desktop_entry clipgrab Clipgrab "" "Qt;Video;AudioVideo;"
}
