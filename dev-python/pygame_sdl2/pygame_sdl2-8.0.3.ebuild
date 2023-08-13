# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

PYSDL="${PN}-2.1.0"

DESCRIPTION="Reimplementation of portions of the pygame API using SDL2"
HOMEPAGE="https://github.com/renpy/pygame_sdl2"
SRC_URI="https://www.renpy.org/dl/${PV}/${PYSDL}-for-renpy-${PV}.tar.gz"

LICENSE="LGPL-2.1 ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

# <cython-3 for bug #911781
BDEPEND="
	<dev-python/cython-3[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/libsdl2:=[video]
	media-libs/sdl2-image:=[png,jpeg]
	>=media-libs/sdl2-mixer-2.0.2:=
	media-libs/sdl2-ttf:=
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PYSDL}-for-renpy-${PV}

python_prepare_all() {
	# PyGame distribution for this version has some pregenerated files;
	# we need to remove them
	rm -r gen{,3,-static} || die

	# Fix tag name according to PEP 440
	sed -i 's/-for-renpy-/+renpy/' setup.cfg || die

	distutils-r1_python_prepare_all
}
