# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2 eutils

DESCRIPTION="backlite is a pure QT4 version of k9copy"
HOMEPAGE="http://k9copy.sourceforge.net/"
SRC_URI="mirror://sourceforge/k9copy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mplayer"

# According to the author of backlite/k9copy libdvdread and libdvdnav are
# bundled internal because newer versions produce bad DVD copies.
# This will be fixed later.
# DEPEND="media-libs/libdvdread"

DEPEND=">=media-libs/libmpeg2-0.5.1
	media-video/ffmpeg
	dev-qt/qtgui:4
	dev-qt/qtdbus:4
	|| ( dev-qt/qtphonon:4 media-libs/phonon[qt4] )"

RDEPEND="${DEPEND}
	media-video/dvdauthor
	mplayer? ( media-video/mplayer )"

src_prepare() {
	sed -i -e '/^MimeTypes=.*/d' \
		-e '/^Encoding=.*/d' *.desktop || die
	epatch "${FILESDIR}/${P}-ffmpeg-0.11.patch" \
		"${FILESDIR}/${P}-includepaths.patch" \
		"${FILESDIR}/${P}-ffmpeg2.patch"
}

src_configure() {
	eqmake4 backlite.pro PREFIX="${D}"/usr
}

src_install() {
	unset INSTALL_ROOT
	default
}
