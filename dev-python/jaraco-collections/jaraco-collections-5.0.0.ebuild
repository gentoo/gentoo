# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Models and classes to supplement the stdlib collections module"
HOMEPAGE="
	https://github.com/jaraco/jaraco.collections/
	https://pypi.org/project/jaraco.collections/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/jaraco-text[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-scm-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
