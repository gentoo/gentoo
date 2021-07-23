# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="Simple Direct Media Layer (sdl-1.2 compatibility)"
HOMEPAGE="https://github.com/libsdl-org/sdl12-compat"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libsdl-org/sdl12-compat"
else
	SRC_URI="https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/sdl12-compat-release-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="ZLIB"
SLOT="0"
RESTRICT="!test? ( test )"

# First line are IUSE flags common between <libsdl-1.2.50 and libsdl2
# It drops: aalib custom-cflags dga fbcon libcaca static-libs tslib xv
IUSE="
	alsa +joystick nas opengl oss pulseaudio +sound +video X xinerama
	test
"

DEPEND="media-libs/libsdl2[alsa?,joystick?,nas?,opengl?,oss?,pulseaudio?,sound?,video?,X?,xinerama?]"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DSDL12TESTS=$(usex test)
	)

	cmake-multilib_src_configure
}
