# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib flag-o-matic

DESCRIPTION="Software real-time synthesizer based on the Soundfont 2 specifications"
HOMEPAGE="http://www.fluidsynth.org/"
SRC_URI="https://github.com/FluidSynth/fluidsynth/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 ~hppa ppc ppc64 sparc x86"
IUSE="alsa dbus debug examples ipv6 jack ladspa lash portaudio pulseaudio readline sndfile"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	alsa? (
		>=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}]
		lash? ( >=media-sound/lash-0.5.4-r2[${MULTILIB_USEDEP}] )
	)
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	ladspa? (
		>=media-libs/ladspa-cmt-1.16-r3[${MULTILIB_USEDEP}]
		>=media-libs/ladspa-sdk-1.13-r2[${MULTILIB_USEDEP}]
	)
	portaudio? ( >=media-libs/portaudio-19_pre20111121-r1[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	readline? ( >=sys-libs/readline-6.2_p5-r1:0=[${MULTILIB_USEDEP}] )
	sndfile? ( >=media-libs/libsndfile-1.0.25[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

DOCS=( AUTHORS NEWS README.md THANKS TODO doc/{fluidsynth-v11-devdoc,xtrafluid}.txt )

src_configure() {
	# autotools based build system has AC_CHECK_LIB(pthread, pthread_create) wrt
	# bug #436762
	append-flags -pthread

	local mycmakeargs=(
		-Denable-alsa=$(usex alsa)
		-Denable-dbus=$(usex dbus)
		-Denable-debug=$(usex debug)
		-Denable-ipv6=$(usex ipv6)
		-Denable-jack=$(usex jack)
		-Denable-ladcca=OFF
		-Denable-ladspa=$(usex ladspa)
		-Denable-libsndfile=$(usex sndfile)
		-Denable-portaudio=$(usex portaudio)
		-Denable-pulseaudio=$(usex pulseaudio)
		-Denable-readline=$(usex readline)
	)

	if use alsa; then
		mycmakeargs+=( -Denable-lash=$(usex lash) )
	else
		mycmakeargs+=( -Denable-lash=OFF )
	fi

	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install

	docinto pdf
	dodoc doc/*.pdf

	if use examples; then
		docinto examples
		dodoc doc/*.c
	fi
}
