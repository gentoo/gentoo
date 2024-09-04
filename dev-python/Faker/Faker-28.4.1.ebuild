# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A Python package that generates fake data for you"
HOMEPAGE="
	https://github.com/joke2k/faker/
	https://pypi.org/project/Faker/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/python-dateutil-2.4.2[${PYTHON_USEDEP}]
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
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=faker.contrib.pytest.plugin
	epytest
	epytest --exclusive-faker-session tests/pytest/session_overrides
}
