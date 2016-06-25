# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER=3.0
inherit wxwidgets eutils flag-o-matic games

DESCRIPTION="utilities for the SCUMM game engine"
HOMEPAGE="http://scummvm.sourceforge.net/"
SRC_URI="http://scummvm.org/frs/scummvm-tools/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd"
IUSE="flac iconv mad png vorbis"
RESTRICT="test" # some tests require external files

RDEPEND="png? ( media-libs/libpng:0 )
	mad? ( media-libs/libmad )
	flac? ( media-libs/flac )
	vorbis? ( media-libs/libvorbis )
	iconv? ( virtual/libiconv media-libs/freetype:2 )
	sys-libs/zlib
	>=dev-libs/boost-1.32
	x11-libs/wxGTK:${WX_GTK_VER}"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

src_prepare() {
	need-wxwidgets unicode
	rm -rf *.bat dists/win32
	sed -ri -e '/^(CC|CXX)\b/d' Makefile || die
	epatch "${FILESDIR}/${P}-binprefix.patch"
}

src_configure() {
	# Not an autoconf script
	./configure \
		--enable-verbose-build \
		--mandir=/usr/share/man \
		--prefix="${GAMES_PREFIX}" \
		--libdir="${GAMES_PREFIX}/lib" \
		--datadir="${GAMES_DATADIR}" \
		--disable-tremor \
		$(use_enable flac) \
		$(use_enable iconv) \
		$(use_enable iconv freetype) \
		$(use_enable mad) \
		$(use_enable png) \
		$(use_enable vorbis) || die
}

src_install() {
	EXEPREFIX="${PN}-" default
	prepgamesdirs
}
