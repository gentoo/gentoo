# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs scons-utils

DESCRIPTION="A simple converter to create Ogg Theora files"
HOMEPAGE="http://www.v2v.cc/~j/ffmpeg2theora/"
SRC_URI="http://www.v2v.cc/~j/${PN}/downloads/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="kate"

RDEPEND="
	|| ( media-video/ffmpeg:0 media-libs/libpostproc <media-video/libav-0.8.2-r1 )
	>=virtual/ffmpeg-0.10
	>=media-libs/libvorbis-1.1
	>=media-libs/libogg-1.1
	>=media-libs/libtheora-1.1[encode]
	kate? ( >=media-libs/libkate-0.3.7 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-swr.patch \
		"${FILESDIR}"/${P}-ffmpeg2.patch \
		"${FILESDIR}"/${P}-underlinking.patch
}

src_configure() {
	myesconsargs=(
		APPEND_CCFLAGS="${CFLAGS}"
		APPEND_LINKFLAGS="${LDFLAGS}"
		prefix=/usr
		mandir=PREFIX/share/man
		libkate=$(usex kate 1 0)
		)
}

src_compile() {
	escons
}

src_install() {
	escons destdir="${D}" install
	dodoc AUTHORS ChangeLog README subtitles.txt TODO
}
