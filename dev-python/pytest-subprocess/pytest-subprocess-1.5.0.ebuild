# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="A plugin to fake subprocess for pytest"
HOMEPAGE="
	https://github.com/aklajnert/pytest-subprocess/
	https://pypi.org/project/pytest-subprocess/
"
SRC_URI="
	https://github.com/aklajnert/pytest-subprocess/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/pytest-4.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/anyio[${PYTHON_USEDEP}]
		>=dev-python/docutils-0.12[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.15.1[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest -p no:flaky
}
