# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Enlightenment Window Manager (E16)"
HOMEPAGE="https://www.enlightenment.org https://sourceforge.net/projects/enlightenment/"
SRC_URI="mirror://sourceforge/enlightenment/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="audiofile container dbus debug +dialogs doc examples gnome
libhack modules nls opengl +pango sndfile sound +themes xcomposite
+xft xi2 xinerama xpresent +xrandr +xrender +xsm +xsync zoom"

REQUIRED_USE="
	audiofile? ( sound )
	opengl? ( xcomposite )
	sndfile? ( sound )
	sound? ( ^^ ( sndfile audiofile ) )
"

BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
COMMON_DEPEND="
	media-libs/freetype:2
	media-libs/imlib2[X]
	virtual/libiconv
	x11-libs/libX11
	x11-libs/libXext
	x11-misc/xbitmaps
	dbus? ( sys-apps/dbus )
	opengl? (
		media-libs/glu
		media-libs/mesa
	)
	pango? (
		dev-libs/glib:2
		x11-libs/pango[X]
	)
	sound? (
		|| (
			media-sound/apulse[sdk]
			media-sound/pulseaudio
		)
		sndfile? ( media-libs/libsndfile )
		audiofile? ( media-libs/audiofile:= )
	)
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXfixes
	)
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
	xpresent? ( x11-libs/libXpresent )
	xrandr? ( x11-libs/libXrandr )
	xrender? ( x11-libs/libXrender )
	xsm? (
		x11-libs/libICE
		x11-libs/libSM
	)
	zoom? ( x11-libs/libXxf86vm )
"
RDEPEND="${COMMON_DEPEND}
	doc? ( app-doc/e16-docs )
	nls? ( virtual/libintl )
	themes? ( x11-themes/e16-themes )
	!x11-wm/enlightenment:0
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"

PATCHES=( "${FILESDIR}/${PN}-user-fonts.patch" )

src_configure() {
	local myconf=(
		$(use_enable container)
		$(use_enable dbus)
		$(use_enable debug libtrip)
		$(use_enable dialogs)
		$(use_enable doc docs)
		$(use_enable libhack)
		$(use_enable modules)
		$(use_enable nls)
		$(use_enable opengl glx)
		$(use_enable pango)
		$(use_enable sound sound pulseaudio)
		$(use_enable xcomposite composite)
		$(use_enable xft)
		$(use_enable xi2)
		$(use_enable xinerama)
		$(use_enable xpresent)
		$(use_enable xrandr)
		$(use_enable xrender)
		$(use_enable xsm sm)
		$(use_enable xsync)
		$(use_enable zoom)
		$(use_with audiofile sndldr audiofile)
		$(use_with gnome gnome gnome3)
		$(use_with sndfile sndldr sndfile)
		--enable-mans
		--disable-docs
		--disable-esdtest
		--disable-gcc-cpp
		--disable-hints-gnome
		--disable-werror
		--disable-xscrnsaver
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	docompress -x /usr/share/doc/${PF}/e16.html
	dodoc COMPLIANCE docs/e16.html
	use examples && dodoc -r sample-scripts
}

pkg_postinst() {
	einfo "In order to use custom fonts, put them into ~/.e16/fonts/ and use"
	einfo "appropriate names in ~/.e16/fonts.cfg. \"Use theme font configuration\""
	einfo "in the Theme setting should be disabled for this to work."
}
