# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Free Unix Spectrum Emulator by Philip Kendall"
HOMEPAGE="http://fuse-emulator.sourceforge.net"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa ao fbcon gpm gtk joystick memlimit png sdl svga X xml"

# Only one UI back-end can be enabled at a time
REQUIRED_USE="^^ ( X fbcon gtk sdl svga )"

RDEPEND=">=app-emulation/libspectrum-1.4.0
	dev-libs/glib:2
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	gpm? ( sys-libs/gpm )
	gtk? ( x11-libs/gtk+:3 )
	joystick? ( media-libs/libjsw )
	png? ( media-libs/libpng:0= sys-libs/zlib )
	sdl? ( media-libs/libsdl )
	svga? ( media-libs/svgalib )
	X? ( x11-libs/libX11
		x11-libs/libXext )
	xml? ( dev-libs/libxml2:2 )"
DEPEND="${RDEPEND}
	fbcon? ( virtual/linux-sources )
	dev-lang/perl
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README THANKS )

src_configure() {
	local guiflag

	if use gtk; then
		guiflag=""
	elif use sdl; then
		guiflag="--with-sdl"
	elif use X; then
		guiflag="--without-gtk"
	elif use svga; then
		guiflag="--with-svgalib"
	elif use fbcon; then
		guiflag="--with-fb"
	fi

	econf \
		--without-win32 \
		${guiflag} \
		$(use_with alsa) \
		$(use_with ao libao) \
		$(use_with gpm) \
		$(use_with joystick) \
		$(use_enable joystick ui-joystick) \
		$(use_enable memlimit smallmem) \
		$(use_with png) \
		$(use_with xml libxml2)
}
