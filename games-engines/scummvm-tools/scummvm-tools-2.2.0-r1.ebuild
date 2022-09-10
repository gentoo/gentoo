# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER=3.0-gtk3
inherit wxwidgets toolchain-funcs

DESCRIPTION="utilities for the SCUMM game engine"
HOMEPAGE="http://scummvm.sourceforge.net/"
SRC_URI="http://scummvm.org/frs/scummvm-tools/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="flac iconv mad png vorbis"
RESTRICT="test" # some tests require external files

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib
	x11-libs/wxGTK:${WX_GTK_VER}
	flac? ( media-libs/flac:= )
	iconv? ( virtual/libiconv media-libs/freetype:2 )
	mad? ( media-libs/libmad )
	png? ( media-libs/libpng:= )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.8.0-binprefix.patch"
	"${FILESDIR}/${PN}-2.2.0-strings.patch"
)

src_prepare() {
	default

	rm -r *.bat dists/win32 || die
}

src_configure() {
	setup-wxwidgets
	tc-export CXX STRINGS

	# Not an autoconf script
	./configure \
		--disable-tremor \
		--enable-verbose-build \
		--mandir="${EPREFIX}/usr/share/man" \
		--prefix="${EPREFIX}/usr" \
		$(use_enable flac) \
		$(use_enable iconv) \
		$(use_enable iconv freetype2) \
		$(use_enable mad) \
		$(use_enable png) \
		$(use_enable vorbis) || die
}

src_install() {
	EXEPREFIX="${PN}-" default
}
