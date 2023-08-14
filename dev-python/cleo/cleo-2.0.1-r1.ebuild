# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python tool for building testable command-line interfaces"
HOMEPAGE="
	https://github.com/python-poetry/cleo/
	https://pypi.org/project/cleo/
"
SRC_URI="
	https://github.com/python-poetry/cleo/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/crashtest[${PYTHON_USEDEP}]
	dev-python/rapidfuzz[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# unpin rapidfuzz
	sed -i -e '/rapidfuzz/s:\^:>=:' pyproject.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_mock
	epytest
}
