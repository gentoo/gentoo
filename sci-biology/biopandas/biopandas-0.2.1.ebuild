# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_PN="BioPandas"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Molecular Structures in Pandas DataFrames"
HOMEPAGE="
	https://rasbt.github.io/biopandas/
	https://github.com/rasbt/biopandas
	https://pypi.org/project/BioPandas/"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
	)"

python_test() {
	"${EPYTHON}" --version
	"${EPYTHON}" -c "import numpy; print('numpy %s' % numpy.__version__)"
	"${EPYTHON}" -c "import scipy; print('scipy %s' % scipy.__version__)"
	"${EPYTHON}" -c "import pandas; print('pandas %s' % pandas.__version__)"
	nosetests -s --verbose ${PN} || die
}
