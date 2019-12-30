# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

MY_P="${PN}-soft-${PV}"

DESCRIPTION="A software implementation of the OpenAL 3D audio API"
HOMEPAGE="https://www.openal-soft.org/"
SRC_URI="https://www.openal-soft.org/openal-releases/${MY_P}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="
	alsa coreaudio debug jack oss portaudio pulseaudio sdl qt5
	cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse4_1
	cpu_flags_arm_neon
"

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	portaudio? ( >=media-libs/portaudio-19_pre20111121-r1[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )"

S="${WORKDIR}/${MY_P}"

DOCS=( alsoftrc.sample docs/env-vars.txt docs/hrtf.txt ChangeLog README.md )

src_configure() {
	# -DEXAMPLES=OFF to avoid FFmpeg dependency wrt #481670
	my_configure() {
		local mycmakeargs=(
			-DALSOFT_REQUIRE_ALSA=$(usex alsa)
			-DALSOFT_REQUIRE_COREAUDIO=$(usex coreaudio)
			-DALSOFT_REQUIRE_JACK=$(usex jack)
			-DALSOFT_REQUIRE_OSS=$(usex oss)
			-DALSOFT_REQUIRE_PORTAUDIO=$(usex portaudio)
			-DALSOFT_REQUIRE_PULSEAUDIO=$(usex pulseaudio)
			-DALSOFT_REQUIRE_SDL2=$(usex sdl)
			-DALSOFT_CPUEXT_SSE=$(usex cpu_flags_x86_sse)
			-DALSOFT_CPUEXT_SSE2=$(usex cpu_flags_x86_sse2)
			-DALSOFT_CPUEXT_SSE4_1=$(usex cpu_flags_x86_sse4_1)
			-DALSOFT_UTILS=$(multilib_is_native_abi && echo "ON" || echo "OFF")
			-DALSOFT_NO_CONFIG_UTIL=$(usex qt5 "$(multilib_is_native_abi && echo "OFF" || echo "ON")" ON)
			-DALSOFT_EXAMPLES=OFF
		)

		use cpu_flags_arm_neon && mycmakeargs+=( -DALSOFT_CPUEXT_NEON=$(usex cpu_flags_arm_neon) )

		cmake_src_configure
	}

	multilib_parallel_foreach_abi my_configure
}
