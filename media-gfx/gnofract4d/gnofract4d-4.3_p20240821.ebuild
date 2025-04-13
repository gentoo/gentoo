# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson optfeature python-single-r1 virtualx xdg

COMMIT="4202edc865d1f5f3ce3bd3c5fdd72b767f0b89e4"

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="https://fract4d.github.io/gnofract4d/"
SRC_URI="https://github.com/fract4d/gnofract4d/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
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
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		')
	)"

src_prepare() {
	sed -i "s:4.3:${PV}:" meson.build || die
	default
}

src_configure() {
	local emesonargs=(
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-Dstrip=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
	python_fix_shebang "${ED}"/usr/bin/gnofract4d
}

src_test() {
	local EPYTEST_IGNORE=(
		# test_regress.py does not provide pytest with any tests and inspecting it requires dev-python/pillow
		test_regress.py
	)
	local EPYTEST_DESELECT=(
		# terminate called after throwing an instance of 'std::exception'
		test_fract4d.py::Test::testFDSite
	)
	use x86 && EPYTEST_DESELECT+=(
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
