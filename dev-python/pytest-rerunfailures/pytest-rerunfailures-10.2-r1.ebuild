# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="pytest plugin to re-run tests to eliminate flaky failures"
HOMEPAGE="
	https://github.com/pytest-dev/pytest-rerunfailures/
	https://pypi.org/project/pytest-rerunfailures/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MPL-2.0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local -x PYTEST_PLUGINS=pytest_rerunfailures
	if has_version "dev-python/pytest-xdist[${PYTHON_USEDEP}]"; then
		PYTEST_PLUGINS+=,xdist.plugin
	fi
	epytest
}
