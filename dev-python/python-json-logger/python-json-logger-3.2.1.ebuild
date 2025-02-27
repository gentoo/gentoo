# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Standard python logging to output log data as json objects"
HOMEPAGE="
	https://github.com/madzak/python-json-logger/
	https://pypi.org/project/python-json-logger/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/tzdata[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
