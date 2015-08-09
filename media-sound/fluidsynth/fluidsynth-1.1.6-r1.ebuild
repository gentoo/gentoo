# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-multilib flag-o-matic

DESCRIPTION="Fluidsynth is a software real-time synthesizer based on the Soundfont 2 specifications"
HOMEPAGE="http://www.fluidsynth.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="alsa dbus debug examples jack ladspa lash portaudio pulseaudio readline sndfile"

RDEPEND=">=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}]
		lash? ( >=media-sound/lash-0.5.4-r2[${MULTILIB_USEDEP}] ) )
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	jack? ( >=media-sound/jack-audio-connection-kit-0.121.3-r1[${MULTILIB_USEDEP}] )
	ladspa? ( >=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}]
		>=media-libs/ladspa-cmt-1.16-r3[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	portaudio? ( >=media-libs/portaudio-19_pre20111121-r1[${MULTILIB_USEDEP}] )
	readline? ( >=sys-libs/readline-6.2_p5-r1[${MULTILIB_USEDEP}] )
	sndfile? ( >=media-libs/libsndfile-1.0.25[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

src_configure() {
	# autotools based build system has AC_CHECK_LIB(pthread, pthread_create) wrt
	# bug #436762
	append-flags -pthread

	mycmakeargs=(
		$(cmake-utils_use alsa enable-alsa)
		$(cmake-utils_use dbus enable-dbus)
		$(cmake-utils_use debug enable-debug)
		$(cmake-utils_use jack enable-jack)
		-Denable-ladcca=OFF
		$(cmake-utils_use ladspa enable-ladspa)
		$(cmake-utils_use sndfile enable-libsndfile)
		$(cmake-utils_use portaudio enable-portaudio)
		$(cmake-utils_use pulseaudio enable-pulseaudio)
		$(cmake-utils_use readline enable-readline)
		)

	if use alsa; then
		mycmakeargs+=( $(cmake-utils_use lash enable-lash) )
	else
		mycmakeargs+=( -Denable-lash=OFF )
	fi

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	dodoc AUTHORS NEWS README THANKS TODO doc/*.txt

	docinto pdf
	dodoc doc/*.pdf

	if use examples; then
		docinto examples
		dodoc doc/*.c
	fi
}
