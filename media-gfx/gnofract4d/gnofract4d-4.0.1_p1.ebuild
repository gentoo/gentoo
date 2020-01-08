# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 eutils virtualx xdg

COMMIT=bd600c20921afff7b02fc0a76ab79242ebd0896d

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="http://edyoung.github.io/gnofract4d/"
SRC_URI="https://github.com/edyoung/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc"
REQUIRED_USE="test? ( doc )"

COMMON_DEPEND="
	media-libs/libpng:0=
	virtual/jpeg:0"
RDEPEND="${COMMON_DEPEND}
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]"
BDEPEND="virtual/pkgconfig"
DEPEND="${COMMON_DEPEND}
	doc? (
		app-text/docbook-xsl-stylesheets
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-libs/libxslt
		x11-libs/gtk+:3[introspection]
	)"

distutils_enable_tests pytest

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	distutils-r1_src_prepare
}

python_test() {
	virtx pytest fract4d fract4dgui test.py || die
}

python_compile_all() {
	if use doc; then
		ln -s "${BUILD_DIR}"/lib/fract4d/*.so fract4d/ || die
		"${EPYTHON}" createdocs.py || die
	fi
}

python_install_all() {
	distutils-r1_python_install_all
	rm -r "${ED}"/usr/share/doc/${PN} || die
	if ! use doc; then
		rm -r "${ED}"/usr/share/gnome/help/${PN} || die
	fi
}

pkg_postinst() {
	elog "Optional missing features:"
	optfeature "creating videos" media-video/ffmpeg[vpx,zlib]
}
