# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature virtualx xdg

COMMIT="47d2093e8f6399d1badfba0d1cb0f9867e90b326"

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="https://fract4d.github.io/gnofract4d/"
SRC_URI="https://github.com/fract4d/gnofract4d/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libjpeg-turbo:0=
	media-libs/libpng:0="
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	gui-libs/gtk:4[introspection]"
BDEPEND="
	virtual/pkgconfig
	test? (
		media-video/ffmpeg[vpx,zlib]
	)"

distutils_enable_tests pytest

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	sed -i -e "s:VERSION = '4.3':VERSION = '$PV':" fract4d/options.py || die
	sed -i -e "s:share/doc/gnofract4d/:share/doc/${PF}/:" setup.py || die

	distutils-r1_src_prepare
}

python_test() {
	ln -s "${BUILD_DIR}"/lib/fract4d/*.so fract4d/ || die
	local EPYTEST_IGNORE=(
		# test_regress.py does not provide pytest with any tests and inspecting it requires dev-python/pillow
		test_regress.py
	)
	use x86 && local EPYTEST_DESELECT=(
		# https://bugs.gentoo.org/890796
		test_fractal.py::Test::testDiagonal
		test_fractal.py::Test::testRecolor
	)
	TMPDIR="${T}" virtx epytest
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "creating videos" media-video/ffmpeg[vpx,zlib]
}
