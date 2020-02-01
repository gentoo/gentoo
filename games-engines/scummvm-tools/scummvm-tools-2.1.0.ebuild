# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER=3.0
inherit wxwidgets eutils flag-o-matic

DESCRIPTION="Utilities for modifying data files of ScummVM compatible games"
HOMEPAGE="https://www.scummvm.org"
SRC_URI="https://scummvm.org/frs/scummvm-tools/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="flac iconv mad png vorbis"
RESTRICT="test" # some tests require external files

RDEPEND=">=dev-libs/boost-1.32:=
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}
	flac? ( media-libs/flac )
	iconv? ( virtual/libiconv media-libs/freetype:2 )
	mad? ( media-libs/libmad )
	png? ( media-libs/libpng:0 )
	vorbis? ( media-libs/libvorbis )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

src_prepare() {
	default

	need-wxwidgets unicode
	rm -rf *.bat dists/win32 || die
	sed -ri -e '/^(CC|CXX)\b/d' Makefile || die
}

src_configure() {
	# Not an autoconf script
	./configure \
		--prefix=/usr \
		--disable-tremor \
		--enable-verbose-build \
		--mandir=/usr/share/man \
		$(use_enable flac) \
		$(use_enable iconv) \
		$(use_enable iconv freetype) \
		$(use_enable mad) \
		$(use_enable png) \
		$(use_enable vorbis) || die
}

src_install() {
	EXEPREFIX="${PN}-" default
}
