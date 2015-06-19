# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/chaplin/chaplin-1.10-r1.ebuild,v 1.7 2011/11/21 21:06:11 radhermit Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="This is a program to raw copy chapters from a dvd using libdvdread"
HOMEPAGE="http://www.lallafa.de/bp/chaplin.html"
SRC_URI="http://www.lallafa.de/bp/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="transcode vcd"

DEPEND=">=media-libs/libdvdread-0.9.4"
RDEPEND="${DEPEND}
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	media-video/mjpegtools
	transcode? ( >=media-video/transcode-0.6.2 )
	vcd? ( >=media-video/vcdimager-0.7.2 )"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-libdvdread-0.9.6.patch \
		"${FILESDIR}"/${P}-asneeded.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin chaplin chaplin-genmenu
}
