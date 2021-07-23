# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 cmake-multilib

DESCRIPTION="Simple Direct Media Layer (sdl-1.2 compatibility)"
HOMEPAGE="https://github.com/libsdl-org/sdl12-compat"
EGIT_REPO_URI="https://github.com/libsdl-org/sdl12-compat"
LICENSE="ZLIB"
SLOT="0"
RESTRICT="!test? ( test )"

# First line are fakes and just there for compat with other ebuilds
IUSE="
	oss alsa nas X dga xv xinerama fbcon tslib aalib opengl libcaca +sound +video +joystick custom-cflags pulseaudio static-libs
	test
"

# IUSE inheritance dropped: dga, xv, fbcon, tflib, aalib, libcaca, custom-cflags, static-libs
DEPEND="
	media-libs/libsdl2[oss?,alsa?,nas?,xinerama?,opengl?,sound?,video?,joystick?,pulseaudio?]
	X? ( || (
		media-libs/libsdl2[X]
		media-libs/libsdl2[wayland]
	) )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DSDL12TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}
