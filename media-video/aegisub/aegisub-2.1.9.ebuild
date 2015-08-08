# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

WX_GTK_VER="2.8"
inherit autotools wxwidgets

DESCRIPTION="Advanced SSA/ASS subtitle editor"
HOMEPAGE="http://www.aegisub.org/"
SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa debug +ffmpeg lua nls openal oss portaudio pulseaudio spell"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,debug?]
	virtual/opengl
	virtual/glu
	>=media-libs/libass-0.9.11[fontconfig]
	virtual/libiconv
	>=media-libs/fontconfig-2.4.2
	media-libs/freetype:2

	alsa? ( media-libs/alsa-lib )
	portaudio? ( =media-libs/portaudio-19* )
	pulseaudio? ( media-sound/pulseaudio )
	openal? ( media-libs/openal )

	lua? ( >=dev-lang/lua-5.1.1 )

	spell? ( >=app-text/hunspell-1.2 )
	ffmpeg? ( >=media-libs/ffmpegsource-2.17 )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	media-gfx/imagemagick
"

src_prepare() {
	sh autogen.sh --skip-configure
	eautoreconf
}

src_configure() {
	econf \
		$(use_with alsa) \
		$(use_with oss) \
		$(use_with portaudio) \
		$(use_with pulseaudio) \
		$(use_with openal) \
		$(use_with lua) \
		$(use_with ffmpeg ffms) \
		$(use_with spell hunspell) \
		$(use_enable debug) \
		$(use_enable nls)
}
