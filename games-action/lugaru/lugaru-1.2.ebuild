# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="3D arcade with unique fighting system and anthropomorphic characters"
HOMEPAGE="https://osslugaru.gitlab.io/"
SRC_URI="https://gitlab.com/osslugaru/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+ CC-BY-SA-3.0 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/jsoncpp:=
	media-libs/libpng:0=
	media-libs/libsdl2:=[opengl,video]
	media-libs/libvorbis:=
	media-libs/openal:=
	sys-libs/zlib:=
	virtual/glu
	virtual/jpeg:0
	virtual/opengl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DSYSTEM_INSTALL=ON
	)
	cmake_src_configure
}
