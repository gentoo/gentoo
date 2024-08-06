# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# False positives because of REQUIRE vs BACKEND options() (conditionally set)
# See bug #809314
CMAKE_WARN_UNUSED_CLI=no
inherit cmake-multilib

MY_P="${PN}-soft-${PV}"

DESCRIPTION="A software implementation of the OpenAL 3D audio API"
HOMEPAGE="https://www.openal-soft.org/"
SRC_URI="https://www.openal-soft.org/openal-releases/${MY_P}.tar.bz2"
S="${WORKDIR}"/${MY_P}

# See https://github.com/kcat/openal-soft/blob/e0097c18b82d5da37248c4823fde48b6e0002cdd/BSD-3Clause
# Some components are under BSD
LICENSE="LGPL-2+ BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"
IUSE="
	alsa coreaudio debug jack oss pipewire portaudio pulseaudio sdl sndio qt5
	cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse4_1
	cpu_flags_arm_neon
"

# PipeWire:
# - See bug #863200 for PipeWire minimum version
# - PW is in DEPEND although not linked against because we need configure to
# find it anyway, but no :=.
RDEPEND="
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	pipewire? ( media-video/pipewire[${MULTILIB_USEDEP}] )
	portaudio? ( media-libs/portaudio[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-libs/libpulse[${MULTILIB_USEDEP}] )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )
	sndio? ( media-sound/sndio:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
"

DOCS=( alsoftrc.sample docs/env-vars.txt docs/hrtf.txt ChangeLog README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-1.23.1-gcc15-cstdint.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		# See bug #809314 for getting both options for backends
		-DALSOFT_{BACKEND,REQUIRE}_ALSA=$(usex alsa)
		-DALSOFT_{BACKEND,REQUIRE}_COREAUDIO=$(usex coreaudio)
		-DALSOFT_{BACKEND,REQUIRE}_JACK=$(usex jack)
		-DALSOFT_{BACKEND,REQUIRE}_OSS=$(usex oss)
		-DALSOFT_{BACKEND,REQUIRE}_PIPEWIRE=$(usex pipewire)
		-DALSOFT_{BACKEND,REQUIRE}_PORTAUDIO=$(usex portaudio)
		-DALSOFT_{BACKEND,REQUIRE}_PULSEAUDIO=$(usex pulseaudio)
		-DALSOFT_{BACKEND,REQUIRE}_SDL2=$(usex sdl)
		-DALSOFT_{BACKEND,REQUIRE}_SNDIO=$(usex sndio)

		-DALSOFT_UTILS=$(multilib_is_native_abi && echo "ON" || echo "OFF")
		-DALSOFT_NO_CONFIG_UTIL=$(usex qt5 "$(multilib_is_native_abi && echo "OFF" || echo "ON")" ON)
		 # EXAMPLES=OFF to avoid FFmpeg dependency, bug #481670
		-DALSOFT_EXAMPLES=OFF
	)

	# Avoid unused variable warnings, bug #738240
	if use amd64 || use x86 ; then
		mycmakeargs+=(
			-DALSOFT_CPUEXT_SSE=$(usex cpu_flags_x86_sse)
			-DALSOFT_CPUEXT_SSE2=$(usex cpu_flags_x86_sse2)
			-DALSOFT_CPUEXT_SSE4_1=$(usex cpu_flags_x86_sse4_1)
		)
	elif use arm || use arm64 ; then
		mycmakeargs+=(
			-DALSOFT_CPUEXT_NEON=$(usex cpu_flags_arm_neon)
		)
	fi

	cmake_src_configure
}
