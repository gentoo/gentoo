# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx flag-o-matic

DESCRIPTION="Enthought Tool Suite: Drawing and interaction packages"
HOMEPAGE="http://docs.enthought.com/enable/
	https://pypi.org/project/enable
	https://github.com/enthought/enable"
SRC_URI="https://github.com/enthought/enable/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RESTRICT="test" # Until https://github.com/enthought/enable/issues/303 is solved

RDEPEND="
	dev-python/apptools[${PYTHON_USEDEP}]
	dev-python/kiwisolver[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	>=dev-python/traitsui-4[${PYTHON_USEDEP}]
	media-libs/freetype:2
	virtual/opengl
	virtual/glu
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-lang/swig:0
	dev-python/cython[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/fonttools[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyface[${PYTHON_USEDEP}]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)
"

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	append-cflags -fno-strict-aliasing

	sed -e 's:html_favicon = "et.ico":html_favicon = "_static/et.ico":' \
		-i docs/source/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	pushd "${BUILD_DIR}"/lib > /dev/null
	# https://github.com/enthought/enable/issues/303
	virtx coverage run -m nose.core enable -v
	virtx coverage run -a -m nose.core kiva -v
	popd > /dev/null
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )

	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
