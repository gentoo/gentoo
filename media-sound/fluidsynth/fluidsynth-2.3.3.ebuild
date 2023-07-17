# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib systemd toolchain-funcs

DESCRIPTION="Software real-time synthesizer based on the Soundfont 2 specifications"
HOMEPAGE="https://www.fluidsynth.org"
SRC_URI="https://github.com/FluidSynth/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv sparc x86"
IUSE="alsa dbus debug examples ipv6 jack ladspa lash network oss pipewire portaudio pulseaudio +readline sdl +sndfile systemd threads"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	alsa? (
		media-libs/alsa-lib[${MULTILIB_USEDEP}]
		lash? ( media-sound/lash[${MULTILIB_USEDEP}] )
	)
	dbus? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	ladspa? (
		media-libs/ladspa-sdk[${MULTILIB_USEDEP}]
		media-plugins/cmt-plugins[${MULTILIB_USEDEP}]
	)
	pipewire? (
		media-video/pipewire:0=[${MULTILIB_USEDEP}]
	)
	portaudio? ( media-libs/portaudio[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	readline? ( sys-libs/readline:0=[${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )
	sndfile? ( media-libs/libsndfile[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README.md THANKS TODO doc/fluidsynth-v20-devdoc.txt )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_C_COMPILER="$(tc-getCC)"
		-Denable-alsa=$(usex alsa)
		-Denable-aufile=ON
		-Denable-dbus=$(usex dbus)
		-Denable-dsound=OFF # Windows
		-Denable-floats=OFF # loat instead of double for DSP samples
		-Denable-fpe-check=$(usex debug)
		-Denable-ipv6=$(usex ipv6)
		-Denable-jack=$(usex jack)
		-Denable-ladspa=$(usex ladspa)
		-Denable-libinstpatch=ON # https://github.com/swami/libinstpatch
		-Denable-midishare=OFF # http://midishare.sourceforge.net/
		-Denable-network=$(usex network)
		-Denable-opensles=OFF
		-Denable-oboe=OFF # requires OpenSLES and/or AAudio
		-Denable-oss=$(usex oss)
		-Denable-libsndfile=$(usex sndfile)
		-Denable-portaudio=$(usex portaudio)
		-Denable-profiling=$(usex debug)
		-Denable-pulseaudio=$(usex pulseaudio)
		-Denable-pipewire=$(usex pipewire)
		-Denable-readline=$(usex readline)
		-Denable-sdl2=$(usex sdl)
		-Denable-systemd=$(usex systemd)
		-Denable-threads=$(usex threads)
		-Denable-trap-on-fpe=$(usex debug)
		-Denable-ubsan=OFF # compile and link against UBSan (for debugging fluidsynth internals)
		-Denable-waveout=OFF # Windows
		-Denable-winmidi=OFF # Windows
	)

	if use alsa; then
		mycmakeargs+=( -Denable-lash=$(usex lash) )
	else
		mycmakeargs+=( -Denable-lash=OFF )
	fi

	if use systemd; then
		mycmakeargs+=( -DFLUID_DAEMON_ENV_FILE="/etc/fluidsynth.conf" )
	fi

	cmake-multilib_src_configure
}

install_systemd_files() {
	if multilib_is_native_abi; then
		systemd_dounit "${BUILD_DIR}/fluidsynth.service"
		insinto /etc
		doins "${BUILD_DIR}/fluidsynth.conf"
	fi
}

multilib_src_test() {
	eninja check
}

src_install() {
	cmake-multilib_src_install

	docinto pdf
	dodoc doc/*.pdf

	if use examples; then
		docinto examples
		dodoc doc/examples/*.c
	fi

	if use systemd; then
		multilib_foreach_abi install_systemd_files

		elog "When using fluidsynth as a systemd service, make sure"
		elog "to configure your fluidsynth settings globally in "
		elog "/etc/fluidsynth.conf or per-user in ~/.config/fluidsynth"
	fi
}
