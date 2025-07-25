# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib systemd toolchain-funcs tmpfiles

DESCRIPTION="Software real-time synthesizer based on the Soundfont 2 specifications"
HOMEPAGE="https://www.fluidsynth.org"
SRC_URI="https://github.com/FluidSynth/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc"
IUSE="alsa dbus debug doc ipv6 jack ladspa openmp oss pipewire portaudio pulseaudio +readline sdl +sndfile systemd threads"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen
		dev-libs/libxslt
	)
"
DEPEND="
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	alsa? (
		media-libs/alsa-lib[${MULTILIB_USEDEP}]
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
	sdl? ( media-libs/libsdl3[${MULTILIB_USEDEP}] )
	sndfile? ( media-libs/libsndfile[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS CONTRIBUTING.md README.md THANKS TODO doc/fluidsynth-v20-devdoc.txt )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	# https://bugs.gentoo.org/833979#c17
	sed -i "/CONFIGURE_COMMAND/{n;s/$/ -DCMAKE_C_COMPILER=$(tc-getBUILD_CC)/}" \
		src/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Denable-alsa=$(usex alsa)
		-Denable-aufile=ON
		-Denable-dbus=$(usex dbus)
		-Denable-dsound=OFF # Windows
		-Denable-floats=OFF # loat instead of double for DSP samples
		-Denable-fpe-check=$(usex debug)
		-Denable-ipv6=$(usex ipv6)
		-Denable-jack=$(usex jack)
		-Denable-ladspa=$(usex ladspa)
		-Denable-libinstpatch=OFF # https://github.com/swami/libinstpatch
		-Denable-midishare=OFF # http://midishare.sourceforge.net/
		-Denable-network=ON
		-Denable-openmp=$(usex openmp)
		-Denable-opensles=OFF
		-Denable-oboe=OFF # requires OpenSLES and/or AAudio
		-Denable-oss=$(usex oss)
		-Denable-libsndfile=$(usex sndfile)
		-Denable-portaudio=$(usex portaudio)
		-Denable-profiling=$(usex debug)
		-Denable-pulseaudio=$(usex pulseaudio)
		-Denable-pipewire=$(usex pipewire)
		-Denable-readline=$(usex readline)
		-Denable-sdl3=$(usex sdl)
		-Denable-sdl2=OFF
		-Denable-systemd=$(multilib_native_usex systemd)
		-Denable-threads=$(usex threads)
		-Denable-trap-on-fpe=$(usex debug)
		-Denable-ubsan=OFF # compile and link against UBSan (for debugging fluidsynth internals)
		-Denable-waveout=OFF # Windows
		-Denable-winmidi=OFF # Windows
		$(cmake_use_find_package doc Doxygen)
		-DFLUID_DAEMON_ENV_FILE="/etc/fluidsynth.conf"
		-DDEFAULT_SOUNDFONT="/usr/share/sounds/sf2/FluidR3_GM.sf2"
	)

	cmake-multilib_src_configure
}

multilib_src_compile() {
	cmake_src_compile
	use doc && multilib_is_native_abi && cmake_build doxygen
}

multilib_src_test() {
	eninja check
}

multilib_src_install() {
	cmake_src_install

	if multilib_is_native_abi ; then
		systemd_dounit "${BUILD_DIR}/fluidsynth.service"

		newtmpfiles "${BUILD_DIR}/fluidsynth.tmpfiles" fluidsynth.conf

		insinto /etc
		doins "${BUILD_DIR}/fluidsynth.conf"

		if use doc ; then
			docinto .
			dodoc -r "${BUILD_DIR}/doc/api/html"
		fi
	fi
}

multilib_src_install_all() {
	docinto pdf
	dodoc doc/*.pdf

	docinto examples
	dodoc doc/examples/*.c

	newinitd "${FILESDIR}/fluidsynth.init" fluidsynth
	newconfd "${FILESDIR}/fluidsynth.confd" fluidsynth
}

pkg_postinst() {
	tmpfiles_process fluidsynth.conf

	elog "When using fluidsynth as a system service, make sure"
	elog "to configure your fluidsynth settings globally in "
	elog "/etc/fluidsynth.conf or per-user in ~/.config/fluidsynth"
}
