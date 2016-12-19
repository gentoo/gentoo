# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic pax-utils

DESCRIPTION="An advanced NES, GB/GBC/GBA, TurboGrafx 16/CD, NGPC and Lynx emulator"
HOMEPAGE="http://mednafen.fobby.net/"
SRC_URI="http://mednafen.fobby.net/releases/files/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa altivec cjk debugger jack nls pax_kernel"

RDEPEND="
	dev-libs/libcdio
	media-libs/libsdl[sound,joystick,opengl,video]
	media-libs/libsndfile
	media-libs/sdl-net
	sys-libs/zlib[minizip]
	virtual/opengl
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.39.2-remove-cflags.patch
	"${FILESDIR}"/${PN}-0.9.39.2-localedir.patch
	"${FILESDIR}"/${PN}-0.9.39.2-zlib.patch
)

pkg_pretend() {
	if has ccache ${FEATURES}; then
		ewarn
		ewarn "If you experience build failure, try turning off ccache in FEATURES."
		ewarn
	fi
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# very sensitive code (bug #539992)
	strip-flags
	append-flags -fomit-frame-pointer -fwrapv
	econf \
		$(use_enable alsa) \
		$(use_enable altivec) \
		$(use_enable cjk cjk-fonts) \
		$(use_enable debugger) \
		$(use_enable jack) \
		$(use_enable nls)
}

src_install() {
	default
	dodoc Documentation/cheats.txt

	if use pax_kernel; then
		pax-mark m "${ED%/}"/bin/mednafen || die
	fi
}
