# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python{3_6,3_7} )
inherit distutils-r1

DESCRIPTION="Extended pickling support for Python objects"
HOMEPAGE="https://pypi.org/project/cloudpickle/"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc x86 ~amd64-linux ~x86-linux"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	# -s unbreaks some tests
	# https://github.com/cloudpipe/cloudpickle/issues/252
	pytest -svv || die "Tests fail with ${EPYTHON}"
}
