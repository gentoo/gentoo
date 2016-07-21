# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python IDE with matlab-like features"
HOMEPAGE="https://code.google.com/p/spyderlib/ https://bitbucket.org/spyder-ide/spyderlib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc ipython matplotlib numpy pep8 +pyflakes pylint +rope scipy sphinx"

# rope requires no version bordering since all are >= miniumum version
RDEPEND="
	|| ( dev-python/PyQt4[${PYTHON_USEDEP},svg,webkit]
		 dev-python/pyside[${PYTHON_USEDEP},svg,webkit] )
	ipython? ( dev-python/ipython[qt4,${PYTHON_USEDEP}] )
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	pep8? ( dev-python/pep8[${PYTHON_USEDEP}] )
	pyflakes? ( >=dev-python/pyflakes-0.5[${PYTHON_USEDEP}] )
	pylint? ( dev-python/pylint[${PYTHON_USEDEP}] )
	rope? ( $(python_gen_cond_dep 'dev-python/rope[${PYTHON_USEDEP}]' python2_7) )
	scipy? ( sci-libs/scipy[${PYTHON_USEDEP}] )
	sphinx? ( >=dev-python/sphinx-0.6.0[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( >=dev-python/sphinx-0.6.0[${PYTHON_USEDEP}] )"

# Courtesy of Arfrever
PATCHES=( "${FILESDIR}"/${PN}-2.3.1-build.patch )

python_compile_all() {
	if use doc; then
		sphinx-build doc doc/html || die "Generation of documentation failed"
	fi
}

python_install_all() {
	distutils-r1_python_install_all
	doicon spyderlib/images/spyder.svg
	make_desktop_entry spyder Spyder spyder "Development;IDE"
	use doc && dodoc -r doc/html/
}
