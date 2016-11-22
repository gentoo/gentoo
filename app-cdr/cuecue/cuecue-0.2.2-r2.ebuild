# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit flag-o-matic

DESCRIPTION="Cuecue converts .cue + [.ogg|.flac|.wav|.mp3] to .cue + .bin"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Enable one use flag by default, bug 254745"
IUSE="flac mp3 +vorbis"
REQUIRED_USE="|| ( flac mp3 vorbis )"

DEPEND="
	flac? ( media-libs/flac )
	mp3? ( media-libs/libmad )
	vorbis? ( media-libs/libvorbis media-libs/libogg )
"

PATCHES=(
	"${FILESDIR}"/${P}-flac113.diff # bug 157706
	"${FILESDIR}"/${P}-namespace.patch
	"${FILESDIR}"/${P}-unused.patch
)

src_configure() {
	econf \
		$(use_enable flac) \
		$(use_enable mp3) \
		$(use_enable vorbis ogg) \
		--disable-libFLACtest \
		--disable-oggtest \
		--disable-vorbistest
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
}

src_install() {
	default

	insinto /usr/include
	doins src/libcuecue/cuecue.h
}
