# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Extended pickling support for Python objects"
HOMEPAGE="
	https://github.com/cloudpipe/cloudpickle/
	https://pypi.org/project/cloudpickle/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTHONPATH=${PYTHONPATH}:tests/cloudpickle_testpkg
	# -s unbreaks some tests
	# https://github.com/cloudpipe/cloudpickle/issues/252
	epytest -s
}
