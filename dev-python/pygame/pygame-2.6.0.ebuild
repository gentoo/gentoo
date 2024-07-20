# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1

DESCRIPTION="Python bindings for SDL multimedia library"
HOMEPAGE="
	https://www.pygame.org/
	https://github.com/pygame/pygame/
	https://pypi.org/project/pygame/
"
SRC_URI="
	https://github.com/pygame/pygame/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~x86"
IUSE="examples opengl test X"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	media-libs/freetype
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/portmidi
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	X? ( media-libs/libsdl2[opengl?,threads(+),video,X] )
	!X? ( media-libs/libsdl2[threads(+)] )
"
DEPEND="
	${RDEPEND}
	test? (
		media-libs/sdl2-image[gif,jpeg,png,tiff,webp]
		media-libs/sdl2-mixer[mp3,vorbis,wav]
	)
"
# fontconfig used for fc-list
RDEPEND+="
	media-libs/fontconfig
"
# util-linux provides script
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	test? (
		media-libs/fontconfig
		sys-apps/util-linux
	)
"

src_prepare() {
	distutils-r1_src_prepare

	# some numpy-related crash (not a regression)
	# https://github.com/pygame/pygame/issues/4049
	sed -e 's:import numpy:raise ImportError(""):' \
		-i test/pixelcopy_test.py || die
}

python_configure() {
	PORTMIDI_INC_PORTTIME=1 LOCALBASE="${EPREFIX}/usr" \
		"${EPYTHON}" "${S}"/buildconfig/config.py || die
}

python_configure_all() {
	find src_c/cython -name '*.pyx' -exec touch {} + || die
	"${EPYTHON}" setup.py cython_only || die
}

python_test() {
	local -x SDL_VIDEODRIVER=dummy
	local -x SDL_AUDIODRIVER=disk
	script -eqc "${EPYTHON} -m pygame.tests -v" || die
}

python_install() {
	distutils-r1_python_install

	# https://bugs.gentoo.org/497720
	rm -fr "${D}$(python_get_sitedir)"/pygame/{docs,examples} || die
}

python_install_all() {
	distutils-r1_python_install_all
	use examples && dodoc -r examples
}
