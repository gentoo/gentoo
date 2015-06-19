# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/streamtranscoder/streamtranscoder-1.2.4.ebuild,v 1.6 2012/07/14 12:16:22 hasufell Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="Command line application to transcode shoutcast/icecast streams to different bitrates"
HOMEPAGE="http://www.oddsock.org"
SRC_URI="http://www.oddsock.org/tools/streamTranscoder/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND=">=media-libs/libogg-1.1
	>=media-libs/libvorbis-1.0.1-r2
	>=media-sound/lame-3.96
	>=media-libs/libmad-0.15.1b
	>=net-misc/curl-7.11.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_install() {
	default
	dodoc AUTHORS README
}
