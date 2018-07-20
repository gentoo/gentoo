# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Scientific data 3-dimensional visualizer"
HOMEPAGE="
	http://code.enthought.com/projects/mayavi/
	https://pypi.org/project/mayavi/"
SRC_URI="https://github.com/enthought/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND="
	>=dev-python/apptools-4[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/envisage-4[${PYTHON_USEDEP}]
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyface[${PYTHON_USEDEP}]
	>=dev-python/traitsui-4[${PYTHON_USEDEP}]
	dev-python/wxpython:*[opengl,${PYTHON_USEDEP}]"
CDEPEND="sci-libs/vtk[python,rendering]"
DEPEND="
	${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/wxpython[opengl]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

# testsuite is a trainwreck; https://github.com/enthought/mayavi/issues/66
#RESTRICT="test"

# not sure if this is still needed
#PATCHES=( "${FILESDIR}"/${PN}-4.2.0-doc.patch )

python_compile_all() {
	if use doc; then
		esetup.py gen_docs
		esetup.py build_docs
	fi
}

python_test() {
	VIRTUALX_COMMAND="nosetests" virtualmake
}

python_install_all() {
	use examples && EXAMPLES=( examples/. )
	use doc && HTML_DOCS=( docs/build/mayavi/html/. )
	distutils-r1_python_install_all

	newicon mayavi/core/ui/images/m2.png mayavi2.png
	make_desktop_entry ${PN}2 \
		"Mayavi2 2D/3D Scientific Visualization" ${PN}2
}
