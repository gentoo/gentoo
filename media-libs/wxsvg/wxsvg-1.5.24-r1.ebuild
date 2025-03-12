# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER=3.2-gtk3
inherit ffmpeg-compat wxwidgets

DESCRIPTION="C++ library to create, manipulate and render SVG files"
HOMEPAGE="http://wxsvg.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="wxWinLL-3"
SLOT="0/3" # based on SONAME of libwxsvg.so
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/expat-2:=
	media-libs/libexif:=
	>=dev-libs/glib-2.28:2=
	dev-libs/libxml2:=
	media-libs/fontconfig:=
	media-libs/freetype:2=
	media-libs/harfbuzz:=
	x11-libs/cairo:=
	x11-libs/pango:=
	x11-libs/wxGTK:${WX_GTK_VER}=[X]
	media-video/ffmpeg-compat:6="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/gcc13.patch"
)

src_configure() {
	# TODO: try using ffmpeg-7 w/o compat in >=wxsvg-1.5.25 (bug #948077)
	ffmpeg_compat_setup 6
	ffmpeg_compat_add_flags

	setup-wxwidgets base-unicode
	econf \
		--disable-static \
		--with-wx-config=${WX_CONFIG}
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
