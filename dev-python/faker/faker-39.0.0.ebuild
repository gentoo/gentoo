# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=${PN^}
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A Python package that generates fake data for you"
HOMEPAGE="
	https://github.com/joke2k/faker/
	https://pypi.org/project/Faker/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/tzdata[${PYTHON_USEDEP}]
	!dev-ruby/faker
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},tiff]
		dev-python/validators[${PYTHON_USEDEP}]
	)
"

# note: tests are flaky with xdist
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" )
distutils_enable_tests pytest

python_test() {
	epytest
	epytest --exclusive-faker-session tests/pytest/session_overrides
}
