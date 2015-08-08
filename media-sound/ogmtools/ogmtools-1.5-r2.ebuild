# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="Information, extraction or creation for OGG media streams"
HOMEPAGE="http://www.bunkus.org/videotools/ogmtools/"
SRC_URI="http://www.bunkus.org/videotools/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="dvd"

RDEPEND="dvd? ( media-libs/libdvdread )
	media-sound/vorbis-tools"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-comments.patch \
		"${FILESDIR}"/${P}-endian-fix.patch \
		"${FILESDIR}"/${P}-vorbis_verbosity.patch \
		"${FILESDIR}"/${P}-summary_length.patch
}

src_configure() {
	econf \
		$(use_with dvd dvdread)
}

src_install() {
	dobin ogmmerge ogmdemux ogminfo ogmsplit ogmcat || die "dobin failed"

	if use dvd; then
		dobin dvdxchap || die "dobin failed"
	fi

	dodoc ChangeLog README TODO
	doman *.1
}
