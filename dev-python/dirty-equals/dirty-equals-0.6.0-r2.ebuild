# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1

DESCRIPTION="Doing dirty (but extremely useful) things with equals"
HOMEPAGE="
	https://dirty-equals.helpmanual.io/
	https://github.com/samuelcolvin/dirty-equals/
	https://pypi.org/project/dirty-equals/
"
SRC_URI="
	https://github.com/samuelcolvin/dirty-equals/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	<dev-python/pydantic-2[${PYTHON_USEDEP}]
	>=dev-python/pytz-2021.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# require unpackaged pytest-examples
		tests/test_docs.py
	)

	local -x TZ=UTC
	epytest
}
