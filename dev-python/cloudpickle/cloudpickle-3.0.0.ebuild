# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Extended pickling support for Python objects"
HOMEPAGE="
	https://github.com/cloudpipe/cloudpickle/
	https://pypi.org/project/cloudpickle/
"
SRC_URI="
	https://github.com/cloudpipe/cloudpickle/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"

BDEPEND="
	test? (
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
