# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="A modern version of the arcade classic that uses OpenGL"
HOMEPAGE="https://chazomaticus.github.io/asteroid/"
SRC_URI="https://github.com/chazomaticus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/opengl
	media-libs/freeglut
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-mixer
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-libm.patch )
