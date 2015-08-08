# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

MYPN="${PN/scikits_/scikit-}"
MYP="${MYPN}-${PV}"

DESCRIPTION="Image processing routines for SciPy"
HOMEPAGE="http://scikit-image.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc freeimage gtk pyamg qt4 test"

RDEPEND="
	sci-libs/scipy[sparse,${PYTHON_USEDEP}]
	freeimage? ( media-libs/freeimage )
	gtk? ( dev-python/pygtk[$(python_gen_usedep 'python2*')] )
	pyamg? ( dev-python/pyamg[$(python_gen_usedep 'python2*')] )
	qt4? ( dev-python/PyQt4[${PYTHON_USEDEP}] )"
DEPEND="
	>=dev-python/cython-0.17[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		sci-libs/scipy[sparse,${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MYP}"

DOCS=( CONTRIBUTORS.txt CONTRIBUTING.txt DEPENDS.txt RELEASE.txt TASKS.txt TODO.txt )

python_test() {
	distutils_install_for_testing
	mkdir for_test && cd for_test
	echo "backend : Agg" > matplotlibrc || die
	MPLCONFIGDIR=. nosetests --exe -v  --cover-package=skimage skimage || die
}
