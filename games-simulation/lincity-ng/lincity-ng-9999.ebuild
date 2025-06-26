# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake xdg

DESCRIPTION="City simulation game"
HOMEPAGE="https://github.com/lincity-ng/lincity-ng"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/lincity-ng/lincity-ng"
	inherit git-r3
else
	SRC_URI="https://github.com/lincity-ng/lincity-ng/releases/download/${P}/${P}-Source.tar.xz"
	S="${WORKDIR}"/${P}-Source

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+ BitstreamVera CC-BY-SA-2.0"
SLOT="0"

RDEPEND="
	dev-libs/libxml2:2=
	dev-cpp/libxmlpp:5.0=
	>=media-libs/libsdl2-2.0.18[joystick,opengl,sound,video]
	>=media-libs/sdl2-image-2.0.0[png]
	>=media-libs/sdl2-mixer-2.0.0[vorbis]
	>=media-libs/sdl2-ttf-2.0.12
	>=sys-libs/zlib-1.0
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxslt
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure(){
	local mycmakeargs=( -DCMAKE_BUILD_TYPE=Release )
	cmake_src_configure
}
