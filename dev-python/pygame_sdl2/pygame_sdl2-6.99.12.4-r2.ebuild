# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1

PYSDL="${PN}-2.1.0"

DESCRIPTION="Reimplementation of portions of the pygame API using SDL2"
HOMEPAGE="https://github.com/renpy/pygame_sdl2"
SRC_URI="http://www.renpy.org/dl/${PV}/${PYSDL}-for-renpy-${PV}.tar.gz"

LICENSE="LGPL-2.1 ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/libpng:0=
	media-libs/libsdl2:=[video]
	media-libs/sdl2-image:=[png,jpeg]
	>=media-libs/sdl2-mixer-2.0.2:=
	media-libs/sdl2-ttf:=
	virtual/jpeg:0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PYSDL}-for-renpy-${PV}

PATCHES=( "${FILESDIR}/pygame_sdl2-6.99.12.4-mixer.patch" )

# PyGame distribution for this version has some pregenerated files;
# we need to remove them
python_prepare_all()
{
	rm -r gen{,3} || die
	distutils-r1_python_prepare_all
}
