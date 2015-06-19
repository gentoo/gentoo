# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/mayavi/mayavi-4.3.0.ebuild,v 1.2 2015/03/06 22:43:56 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Scientific data 3-dimensional visualizer"
HOMEPAGE="
	http://code.enthought.com/projects/mayavi/
	http://pypi.python.org/pypi/mayavi/"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

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
	dev-python/wxpython[${PYTHON_USEDEP}]"
CDEPEND="sci-libs/vtk[python]"
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

#DOCS="docs/*.txt"

# testsuite is a trainwreck; https://github.com/enthought/mayavi/issues/66
#RESTRICT="test"

PATCHES=( "${FILESDIR}"/${PN}-4.2.0-doc.patch )

python_compile_all() {
	if use doc; then
		${PYTHON} setup.py gen_docs || die
		${PYTHON} setup.py build_docs || die
	fi
}

python_test() {

	VIRTUALX_COMMAND="nosetests" virtualmake
}

python_install_all() {
	distutils-r1_python_install_all
	use doc && dohtml -r docs/build/mayavi/html/

	if use examples; then
		docompress -x usr/share/doc/${PF}/examples/
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	newicon mayavi/core/ui/images/m2.png mayavi2.png
	make_desktop_entry ${PN}2 \
		"Mayavi2 2D/3D Scientific Visualization" ${PN}2
}
