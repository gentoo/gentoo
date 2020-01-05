# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1

DESCRIPTION="Reimplementation of portions of the pygame API using SDL2"
HOMEPAGE="https://github.com/renpy/pygame_sdl2"
SRC_URI="http://www.renpy.org/dl/${PV}/pygame_sdl2-for-renpy-${PV}.tar.bz2"

LICENSE="LGPL-2.1 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/libpng:0=
	media-libs/libsdl2:=[video]
	media-libs/sdl2-image:=[png,jpeg]
	media-libs/sdl2-mixer:=
	media-libs/sdl2-ttf:=
	virtual/jpeg:0"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

S=${WORKDIR}/pygame-sdl2-for-renpy-${PV}
