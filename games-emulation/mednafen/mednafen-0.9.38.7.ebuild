# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic pax-utils games

DESCRIPTION="An advanced NES, GB/GBC/GBA, TurboGrafx 16/CD, NGPC and Lynx emulator"
HOMEPAGE="http://mednafen.fobby.net/"
SRC_URI="http://mednafen.fobby.net/releases/files/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa altivec cjk debugger jack nls pax_kernel"

RDEPEND="virtual/opengl
	media-libs/libsndfile
	dev-libs/libcdio
	media-libs/libsdl[sound,joystick,opengl,video]
	media-libs/sdl-net
	sys-libs/zlib[minizip]
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}

pkg_pretend() {
	if has ccache ${FEATURES} ; then
		ewarn
		ewarn "If you experience build failure, try turning off ccache in FEATURES."
		ewarn
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-localedir.patch \
		"${FILESDIR}"/${P}-zlib.patch \
		"${FILESDIR}"/${P}-cflags.patch
	eautoreconf
}

src_configure() {
	# very sensitive code (bug #539992)
	strip-flags
	append-flags -fomit-frame-pointer -fwrapv
	egamesconf \
		$(use_enable alsa) \
		$(use_enable altivec) \
		$(use_enable cjk cjk-fonts) \
		$(use_enable debugger) \
		$(use_enable jack) \
		$(use_enable nls)
}

src_install() {
	DOCS="Documentation/cheats.txt ChangeLog TODO" \
		default
	if use pax_kernel; then
		pax-mark m "${D}${GAMES_BINDIR}"/mednafen || die
	fi
	prepgamesdirs
}
