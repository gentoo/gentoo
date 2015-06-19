# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scikits_image/scikits_image-0.10.1.ebuild,v 1.3 2015/04/08 18:49:15 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

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
	dev-python/six[${PYTHON_USEDEP}]
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
		sci-libs/scipy[sparse,${PYTHON_USEDEP}]
		)"

S="${WORKDIR}/${MYP}"

DOCS=( CONTRIBUTORS.txt CONTRIBUTING.txt DEPENDS.txt RELEASE.txt TASKS.txt TODO.txt )

python_test() {
	distutils_install_for_testing
	mkdir for_test && cd for_test
	echo "backend : Agg" > matplotlibrc || die
	echo "backend.qt4 : PyQt4" >> matplotlibrc || die
	MPLCONFIGDIR=. nosetests --exe -v  --cover-package=skimage skimage || die
}
