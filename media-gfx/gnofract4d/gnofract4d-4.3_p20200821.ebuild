# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 optfeature virtualx xdg

COMMIT="47752e0d240d9f2686c2a69d813ac5112bda1ad3"

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="https://fract4d.github.io/gnofract4d/"
SRC_URI="https://github.com/fract4d/gnofract4d/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libpng:0=
	virtual/jpeg
	test? (
		media-video/ffmpeg[vpx,zlib]
	)"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3[introspection]"
BDEPEND="virtual/pkgconfig"

distutils_enable_tests pytest

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	sed -i -e "s:share/doc/gnofract4d/:share/doc/${PF}/:" setup.py || die
	# test_regress.py does not provide pytest with any tests and inspecting it requires dev-python/pillow
	rm test_regress.py || die

	distutils-r1_src_prepare
}

python_compile_all() {
	if use test; then
		ln -s "${BUILD_DIR}"/lib/fract4d/*.so fract4d/ || die
	fi
}

src_test() {
	virtx distutils-r1_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "creating videos" media-video/ffmpeg[vpx,zlib]
}
