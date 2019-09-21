# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Free Unix Spectrum Emulator by Philip Kendall"
HOMEPAGE="http://fuse-emulator.sourceforge.net"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa ao backend-fbcon backend-sdl backend-svga backend-X gpm joystick memlimit png xml"

# Only one UI back-end can be enabled at a time
REQUIRED_USE="?? ( backend-fbcon backend-sdl backend-svga backend-X )"

RDEPEND="
	>=app-emulation/libspectrum-1.4.4
	dev-libs/glib:2
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	backend-sdl? ( media-libs/libsdl )
	backend-svga? ( media-libs/svgalib )
	backend-X? ( x11-libs/libX11 x11-libs/libXext )
	!backend-fbcon? ( !backend-sdl? ( !backend-svga? ( !backend-X? ( x11-libs/gtk+:3 ) ) ) )
	gpm? ( sys-libs/gpm )
	joystick? ( media-libs/libjsw )
	png? ( media-libs/libpng:0= sys-libs/zlib )
	xml? ( dev-libs/libxml2:2 )"
DEPEND="${RDEPEND}
	backend-fbcon? ( virtual/linux-sources )
	dev-lang/perl
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README THANKS )

src_configure() {
	local myconf=(
		--without-win32
		$(use_with alsa)
		$(use_with ao libao)
		$(use_with gpm)
		$(use_with joystick)
		$(use_enable joystick ui-joystick)
		$(use_enable memlimit smallmem)
		$(use_with png)
		$(use_with xml libxml2)
	)

	if use backend-sdl; then
		myconf+=("--with-sdl")
	elif use backend-X; then
		myconf+=("--without-gtk")
	elif use backend-svga; then
		myconf+=("--with-svgalib")
	elif use backend-fbcon; then
		myconf+=("--with-fb")
	else
		myconf+=("--with-gtk")
	fi

	econf "${myconf[@]}"
}

src_test() {
	emake test
}
