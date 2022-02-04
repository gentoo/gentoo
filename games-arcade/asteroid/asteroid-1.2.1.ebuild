# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Modern version of the arcade classic that uses OpenGL"
HOMEPAGE="https://chazomaticus.github.io/asteroid/"
SRC_URI="https://github.com/chazomaticus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/freeglut
	media-libs/libsdl
	media-libs/sdl-mixer
	virtual/glu
	virtual/opengl
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-libm.patch )

src_configure() {
	local mycmakeargs=(
		-DOpenGL_GL_PREFERENCE=GLVND
	)
	cmake_src_configure
}
