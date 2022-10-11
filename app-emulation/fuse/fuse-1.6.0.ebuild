# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic xdg

DESCRIPTION="Free Unix Spectrum Emulator by Philip Kendall"
HOMEPAGE="http://fuse-emulator.sourceforge.net"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE="alsa ao backend-X backend-fbcon +backend-gtk3 backend-sdl backend-svga gpm joystick memlimit png pulseaudio +xml +zlib"

# TODO:
# - allow using sdl audio driver without using for the UI
# - allow using sdl joystick support with gtk3 or X UI in place of libjsw
# - when using sdl for one of the above but not the UI, allow using sdl2 instead

# At most one audio driver and at most one UI back-end can be enabled at a time
REQUIRED_USE="?? ( alsa ao backend-sdl pulseaudio )
	?? ( backend-X backend-fbcon backend-gtk3 backend-sdl backend-svga )"

RDEPEND="
	>=app-emulation/libspectrum-1.5.0[zlib?]
	dev-libs/glib:2
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	backend-X? ( x11-libs/libX11 x11-libs/libXext )
	backend-gtk3? ( x11-libs/gtk+:3 )
	backend-sdl? ( media-libs/libsdl[joystick,sound] )
	backend-svga? ( media-libs/svgalib )
	gpm? ( backend-fbcon? ( sys-libs/gpm ) )
	joystick? ( !backend-sdl? ( media-libs/libjsw ) )
	png? ( media-libs/libpng:0= )
	pulseaudio? ( media-sound/pulseaudio )
	xml? ( dev-libs/libxml2:2 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	backend-fbcon? ( virtual/linux-sources )"
BDEPEND="dev-lang/perl
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README THANKS )

PATCHES=(
	"${FILESDIR}"/remove-local-prefix.patch
)

_fuse_audio_driver() {
	if use alsa; then
		echo "alsa"
	elif use ao; then
		echo "libao"
	elif use backend-sdl; then
		echo "sdl"
	elif use pulseaudio; then
		echo "pulseaudio"
	else
		echo "null"
	fi
}

src_prepare() {
	default
	xdg_environment_reset
	eautoreconf

	# Bug #854522
	filter-lto
}

src_configure() {
	local myconf=(
		--enable-desktop-integration
		--without-win32
		--with-audio-driver="$(_fuse_audio_driver)"
		$(use_with gpm)
		$(use_with joystick)
		$(use_enable memlimit smallmem)
		$(use_with png)
		$(use_with xml libxml2)
		$(use_with zlib)
	)

	# The pure-X UI hasn't got its own configure argument, instead it is
	# what is used under Linux if all other back-ends have been disabled
	# - and all except the Gtk+ one are off by default.
	if use backend-X; then
		myconf+=("--without-gtk")
	elif use backend-fbcon; then
		myconf+=("--with-fb")
	elif use backend-gtk3; then
		myconf+=("--with-gtk")
	elif use backend-sdl; then
		myconf+=("--with-sdl")
	elif use backend-svga; then
		myconf+=("--with-svgalib")
	else
		myconf+=("--with-null-ui")
	fi

	if use joystick; then
		myconf+=( $(use_enable backend-sdl ui-joystick) )
	fi

	econf "${myconf[@]}"
}

src_test() {
	emake test
}

pkg_postinst() {
	xdg_pkg_postinst
	if use pulseaudio; then
		ewarn "The PulseAudio driver in ${PN} is experimental"
	fi
}
