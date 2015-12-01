# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-multilib

MY_P=${PN}-soft-${PV}

DESCRIPTION="A software implementation of the OpenAL 3D audio API"
HOMEPAGE="http://kcat.strangesoft.net/openal.html"
SRC_URI="http://kcat.strangesoft.net/openal-releases/${MY_P}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="
	alsa coreaudio debug oss portaudio pulseaudio qt4
	cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse4_1
	neon
"

RDEPEND="alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	portaudio? ( >=media-libs/portaudio-19_pre20111121-r1[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	qt4? ( dev-qt/qtgui:4 dev-qt/qtcore:4 )
	abi_x86_32? (
		!<app-emulation/emul-linux-x86-sdl-20131008-r1
		!app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	oss? ( virtual/os-headers )"

S=${WORKDIR}/${MY_P}

DOCS="alsoftrc.sample env-vars.txt hrtf.txt ChangeLog README"

src_configure() {
	# -DEXAMPLES=OFF to avoid FFmpeg dependency wrt #481670
	my_configure() {
		local mycmakeargs=(
			"-DALSOFT_BACKEND_ALSA=$(usex alsa ON OFF)"
			"-DALSOFT_BACKEND_COREAUDIO=$(usex coreaudio ON OFF)"
			"-DALSOFT_BACKEND_OSS=$(usex oss ON OFF)"
			"-DALSOFT_BACKEND_PORTAUDIO=$(usex portaudio ON OFF)"
			"-DALSOFT_BACKEND_PULSEAUDIO=$(usex pulseaudio ON OFF)"
			"-DALSOFT_CPUEXT_SSE=$(usex cpu_flags_x86_sse ON OFF)"
			"-DALSOFT_CPUEXT_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)"
			"-DALSOFT_CPUEXT_SSE4_1=$(usex cpu_flags_x86_sse4_1 ON OFF)"
			"-DALSOFT_CPUEXT_NEON=$(usex neon ON OFF)"
			"-DALSOFT_UTILS=$(multilib_is_native_abi && echo "ON" || echo "OFF")"
			"-DALSOFT_NO_CONFIG_UTIL=$(usex qt4 "$(multilib_is_native_abi && echo "OFF" || echo "ON")" ON)"
			"-DALSOFT_EXAMPLES=OFF"
		)

		cmake-utils_src_configure
	}

	multilib_parallel_foreach_abi my_configure
}
