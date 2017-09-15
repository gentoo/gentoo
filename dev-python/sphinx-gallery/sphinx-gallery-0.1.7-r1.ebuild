# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Sphinx extension to automatically generate an examples gallery"
HOMEPAGE="http://sphinx-gallery.readthedocs.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
# yes nose is somehow required besides testing
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/nose-1.0[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	# Remove setup_requires=['nose']
	sed -i -e /setup_requires/d setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	echo 'backend: agg' > matplotlibrc
	VARTEXFONTS="${T}"/fonts MPLCONFIGDIR="${BUILD_DIR}" \
			   nosetests -v || die
}
