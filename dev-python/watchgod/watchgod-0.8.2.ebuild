# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_P=watchfiles-${PV}
DESCRIPTION="Simple, modern file watching and code reload in Python"
HOMEPAGE="
	https://pypi.org/project/watchgod/
	https://github.com/samuelcolvin/watchfiles/
"
SRC_URI="
	https://github.com/samuelcolvin/watchfiles/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	=dev-python/anyio-3*[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-toolbox[${PYTHON_USEDEP}]
		dev-python/trio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# increase timeout
	sed -e '/sleep/s/0.01/1.0/' -i tests/test_watch.py || die

	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_DESELECT=(
		# flaky test on slow systems, https://github.com/samuelcolvin/watchgod/issues/84
		tests/test_watch.py::test_awatch_log
	)
	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		tests/test_watch.py::test_does_not_exist
	)
	epytest
}
