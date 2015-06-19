# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cuecue/cuecue-0.2.2-r1.ebuild,v 1.7 2014/08/10 02:14:18 patrick Exp $

EAPI=4

inherit base eutils flag-o-matic

DESCRIPTION="Cuecue is a suite to convert .cue + [.ogg|.flac|.wav|.mp3] to .cue + .bin"
HOMEPAGE="http://cuecue.berlios.de/"
SRC_URI="mirror://berlios/cuecue/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Enable one use flag by default, bug 254745"
IUSE="flac mp3 +vorbis"
REQUIRED_USE="|| ( flac mp3 vorbis )"

DEPEND="mp3? ( media-libs/libmad )
	flac? ( media-libs/flac )
	vorbis? ( media-libs/libvorbis media-libs/libogg )"

PATCHES=( "${FILESDIR}/${P}-flac113.diff" ) # bug 157706
DOCS="CHANGES README TODO"

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable mp3) \
		$(use_enable vorbis ogg) \
		--disable-oggtest \
		--disable-vorbistest \
		$(use_enable flac) \
		--disable-libFLACtest
}

src_compile() {
	# fixes portage QA notice
	append-flags "-ansi -pedantic"
	emake CFLAGS="${CFLAGS}"
}

src_install () {
	default
	insinto /usr/include
	doins src/libcuecue/cuecue.h || die "doins failed."
}
