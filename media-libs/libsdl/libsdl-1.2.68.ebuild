# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Simple Direct Media Layer 1.2 compatibility wrapper around SDL2"
HOMEPAGE="https://github.com/libsdl-org/sdl12-compat"
if [[ ${PV} == *_p* ]] ; then
	MY_COMMIT="f94a1ec0069266e40843138d0c5dd2fc6d43734c"
	SRC_URI="https://github.com/libsdl-org/sdl12-compat/archive/${MY_COMMIT}.tar.gz -> libsdl-${PV}.tar.gz"
	S="${WORKDIR}"/sdl12-compat-${MY_COMMIT}
else
	SRC_URI="https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/sdl12-compat-release-${PV}"
fi

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc"

# IUSE dropped from real SDL1: aalib custom-cflags dga fbcon libcaca nas oss pulseaudio static-libs tslib xinerama xv
IUSE="alsa +joystick opengl +sound test +video X"
REQUIRED_USE="test? ( joystick opengl sound video )"

# The tests are more like example programs.
RESTRICT="test"

RDEPEND="
	media-libs/libsdl2[${MULTILIB_USEDEP},alsa=,joystick=,opengl=,sound=,video=,X=]
"

DEPEND="
	${RDEPEND}
	test? ( virtual/opengl[${MULTILIB_USEDEP}] )
"

src_configure() {
	local mycmakeargs=(
		-DSDL12TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}
