# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python wrapper for the Montage mosaicking toolkit"
HOMEPAGE="http://www.astropy.org/montage-wrapper/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	sci-astronomy/montage"
DEPEND="
	dev-python/astropy[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( sci-astronomy/montage )"

PATCHES=(
	"${FILESDIR}/${P}-increase_rtol.patch"
	"${FILESDIR}/${P}-fix_tests.patch"
	"${FILESDIR}/${P}-use_configparser.patch"
)

python_prepare_all() {
	# use system astropy-helpers instead of bundled one
	sed -i -e '/auto_use/s/True/False/' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && PYTHONPATH=".." emake -C docs html
}

python_test() {
	${EPYTHON} setup.py test
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
