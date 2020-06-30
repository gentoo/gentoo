# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="pKa-value prediction of ionizable groups in protein and protein-ligand complexes"
HOMEPAGE="https://github.com/jensengroup/propka"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND="test? (
			${RDEPEND}
			dev-python/pandas[${PYTHON_USEDEP}]
)"

python_prepare_all() {
	sed -e "/exclude/s:scripts:\', \'Tests:g" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd Tests || die
	${PYTHON} runtest.py || die
}

python_install_all() {
	distutils-r1_python_install_all
}
