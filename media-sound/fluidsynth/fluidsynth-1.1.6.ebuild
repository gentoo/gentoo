# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils flag-o-matic

DESCRIPTION="Fluidsynth is a software real-time synthesizer based on the Soundfont 2 specifications"
HOMEPAGE="http://www.fluidsynth.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="alsa dbus debug examples jack ladspa lash portaudio pulseaudio readline sndfile"

RDEPEND=">=dev-libs/glib-2.6.5:2
	alsa? ( media-libs/alsa-lib
		lash? ( >=media-sound/lash-0.5 ) )
	dbus? ( >=sys-apps/dbus-1.0.0 )
	jack? ( media-sound/jack-audio-connection-kit )
	ladspa? ( >=media-libs/ladspa-sdk-1.12
		>=media-libs/ladspa-cmt-1.15 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.8 )
	portaudio? ( >=media-libs/portaudio-19_pre )
	readline? ( sys-libs/readline )
	sndfile? ( >=media-libs/libsndfile-1.0.18 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

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

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc AUTHORS NEWS README THANKS TODO doc/*.txt

	insinto /usr/share/doc/${PF}/pdf
	doins doc/*.pdf

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins doc/*.c
	fi
}
